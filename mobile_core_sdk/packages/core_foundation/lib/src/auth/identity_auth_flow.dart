enum IdentityAuthEntryPoint { securityCenterRealPerson, sensitiveAction }

enum IdentityAuthAction {
  none,
  startRealPersonEnrollment,
  requestDeviceBiometric,
  startLivenessVerification,
  allowTargetAction,
  block,
}

enum DeviceBiometricResult { succeeded, failed, canceled, unavailable }

class IdentityAuthSnapshot {
  const IdentityAuthSnapshot({
    required this.realPersonVerified,
    required this.currentDeviceBiometricEnabled,
  });

  factory IdentityAuthSnapshot.fromLegacyFlags({
    required Object? verificationStatus,
    required Object? currentDeviceVerificationStatus,
    int verifiedCode = 1,
  }) {
    return IdentityAuthSnapshot(
      realPersonVerified: _matchesVerifiedFlag(
        verificationStatus,
        verifiedCode: verifiedCode,
      ),
      currentDeviceBiometricEnabled: _matchesVerifiedFlag(
        currentDeviceVerificationStatus,
        verifiedCode: verifiedCode,
      ),
    );
  }

  final bool realPersonVerified;
  final bool currentDeviceBiometricEnabled;

  IdentityAuthSnapshot copyWith({
    bool? realPersonVerified,
    bool? currentDeviceBiometricEnabled,
  }) {
    return IdentityAuthSnapshot(
      realPersonVerified: realPersonVerified ?? this.realPersonVerified,
      currentDeviceBiometricEnabled:
          currentDeviceBiometricEnabled ?? this.currentDeviceBiometricEnabled,
    );
  }

  static bool _matchesVerifiedFlag(Object? value, {required int verifiedCode}) {
    if (value == null) {
      return false;
    }
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value.toInt() == verifiedCode;
    }
    final normalized = value.toString().trim().toLowerCase();
    if (normalized.isEmpty) {
      return false;
    }
    if (normalized == 'true') {
      return true;
    }
    final parsed = int.tryParse(normalized);
    return parsed == verifiedCode;
  }
}

class IdentityAuthFlowPolicy {
  const IdentityAuthFlowPolicy({
    this.fallbackToLivenessOnBiometricFailure = true,
    this.allowTargetAfterRealPersonEnrollment = true,
  });

  final bool fallbackToLivenessOnBiometricFailure;
  final bool allowTargetAfterRealPersonEnrollment;
}

class IdentityAuthDecision {
  const IdentityAuthDecision({required this.action, required this.reasonCode});

  final IdentityAuthAction action;
  final String reasonCode;
}

/// Shared decision engine for "real-person verification + sensitive action auth".
///
/// This state machine is UI-agnostic and reusable across apps.
/// Apps only need to map each [IdentityAuthAction] to their route/callback:
/// - `startRealPersonEnrollment` -> e.g. `/real-auth` or `/upload-photo`
/// - `requestDeviceBiometric` -> FaceID/TouchID prompt
/// - `startLivenessVerification` -> e.g. `/face-auth`
/// - `allowTargetAction` -> continue target flow
class IdentityAuthFlow {
  const IdentityAuthFlow({this.policy = const IdentityAuthFlowPolicy()});

  final IdentityAuthFlowPolicy policy;

  IdentityAuthDecision decide({
    required IdentityAuthEntryPoint entryPoint,
    required IdentityAuthSnapshot snapshot,
  }) {
    switch (entryPoint) {
      case IdentityAuthEntryPoint.securityCenterRealPerson:
        if (snapshot.realPersonVerified) {
          return const IdentityAuthDecision(
            action: IdentityAuthAction.none,
            reasonCode: 'security_center_already_verified',
          );
        }
        return const IdentityAuthDecision(
          action: IdentityAuthAction.startRealPersonEnrollment,
          reasonCode: 'security_center_requires_real_person',
        );
      case IdentityAuthEntryPoint.sensitiveAction:
        if (!snapshot.realPersonVerified) {
          return const IdentityAuthDecision(
            action: IdentityAuthAction.startRealPersonEnrollment,
            reasonCode: 'sensitive_action_requires_real_person',
          );
        }
        if (snapshot.currentDeviceBiometricEnabled) {
          return const IdentityAuthDecision(
            action: IdentityAuthAction.requestDeviceBiometric,
            reasonCode: 'sensitive_action_prefers_device_biometric',
          );
        }
        return const IdentityAuthDecision(
          action: IdentityAuthAction.startLivenessVerification,
          reasonCode: 'sensitive_action_fallback_to_liveness',
        );
    }
  }

  IdentityAuthDecision afterDeviceBiometric(DeviceBiometricResult result) {
    if (result == DeviceBiometricResult.succeeded) {
      return const IdentityAuthDecision(
        action: IdentityAuthAction.allowTargetAction,
        reasonCode: 'device_biometric_succeeded',
      );
    }

    if (policy.fallbackToLivenessOnBiometricFailure) {
      return const IdentityAuthDecision(
        action: IdentityAuthAction.startLivenessVerification,
        reasonCode: 'device_biometric_failed_fallback_to_liveness',
      );
    }

    return const IdentityAuthDecision(
      action: IdentityAuthAction.block,
      reasonCode: 'device_biometric_failed_blocked',
    );
  }

  IdentityAuthDecision afterRealPersonEnrollment({
    required IdentityAuthEntryPoint entryPoint,
    required bool succeeded,
    IdentityAuthSnapshot? snapshotAfterSuccess,
  }) {
    if (!succeeded) {
      return const IdentityAuthDecision(
        action: IdentityAuthAction.block,
        reasonCode: 'real_person_enrollment_failed',
      );
    }

    if (entryPoint == IdentityAuthEntryPoint.securityCenterRealPerson) {
      return const IdentityAuthDecision(
        action: IdentityAuthAction.none,
        reasonCode: 'security_center_real_person_completed',
      );
    }

    if (policy.allowTargetAfterRealPersonEnrollment) {
      return const IdentityAuthDecision(
        action: IdentityAuthAction.allowTargetAction,
        reasonCode: 'sensitive_action_allow_after_real_person',
      );
    }

    final nextSnapshot =
        snapshotAfterSuccess ??
        const IdentityAuthSnapshot(
          realPersonVerified: true,
          currentDeviceBiometricEnabled: false,
        );
    return decide(
      entryPoint: entryPoint,
      snapshot: nextSnapshot.copyWith(realPersonVerified: true),
    );
  }
}
