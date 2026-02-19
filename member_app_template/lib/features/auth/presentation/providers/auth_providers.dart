import 'package:core_network/core_network.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/auth/persistent_token_store.dart';
import '../../../../app/storage/app_storage_providers.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_with_code_usecase.dart';
import '../../domain/usecases/send_login_code_usecase.dart';
import '../controllers/auth_controller.dart';
import '../state/auth_state.dart';

final tokenStoreProvider = Provider<TokenStore>((ref) {
  return PersistentTokenStore(ref.watch(secureKeyValueStorageProvider));
});

final tokenRefresherProvider = Provider<TokenRefresher>((ref) {
  return EndpointTokenRefresher(Dio(), refreshPath: '/v1/auth/refresh');
});

final coreHttpClientProvider = Provider<CoreHttpClient>((ref) {
  return CoreHttpClient(
    baseUrl: 'https://api.example.com',
    tokenStore: ref.watch(tokenStoreProvider),
    tokenRefresher: ref.watch(tokenRefresherProvider),
  );
});

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(ref.watch(coreHttpClientProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remote: ref.watch(authRemoteDataSourceProvider),
    tokenStore: ref.watch(tokenStoreProvider),
  );
});

final sendLoginCodeUseCaseProvider = Provider<SendLoginCodeUseCase>((ref) {
  return SendLoginCodeUseCase(ref.watch(authRepositoryProvider));
});

final loginWithCodeUseCaseProvider = Provider<LoginWithCodeUseCase>((ref) {
  return LoginWithCodeUseCase(ref.watch(authRepositoryProvider));
});

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    return AuthController(
      ref.watch(sendLoginCodeUseCaseProvider),
      ref.watch(loginWithCodeUseCaseProvider),
    );
  },
);

final isAuthenticatedProvider = FutureProvider<bool>((ref) async {
  final tokenStore = ref.watch(tokenStoreProvider);
  final accessToken = await tokenStore.readAccessToken();
  return accessToken != null && accessToken.isNotEmpty;
});
