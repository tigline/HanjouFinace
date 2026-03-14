import 'package:core_foundation/core_foundation.dart';

import '../contracts/device_biometric_authenticator.dart';
import '../contracts/identity_auth_state_store.dart';
import '../contracts/liveness_collector.dart';
import '../models/identity_auth_run_result.dart';
import '../real_person/real_person_gateway.dart';
import '../real_person/real_person_models.dart';

class IdentityAuthCoordinator {
  IdentityAuthCoordinator({
    required RealPersonGateway apiGateway,
    required IdentityAuthStateStore stateStore,
    DeviceBiometricAuthenticator? biometricAuthenticator,
    LivenessCollector? livenessCollector,
    IdentityAuthFlow flow = const IdentityAuthFlow(),
    this.markDeviceBiometricEnabledOnSuccess = true,
  }) : _apiGateway = apiGateway,
       _stateStore = stateStore,
       _biometricAuthenticator = biometricAuthenticator,
       _livenessCollector = livenessCollector,
       _flow = flow;

  final RealPersonGateway _apiGateway;
  final IdentityAuthStateStore _stateStore;
  final DeviceBiometricAuthenticator? _biometricAuthenticator;
  final LivenessCollector? _livenessCollector;
  final IdentityAuthFlow _flow;
  final bool markDeviceBiometricEnabledOnSuccess;

  Future<IdentityAuthDecision> evaluate({
    required IdentityAuthEntryPoint entryPoint,
  }) async {
    final snapshot = await _stateStore.readSnapshot();
    return _flow.decide(entryPoint: entryPoint, snapshot: snapshot);
  }

  Future<IdentityAuthRunResult> authenticateSensitiveAction({
    String? identifyGroupId,
  }) async {
    final initial = await evaluate(
      entryPoint: IdentityAuthEntryPoint.sensitiveAction,
    );

    switch (initial.action) {
      case IdentityAuthAction.startRealPersonEnrollment:
        return IdentityAuthRunResult(
          action: initial.action,
          reasonCode: initial.reasonCode,
        );
      case IdentityAuthAction.requestDeviceBiometric:
        final authenticator = _biometricAuthenticator;
        if (authenticator == null) {
          return IdentityAuthRunResult(
            action: IdentityAuthAction.requestDeviceBiometric,
            reasonCode: 'biometric_authenticator_not_configured',
          );
        }
        final biometricResult = await authenticator.authenticate();
        final afterBiometric = _flow.afterDeviceBiometric(biometricResult);
        if (afterBiometric.action == IdentityAuthAction.allowTargetAction) {
          return IdentityAuthRunResult(
            action: afterBiometric.action,
            reasonCode: afterBiometric.reasonCode,
            verified: true,
          );
        }
        if (afterBiometric.action ==
            IdentityAuthAction.startLivenessVerification) {
          return _verifyViaLiveness(
            entryPoint: IdentityAuthEntryPoint.sensitiveAction,
            groupId: identifyGroupId,
          );
        }
        return IdentityAuthRunResult(
          action: afterBiometric.action,
          reasonCode: afterBiometric.reasonCode,
        );
      case IdentityAuthAction.startLivenessVerification:
        return _verifyViaLiveness(
          entryPoint: IdentityAuthEntryPoint.sensitiveAction,
          groupId: identifyGroupId,
        );
      case IdentityAuthAction.allowTargetAction:
      case IdentityAuthAction.none:
        return IdentityAuthRunResult(
          action: IdentityAuthAction.allowTargetAction,
          reasonCode: initial.reasonCode,
          verified: true,
        );
      case IdentityAuthAction.block:
        return IdentityAuthRunResult(
          action: IdentityAuthAction.block,
          reasonCode: initial.reasonCode,
        );
    }
  }

