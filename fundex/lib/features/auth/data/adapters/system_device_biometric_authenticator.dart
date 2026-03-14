import 'package:core_identity_auth/core_identity_auth.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class SystemDeviceBiometricAuthenticator
    implements DeviceBiometricAuthenticator {
  SystemDeviceBiometricAuthenticator({
    required String localizedReason,
    LocalAuthentication? localAuthentication,
    AuthenticationOptions options = const AuthenticationOptions(
      biometricOnly: true,
      stickyAuth: false,
      useErrorDialogs: true,
      sensitiveTransaction: true,
    ),
  }) : _localizedReason = localizedReason.trim().isEmpty
           ? 'Authenticate to continue.'
           : localizedReason.trim(),
       _localAuthentication = localAuthentication ?? LocalAuthentication(),
       _options = options;

  final String _localizedReason;
  final LocalAuthentication _localAuthentication;
  final AuthenticationOptions _options;

  @override
  Future<DeviceBiometricResult> authenticate() async {
    try {
      final isSupported = await _localAuthentication.isDeviceSupported();
      final canCheckBiometrics = await _localAuthentication.canCheckBiometrics;
      if (!isSupported || !canCheckBiometrics) {
        return DeviceBiometricResult.unavailable;
      }

      final didAuthenticate = await _localAuthentication.authenticate(
        localizedReason: _localizedReason,
        options: _options,
      );
      return didAuthenticate
          ? DeviceBiometricResult.succeeded
          : DeviceBiometricResult.canceled;
    } on PlatformException catch (error) {
      final code = error.code.toLowerCase();
      if (_isUnavailableCode(code)) {
        return DeviceBiometricResult.unavailable;
      }
      if (_isCanceledCode(code)) {
        return DeviceBiometricResult.canceled;
      }
      return DeviceBiometricResult.failed;
    } catch (_) {
      return DeviceBiometricResult.failed;
    }
  }

  bool _isUnavailableCode(String code) {
    return code.contains('notavailable') ||
        code.contains('notenrolled') ||
        code.contains('passcodenotset') ||
        code.contains('nohardware') ||
        code.contains('temporarylockout') ||
        code.contains('permanentlockout');
  }

  bool _isCanceledCode(String code) {
    return code.contains('usercancel') ||
        code.contains('user_cancel') ||
        code.contains('systemcancel') ||
        code.contains('system_cancel') ||
        code.contains('canceled') ||
        code.contains('cancelled');
  }
}
