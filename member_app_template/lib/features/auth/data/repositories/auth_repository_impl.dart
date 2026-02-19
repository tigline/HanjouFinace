import 'package:core_network/core_network.dart';

import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remote,
    required TokenStore tokenStore,
  })  : _remote = remote,
        _tokenStore = tokenStore;

  final AuthRemoteDataSource _remote;
  final TokenStore _tokenStore;

  @override
  Future<void> sendLoginCode({required String account}) {
    return _remote.sendLoginCode(account: account);
  }

  @override
  Future<AuthSession> loginWithCode({
    required String account,
    required String code,
  }) async {
    final dto = await _remote.loginWithCode(account: account, code: code);
    await _tokenStore.save(
      TokenPair(
        accessToken: dto.accessToken,
        refreshToken: dto.refreshToken,
      ),
    );
    return dto.toEntity();
  }

  @override
  Future<void> logout() {
    return _tokenStore.clear();
  }
}