  Future<IdentityAuthRunResult> verifyWithPhotoBase64({
    required String photoBase64,
    required IdentityAuthEntryPoint entryPoint,
    String? groupId,
  }) async {
    final normalized = photoBase64.trim();
    if (normalized.isEmpty) {
      return const IdentityAuthRunResult(
        action: IdentityAuthAction.block,
        reasonCode: 'empty_liveness_photo',
        errorMessage: 'Liveness photo is empty.',
      );
    }

    try {
      final identify = await _apiGateway.identify(
        RealPersonIdentifyRequest(photoBase64: normalized, groupId: groupId),
      );
      if (!identify.isVerified) {
        return IdentityAuthRunResult(
          action: IdentityAuthAction.block,
          reasonCode: 'real_person_identify_failed',
          identifyResponse: identify,
          errorMessage: 'Real-person identify did not return valid userId.',
        );
      }

      await _markVerifiedAfterIdentifySuccess();

      final action = entryPoint == IdentityAuthEntryPoint.sensitiveAction
          ? IdentityAuthAction.allowTargetAction
          : IdentityAuthAction.none;
      return IdentityAuthRunResult(
        action: action,
        reasonCode: 'real_person_identify_succeeded',
        verified: true,
        identifyResponse: identify,
      );
    } catch (error) {
      return IdentityAuthRunResult(
        action: IdentityAuthAction.block,
        reasonCode: 'real_person_identify_error',
        errorMessage: error.toString(),
      );
    }
  }

  Future<IdentityAuthRunResult> completeRealPersonEnrollment({
    required bool succeeded,
    required IdentityAuthEntryPoint entryPoint,
  }) async {
    final decision = _flow.afterRealPersonEnrollment(
      entryPoint: entryPoint,
      succeeded: succeeded,
    );
    if (!succeeded) {
      return IdentityAuthRunResult(
        action: decision.action,
        reasonCode: decision.reasonCode,
      );
    }
    await _markVerifiedAfterIdentifySuccess();
    return IdentityAuthRunResult(
      action: decision.action,
      reasonCode: decision.reasonCode,
      verified: true,
    );
  }

  Future<Map<String, dynamic>> uploadRealPersonPhoto({
    required String filePath,
  }) {
    return _apiGateway.uploadPhoto(filePath: filePath);
  }

  Future<Map<String, dynamic>> uploadRealPersonUserIdPhoto({
    required String filePath,
  }) {
    return _apiGateway.uploadPhotoForUserId(filePath: filePath);
  }

  Future<String> fetchRealPersonToken({required String bizId}) {
    return _apiGateway.fetchToken(bizId: bizId);
  }

  Future<Map<String, dynamic>> fetchRealPersonResult({required String bizId}) {
    return _apiGateway.fetchResult(bizId: bizId);
  }

  Future<Map<String, dynamic>> fetchRealPersonVerifyImage({
    required int userId,
  }) {
    return _apiGateway.fetchVerifyImage(userId: userId);
  }

  Future<IdentityAuthRunResult> _verifyViaLiveness({
    required IdentityAuthEntryPoint entryPoint,
    String? groupId,
  }) async {
    final collector = _livenessCollector;
    if (collector == null) {
      return const IdentityAuthRunResult(
        action: IdentityAuthAction.startLivenessVerification,
        reasonCode: 'liveness_collector_not_configured',
      );
    }
    final collectResult = await collector.collect();
    if (!collectResult.isSuccess) {
      return IdentityAuthRunResult(
        action: IdentityAuthAction.block,
        reasonCode: 'liveness_collect_failed',
        errorMessage: collectResult.errorMessage,
      );
    }
    return verifyWithPhotoBase64(
      photoBase64: collectResult.photoBase64,
      entryPoint: entryPoint,
      groupId: groupId,
    );
  }

  Future<void> _markVerifiedAfterIdentifySuccess() async {
    final current = await _stateStore.readSnapshot();
    await _stateStore.writeSnapshot(
      current.copyWith(
        realPersonVerified: true,
        currentDeviceBiometricEnabled: markDeviceBiometricEnabledOnSuccess
            ? true
            : current.currentDeviceBiometricEnabled,
      ),
    );
  }
}
