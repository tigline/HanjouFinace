import 'dart:async';

import 'package:core_network/core_network.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/auth/app_auth_failure_handler.dart';
import '../../../../app/auth/persistent_token_store.dart';
import '../../../../app/config/api_paths.dart';
import '../../../../app/config/environment_provider.dart';
import '../../../../app/network/app_observability_interceptor.dart';
import '../../../../app/observability/app_observability_providers.dart';
import '../../../../app/storage/app_storage_providers.dart';
import '../../data/datasources/auth_local_data_source.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/register_account_usecase.dart';
import '../../domain/usecases/login_with_code_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/send_register_code_usecase.dart';
import '../../domain/usecases/send_login_code_usecase.dart';
import '../controllers/auth_controller.dart';
import '../state/auth_state.dart';

final tokenStoreProvider = Provider<TokenStore>((ref) {
  return PersistentTokenStore(ref.watch(secureKeyValueStorageProvider));
});

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSourceImpl(ref.watch(largeDataStoreProvider));
});

final currentAuthUserProvider = FutureProvider<AuthUser?>((ref) async {
  final cachedUser = await ref
      .watch(authLocalDataSourceProvider)
      .readCurrentUser();
  return cachedUser?.toEntity();
});

class AuthSessionController extends StateNotifier<AsyncValue<bool>> {
  AuthSessionController(this._tokenStore, this._tokenRefresher, this._authLocal)
    : super(const AsyncValue.loading()) {
    unawaited(refresh());
  }

  final TokenStore _tokenStore;
  final TokenRefresher _tokenRefresher;
  final AuthLocalDataSource _authLocal;

  Future<void> _clearPersistedAuth() async {
    await _tokenStore.clear();
    try {
      await _authLocal.clearCurrentUser();
    } catch (_) {
      // Hive may be unavailable in lightweight test environments.
    }
  }

  Future<void> refresh() async {
    try {
      final accessToken = await _tokenStore.readAccessToken();
      if (accessToken != null && accessToken.trim().isNotEmpty) {
        state = const AsyncValue.data(true);
        return;
      }

      final refreshToken = await _tokenStore.readRefreshToken();
      if (refreshToken == null || refreshToken.trim().isEmpty) {
        await _clearPersistedAuth();
        state = const AsyncValue.data(false);
        return;
      }

      final refreshedPair = await _tokenRefresher.refresh(refreshToken);
      if (refreshedPair == null) {
        await _clearPersistedAuth();
        state = const AsyncValue.data(false);
        return;
      }

      await _tokenStore.save(refreshedPair);
      state = const AsyncValue.data(true);
    } catch (_) {
      await _clearPersistedAuth();
      state = const AsyncValue.data(false);
    }
  }

  void markAuthenticated() {
    state = const AsyncValue.data(true);
  }

  Future<void> markUnauthenticated() async {
    try {
      await _authLocal.clearCurrentUser();
    } catch (_) {
      // Hive may be unavailable in lightweight test environments.
    }
    state = const AsyncValue.data(false);
  }
}

final authSessionProvider =
    StateNotifierProvider<AuthSessionController, AsyncValue<bool>>((ref) {
      return AuthSessionController(
        ref.watch(tokenStoreProvider),
        ref.watch(tokenRefresherProvider),
        ref.watch(authLocalDataSourceProvider),
      );
    });

final isAuthenticatedProvider = Provider<AsyncValue<bool>>((ref) {
  return ref.watch(authSessionProvider);
});

final authFailureHandlerProvider = Provider<AuthFailureHandler>((ref) {
  final logger = ref.watch(appLoggerProvider);
  final messageController = ref.watch(appUiMessageProvider.notifier);
  final authSessionController = ref.watch(authSessionProvider.notifier);

  return AppAuthFailureHandler(
    logger: logger,
    onSignedOut: authSessionController.markUnauthenticated,
    reportErrorMessage: messageController.showError,
  );
});

final tokenRefresherProvider = Provider<TokenRefresher>((ref) {
  final baseUrl = ref.watch(oaApiBaseUrlProvider);
  return EndpointTokenRefresher.oauth2(
    Dio(BaseOptions(baseUrl: baseUrl)),
    refreshPath: FundingAuthApiPath.oauthToken,
    basicAuthorization: fundingOauthClientAuthorization,
  );
});

final coreHttpClientProvider = Provider<CoreHttpClient>((ref) {
  final baseUrl = ref.watch(oaApiBaseUrlProvider);
  final environment = ref.watch(appEnvironmentProvider);
  final logger = ref.watch(appLoggerProvider);
  final messageController = ref.watch(appUiMessageProvider.notifier);

  final client = CoreHttpClient(
    baseUrl: baseUrl,
    tokenStore: ref.watch(tokenStoreProvider),
    tokenRefresher: ref.watch(tokenRefresherProvider),
    authFailureHandler: ref.watch(authFailureHandlerProvider),
  );

  client.dio.interceptors.add(
    AppObservabilityInterceptor(
      logger: logger,
      reportErrorMessage: messageController.showError,
    ),
  );

  if (environment.enableHttpLog) {
    client.dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: false,
        logPrint: (Object value) => logger.debug(value.toString()),
      ),
    );
  }

  return client;
});

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(ref.watch(coreHttpClientProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remote: ref.watch(authRemoteDataSourceProvider),
    local: ref.watch(authLocalDataSourceProvider),
    tokenStore: ref.watch(tokenStoreProvider),
  );
});

final sendLoginCodeUseCaseProvider = Provider<SendLoginCodeUseCase>((ref) {
  return SendLoginCodeUseCase(ref.watch(authRepositoryProvider));
});

final sendRegisterCodeUseCaseProvider = Provider<SendRegisterCodeUseCase>((
  ref,
) {
  return SendRegisterCodeUseCase(ref.watch(authRepositoryProvider));
});

final loginWithCodeUseCaseProvider = Provider<LoginWithCodeUseCase>((ref) {
  return LoginWithCodeUseCase(ref.watch(authRepositoryProvider));
});

final registerAccountUseCaseProvider = Provider<RegisterAccountUseCase>((ref) {
  return RegisterAccountUseCase(ref.watch(authRepositoryProvider));
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  return LogoutUseCase(ref.watch(authRepositoryProvider));
});

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    return AuthController(
      ref.watch(sendLoginCodeUseCaseProvider),
      ref.watch(loginWithCodeUseCaseProvider),
    );
  },
);
