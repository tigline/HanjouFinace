import 'package:core_network/core_network.dart';

import '../models/auth_session_dto.dart';

abstract class AuthRemoteDataSource {
  Future<void> sendLoginCode({required String account});
  Future<AuthSessionDto> loginWithCode({
    required String account,
    required String code,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._client);

  final CoreHttpClient _client;

  @override
  Future<void> sendLoginCode({required String account}) async {
    await _client.dio.post<void>(
      '/v1/auth/send-login-code',
      data: <String, dynamic>{'account': account},
      options: authRequired(false),
    );
  }

  @override
  Future<AuthSessionDto> loginWithCode({
    required String account,
    required String code,
  }) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      '/v1/auth/login-with-code',
      data: <String, dynamic>{'account': account, 'code': code},
      options: authRequired(false),
    );

    return AuthSessionDto.fromJson(response.data ?? <String, dynamic>{});
  }
}
