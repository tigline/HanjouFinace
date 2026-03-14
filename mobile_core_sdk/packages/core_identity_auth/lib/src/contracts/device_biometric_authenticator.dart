import 'package:core_foundation/core_foundation.dart';

abstract class DeviceBiometricAuthenticator {
  Future<DeviceBiometricResult> authenticate();
}
