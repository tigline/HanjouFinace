import 'package:core_network/core_network.dart';
import 'package:encrypt/encrypt.dart' as crypto;

import '../../../../app/config/api_paths.dart';
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

  bool _isEmailAccount(String account) => account.contains('@');

  String _buildSmsSecret(String mobile) {
    final key = crypto.Key.fromUtf8('ookawasebirukura');
    final iv = crypto.IV.fromUtf8('fkabushikigaisha');
    final aes = crypto.Encrypter(crypto.AES(key, mode: crypto.AESMode.cbc));
    return aes.encrypt(mobile, iv: iv).base64;
  }

  @override
  Future<void> sendLoginCode({required String account}) async {
    final normalizedAccount = account.trim();
    if (_isEmailAccount(normalizedAccount)) {
      await _client.dio.get<void>(
        LegacyApiPath.emailLoginCode,
        queryParameters: <String, dynamic>{'email': normalizedAccount},
        options: authRequired(false),
      );
      return;
    }

    await _client.dio.get<void>(
      LegacyApiPath.smsCode,
      queryParameters: <String, dynamic>{
        'mobile': normalizedAccount,
        'biz': defaultIntlCode,
        'secret': _buildSmsSecret(normalizedAccount),
      },
      options: authRequired(
        false,
      ).copyWith(contentType: Headers.formUrlEncodedContentType),
    );
  }

  @override
  Future<AuthSessionDto> loginWithCode({
    required String account,
    required String code,
  }) async {
    final normalizedAccount = account.trim();
    final isEmail = _isEmailAccount(normalizedAccount);

    final response = await _client.dio.post<Map<String, dynamic>>(
      LegacyApiPath.oauthToken,
      data: <String, dynamic>{
        'username': normalizedAccount,
        'password': code.trim(),
        'grant_type': 'password',
        'auth_type': isEmail ? 'email' : 'mobile',
        'scope': 'app',
        if (!isEmail) 'code': defaultIntlCode,
      },
      options: authRequired(false).copyWith(
        headers: <String, dynamic>{
          'Authorization': legacyOauthClientAuthorization,
        },
        contentType: Headers.formUrlEncodedContentType,
      ),
    );

    return AuthSessionDto.fromJson(response.data ?? <String, dynamic>{});
  }
}
