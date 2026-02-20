import 'dart:async';

import 'package:core_network/core_network.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/auth/app_auth_failure_handler.dart';
import '../../../../app/auth/persistent_token_store.dart';
import '../../../../app/config/api_paths.dart';
import '../../../../app/config/environment_provider.dart';
import '../../../../app/network/app_observability_interceptor.dart';
import '../../../../app/observability/app_observability_providers.dart';
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

class AuthSessionController extends StateNotifier<AsyncValue<bool>> {
  AuthSessionController(this._tokenStore) : super(const AsyncValue.loading()) {
    unawaited(refresh());
  }

  final TokenStore _tokenStore;

  Future<void> refresh() async {
    try {
      final accessToken = await _tokenStore.readAccessToken();
      final isAuthenticated = accessToken != null && accessToken.isNotEmpty;
      state = AsyncValue.data(isAuthenticated);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void markAuthenticated() {
    state = const AsyncValue.data(true);
  }

  Future<void> markUnauthenticated() async {
    state = const AsyncValue.data(false);
  }
}

final authSessionProvider =
    StateNotifierProvider<AuthSessionController, AsyncValue<bool>>((ref) {
      return AuthSessionController(ref.watch(tokenStoreProvider));
    });

final isAuthenticatedProvider = Provider<AsyncValue<bool>>((ref) {
  return ref.watch(authSessionProvider);
});

final authRouteRefreshListenableProvider = Provider<ValueNotifier<int>>((ref) {
  final notifier = ValueNotifier<int>(0);
  ref.listen<AsyncValue<bool>>(authSessionProvider, (previous, next) {
    if (previous != next) {
      notifier.value += 1;
    }
  });
  ref.onDispose(notifier.dispose);
  return notifier;
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
  final baseUrl = ref.watch(memberApiBaseUrlProvider);
  return EndpointTokenRefresher.oauth2(
    Dio(BaseOptions(baseUrl: baseUrl)),
    refreshPath: LegacyApiPath.oauthToken,
    basicAuthorization: legacyOauthClientAuthorization,
  );
});

final coreHttpClientProvider = Provider<CoreHttpClient>((ref) {
  final baseUrl = ref.watch(memberApiBaseUrlProvider);
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
