import 'package:core_identity_auth/core_identity_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/storage/app_storage_providers.dart';
import '../../data/adapters/auth_identity_auth_state_store.dart';
import '../../data/adapters/baidu_face_liveness_collector.dart';
import 'auth_providers.dart';

final identityAuthFlowPolicyProvider = Provider<IdentityAuthFlowPolicy>((ref) {
  return const IdentityAuthFlowPolicy();
});

final identityAuthFlowProvider = Provider<IdentityAuthFlow>((ref) {
  return IdentityAuthFlow(policy: ref.watch(identityAuthFlowPolicyProvider));
});

final realPersonEndpointsProvider = Provider<RealPersonEndpoints>((ref) {
  return const RealPersonEndpoints();
});

final realPersonApiGatewayProvider = Provider<RealPersonGateway>((ref) {
  return RealPersonApiClient(
    client: ref.watch(coreHttpClientProvider),
    endpoints: ref.watch(realPersonEndpointsProvider),
  );
});

final identityAuthStateStoreProvider = Provider<IdentityAuthStateStore>((ref) {
  return AuthIdentityAuthStateStore(
    largeDataStore: ref.watch(largeDataStoreProvider),
    authLocalDataSource: ref.watch(authLocalDataSourceProvider),
  );
});

final baiduFaceLicenseIdProvider = Provider<String?>((ref) {
  const value = String.fromEnvironment(
    'BAIDU_FACE_LICENSE_ID',
    defaultValue: '',
  );
  final normalized = value.trim();
  return normalized.isEmpty ? null : normalized;
});

final identityAuthBiometricAuthenticatorProvider =
    Provider<DeviceBiometricAuthenticator?>((ref) {
      return null;
    });

final identityAuthLivenessCollectorProvider = Provider<LivenessCollector?>((
  ref,
) {
  final licenseId = ref.watch(baiduFaceLicenseIdProvider);
  if (licenseId == null || licenseId.trim().isEmpty) {
    return null;
  }
  return BaiduFaceLivenessCollector(licenseId: licenseId);
});

final identityAuthCoordinatorProvider = Provider<IdentityAuthCoordinator>((
  ref,
) {
  return IdentityAuthCoordinator(
    apiGateway: ref.watch(realPersonApiGatewayProvider),
    stateStore: ref.watch(identityAuthStateStoreProvider),
    biometricAuthenticator: ref.watch(
      identityAuthBiometricAuthenticatorProvider,
    ),
    livenessCollector: ref.watch(identityAuthLivenessCollectorProvider),
    flow: ref.watch(identityAuthFlowProvider),
  );
});
