import 'package:core_identity_auth/core_identity_auth.dart';
import 'package:test/test.dart';

void main() {
  group('IdentityAuthCoordinator.evaluate', () {
    test(
      'returns enrollment action when sensitive action requires real-person',
      () async {
        final coordinator = IdentityAuthCoordinator(
          apiGateway: _FakeGateway(),
          stateStore: _InMemoryStateStore(
            const IdentityAuthSnapshot(
              realPersonVerified: false,
              currentDeviceBiometricEnabled: false,
            ),
          ),
        );

        final decision = await coordinator.evaluate(
          entryPoint: IdentityAuthEntryPoint.sensitiveAction,
        );

        expect(decision.action, IdentityAuthAction.startRealPersonEnrollment);
        expect(decision.reasonCode, 'sensitive_action_requires_real_person');
      },
    );
  });

  group('IdentityAuthCoordinator.authenticateSensitiveAction', () {
    test('allows immediately when device biometric succeeds', () async {
      final coordinator = IdentityAuthCoordinator(
        apiGateway: _FakeGateway(),
        stateStore: _InMemoryStateStore(
          const IdentityAuthSnapshot(
            realPersonVerified: true,
            currentDeviceBiometricEnabled: true,
          ),
        ),
        biometricAuthenticator: _FakeBiometricAuthenticator(
          DeviceBiometricResult.succeeded,
        ),
      );

      final result = await coordinator.authenticateSensitiveAction();

      expect(result.action, IdentityAuthAction.allowTargetAction);
      expect(result.verified, isTrue);
      expect(result.reasonCode, 'device_biometric_succeeded');
    });

    test('falls back to liveness and identify when biometric fails', () async {
      final gateway = _FakeGateway(
        identifyHandler: (_) async => const RealPersonIdentifyResponse(
          userId: 123,
          rawData: <String, dynamic>{'userId': 123},
        ),
      );
      final stateStore = _InMemoryStateStore(
        const IdentityAuthSnapshot(
          realPersonVerified: true,
          currentDeviceBiometricEnabled: true,
        ),
      );
      final livenessCollector = _FakeLivenessCollector(
        const LivenessCollectResult(photoBase64: 'base64-photo'),
      );
      final coordinator = IdentityAuthCoordinator(
        apiGateway: gateway,
        stateStore: stateStore,
        biometricAuthenticator: _FakeBiometricAuthenticator(
          DeviceBiometricResult.failed,
        ),
        livenessCollector: livenessCollector,
      );

      final result = await coordinator.authenticateSensitiveAction(
        identifyGroupId: 'group-a',
      );

      expect(result.action, IdentityAuthAction.allowTargetAction);
      expect(result.verified, isTrue);
      expect(result.reasonCode, 'real_person_identify_succeeded');
      expect(gateway.identifyCallCount, 1);
      expect(livenessCollector.collectCallCount, 1);
      expect(stateStore.lastWrittenSnapshot?.realPersonVerified, isTrue);
      expect(
        stateStore.lastWrittenSnapshot?.currentDeviceBiometricEnabled,
        isTrue,
      );
    });

    test(
      'returns configured failure when liveness collector is missing',
      () async {
        final coordinator = IdentityAuthCoordinator(
          apiGateway: _FakeGateway(),
          stateStore: _InMemoryStateStore(
            const IdentityAuthSnapshot(
              realPersonVerified: true,
              currentDeviceBiometricEnabled: false,
            ),
          ),
        );

        final result = await coordinator.authenticateSensitiveAction();

        expect(result.action, IdentityAuthAction.startLivenessVerification);
        expect(result.reasonCode, 'liveness_collector_not_configured');
        expect(result.verified, isFalse);
      },
    );
  });

  group('IdentityAuthCoordinator.verifyWithPhotoBase64', () {
    test('blocks with explicit reason when photo is empty', () async {
      final coordinator = IdentityAuthCoordinator(
        apiGateway: _FakeGateway(),
        stateStore: _InMemoryStateStore(
          const IdentityAuthSnapshot(
            realPersonVerified: false,
            currentDeviceBiometricEnabled: false,
          ),
        ),
      );

      final result = await coordinator.verifyWithPhotoBase64(
        photoBase64: '   ',
        entryPoint: IdentityAuthEntryPoint.sensitiveAction,
      );

      expect(result.action, IdentityAuthAction.block);
      expect(result.reasonCode, 'empty_liveness_photo');
      expect(result.verified, isFalse);
    });
  });
}

class _InMemoryStateStore implements IdentityAuthStateStore {
  _InMemoryStateStore(this._snapshot);

  IdentityAuthSnapshot _snapshot;
  IdentityAuthSnapshot? lastWrittenSnapshot;

  @override
  Future<IdentityAuthSnapshot> readSnapshot() async => _snapshot;

  @override
  Future<void> writeSnapshot(IdentityAuthSnapshot snapshot) async {
    _snapshot = snapshot;
    lastWrittenSnapshot = snapshot;
  }
}

class _FakeBiometricAuthenticator implements DeviceBiometricAuthenticator {
  _FakeBiometricAuthenticator(this.result);

  final DeviceBiometricResult result;

  @override
  Future<DeviceBiometricResult> authenticate() async => result;
}

class _FakeLivenessCollector implements LivenessCollector {
  _FakeLivenessCollector(this.result);

  final LivenessCollectResult result;
  int collectCallCount = 0;

  @override
  Future<LivenessCollectResult> collect() async {
    collectCallCount += 1;
    return result;
  }
}

class _FakeGateway implements RealPersonGateway {
  _FakeGateway({this.identifyHandler});

  final Future<RealPersonIdentifyResponse> Function(
    RealPersonIdentifyRequest request,
  )?
  identifyHandler;

  int identifyCallCount = 0;

  @override
  Future<Map<String, dynamic>> fetchResult({required String bizId}) async {
    return <String, dynamic>{'bizId': bizId};
  }

  @override
  Future<String> fetchToken({required String bizId}) async {
    return 'token-$bizId';
  }

  @override
  Future<Map<String, dynamic>> fetchVerifyImage({required int userId}) async {
    return <String, dynamic>{'userId': userId};
  }

  @override
  Future<RealPersonIdentifyResponse> identify(
    RealPersonIdentifyRequest request,
  ) async {
    identifyCallCount += 1;
    if (identifyHandler != null) {
      return identifyHandler!(request);
    }
    return const RealPersonIdentifyResponse(
      userId: null,
      rawData: <String, dynamic>{},
    );
  }

  @override
  Future<Map<String, dynamic>> uploadPhoto({required String filePath}) async {
    return <String, dynamic>{'filePath': filePath};
  }

  @override
  Future<Map<String, dynamic>> uploadPhotoForUserId({
    required String filePath,
  }) async {
    return <String, dynamic>{'filePath': filePath};
  }
}
