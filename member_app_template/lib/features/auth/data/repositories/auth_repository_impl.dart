import 'package:core_network/core_network.dart';

import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remote,
    required TokenStore tokenStore,
  }) : _remote = remote,
       _tokenStore = tokenStore;

  final AuthRemoteDataSource _remote;
  final TokenStore _tokenStore;

  @override
  Future<void> sendLoginCode({required String account}) {
    return _remote.sendLoginCode(account: account);
  }

  @override
  Future<void> sendRegisterCode({
    required String account,
    required String intlCode,
  }) {
    return _remote.sendRegisterCode(account: account, intlCode: intlCode);
  }

  @override
  Future<AuthSession> loginWithCode({
    required String account,
    required String code,
  }) async {
    final dto = await _remote.loginWithCode(account: account, code: code);
    await _tokenStore.save(
      TokenPair(accessToken: dto.accessToken, refreshToken: dto.refreshToken),
    );
    return dto.toEntity();
  }

  @override
  Future<void> registerAccount({
    required String account,
    required String code,
    required String intlCode,
    String? contact,
  }) {
    return _remote.registerApply(
      account: account,
      code: code,
      intlCode: intlCode,
      contact: contact,
    );
  }

  @override
  Future<bool> restoreSession() async {
    final accessToken = await _tokenStore.readAccessToken();
    if (accessToken != null && accessToken.trim().isNotEmpty) {
      return true;
    }

    return refreshSession();
  }

  @override
  Future<bool> refreshSession() async {
    final refreshToken = await _tokenStore.readRefreshToken();
    if (refreshToken == null || refreshToken.trim().isEmpty) {
      await _tokenStore.clear();
      return false;
    }

    try {
      final dto = await _remote.refreshSession(refreshToken: refreshToken);
      if (dto == null) {
        await _tokenStore.clear();
        return false;
      }
      await _tokenStore.save(
        TokenPair(accessToken: dto.accessToken, refreshToken: dto.refreshToken),
      );
      return true;
    } catch (_) {
      await _tokenStore.clear();
      return false;
    }
  }

  @override
  Future<void> logout() async {
    final accessToken = await _tokenStore.readAccessToken();
    try {
      if (accessToken != null && accessToken.trim().isNotEmpty) {
        await _remote.logout(accessToken: accessToken);
      }
    } catch (_) {
      // Always clear local auth state even when remote revoke fails.
    } finally {
      await _tokenStore.clear();
    }
  }
}
