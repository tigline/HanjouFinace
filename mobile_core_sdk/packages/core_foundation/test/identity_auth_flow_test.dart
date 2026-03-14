import 'package:core_foundation/core_foundation.dart';
import 'package:test/test.dart';

void main() {
  group('IdentityAuthSnapshot.fromLegacyFlags', () {
    test('maps legacy int flags with verified code 1', () {
      final snapshot = IdentityAuthSnapshot.fromLegacyFlags(
        verificationStatus: 1,
        currentDeviceVerificationStatus: 0,
      );

      expect(snapshot.realPersonVerified, isTrue);
      expect(snapshot.currentDeviceBiometricEnabled, isFalse);
    });

    test('supports bool/string values', () {
      final snapshot = IdentityAuthSnapshot.fromLegacyFlags(
        verificationStatus: 'true',
        currentDeviceVerificationStatus: true,
      );

      expect(snapshot.realPersonVerified, isTrue);
      expect(snapshot.currentDeviceBiometricEnabled, isTrue);
    });
  });

  group('IdentityAuthFlow decide', () {
    test('security center unverified -> start real-person enrollment', () {
      const flow = IdentityAuthFlow();
      final decision = flow.decide(
        entryPoint: IdentityAuthEntryPoint.securityCenterRealPerson,
        snapshot: const IdentityAuthSnapshot(
          realPersonVerified: false,
          currentDeviceBiometricEnabled: false,
        ),
      );

      expect(decision.action, IdentityAuthAction.startRealPersonEnrollment);
      expect(decision.reasonCode, 'security_center_requires_real_person');
    });

    test('security center verified -> no action', () {
      const flow = IdentityAuthFlow();
      final decision = flow.decide(
        entryPoint: IdentityAuthEntryPoint.securityCenterRealPerson,
        snapshot: const IdentityAuthSnapshot(
          realPersonVerified: true,
          currentDeviceBiometricEnabled: true,
        ),
      );

      expect(decision.action, IdentityAuthAction.none);
      expect(decision.reasonCode, 'security_center_already_verified');
    });

    test('sensitive action unverified -> start real-person enrollment', () {
      const flow = IdentityAuthFlow();
      final decision = flow.decide(
        entryPoint: IdentityAuthEntryPoint.sensitiveAction,
        snapshot: const IdentityAuthSnapshot(
          realPersonVerified: false,
          currentDeviceBiometricEnabled: true,
        ),
      );

      expect(decision.action, IdentityAuthAction.startRealPersonEnrollment);
      expect(decision.reasonCode, 'sensitive_action_requires_real_person');
    });

    test(
      'sensitive action verified and biometric enabled -> request biometric',
      () {
        const flow = IdentityAuthFlow();
        final decision = flow.decide(
          entryPoint: IdentityAuthEntryPoint.sensitiveAction,
          snapshot: const IdentityAuthSnapshot(
            realPersonVerified: true,
            currentDeviceBiometricEnabled: true,
          ),
        );

        expect(decision.action, IdentityAuthAction.requestDeviceBiometric);
        expect(
          decision.reasonCode,
          'sensitive_action_prefers_device_biometric',
        );
      },
    );

    test('sensitive action verified and biometric disabled -> liveness', () {
      const flow = IdentityAuthFlow();
      final decision = flow.decide(
        entryPoint: IdentityAuthEntryPoint.sensitiveAction,
        snapshot: const IdentityAuthSnapshot(
          realPersonVerified: true,
          currentDeviceBiometricEnabled: false,
        ),
      );

      expect(decision.action, IdentityAuthAction.startLivenessVerification);
      expect(decision.reasonCode, 'sensitive_action_fallback_to_liveness');
    });
  });

  group('IdentityAuthFlow afterDeviceBiometric', () {
    test('succeeded -> allow target action', () {
      const flow = IdentityAuthFlow();
      final decision = flow.afterDeviceBiometric(
        DeviceBiometricResult.succeeded,
      );

      expect(decision.action, IdentityAuthAction.allowTargetAction);
      expect(decision.reasonCode, 'device_biometric_succeeded');
    });

    test('failed with fallback enabled -> liveness', () {
      const flow = IdentityAuthFlow();
      final decision = flow.afterDeviceBiometric(DeviceBiometricResult.failed);

      expect(decision.action, IdentityAuthAction.startLivenessVerification);
      expect(
        decision.reasonCode,
        'device_biometric_failed_fallback_to_liveness',
      );
    });

    test('failed with fallback disabled -> block', () {
      const flow = IdentityAuthFlow(
        policy: IdentityAuthFlowPolicy(
          fallbackToLivenessOnBiometricFailure: false,
        ),
      );
      final decision = flow.afterDeviceBiometric(DeviceBiometricResult.failed);

      expect(decision.action, IdentityAuthAction.block);
      expect(decision.reasonCode, 'device_biometric_failed_blocked');
    });
  });

  group('IdentityAuthFlow afterRealPersonEnrollment', () {
    test('failed enrollment -> block', () {
      const flow = IdentityAuthFlow();
      final decision = flow.afterRealPersonEnrollment(
        entryPoint: IdentityAuthEntryPoint.sensitiveAction,
        succeeded: false,
      );

      expect(decision.action, IdentityAuthAction.block);
      expect(decision.reasonCode, 'real_person_enrollment_failed');
    });

    test('security center success -> none', () {
      const flow = IdentityAuthFlow();
      final decision = flow.afterRealPersonEnrollment(
        entryPoint: IdentityAuthEntryPoint.securityCenterRealPerson,
        succeeded: true,
      );

      expect(decision.action, IdentityAuthAction.none);
      expect(decision.reasonCode, 'security_center_real_person_completed');
    });

    test('sensitive action success default -> allow target action', () {
      const flow = IdentityAuthFlow();
      final decision = flow.afterRealPersonEnrollment(
        entryPoint: IdentityAuthEntryPoint.sensitiveAction,
        succeeded: true,
      );

      expect(decision.action, IdentityAuthAction.allowTargetAction);
      expect(decision.reasonCode, 'sensitive_action_allow_after_real_person');
    });

    test(
      'sensitive action success and policy disallow direct allow -> re-decide',
      () {
        const flow = IdentityAuthFlow(
          policy: IdentityAuthFlowPolicy(
            allowTargetAfterRealPersonEnrollment: false,
          ),
        );
        final decision = flow.afterRealPersonEnrollment(
          entryPoint: IdentityAuthEntryPoint.sensitiveAction,
          succeeded: true,
          snapshotAfterSuccess: const IdentityAuthSnapshot(
            realPersonVerified: true,
            currentDeviceBiometricEnabled: true,
          ),
        );

        expect(decision.action, IdentityAuthAction.requestDeviceBiometric);
        expect(
          decision.reasonCode,
          'sensitive_action_prefers_device_biometric',
        );
      },
    );
  });
}
