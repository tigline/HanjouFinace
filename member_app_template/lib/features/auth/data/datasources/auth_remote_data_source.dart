import 'package:core_network/core_network.dart';
import 'package:encrypt/encrypt.dart' as crypto;

import '../../../../app/config/api_paths.dart';
import '../models/auth_session_dto.dart';

abstract class AuthRemoteDataSource {
  Future<void> sendLoginCode({required String account});
  Future<void> sendRegisterCode({
    required String account,
    required String intlCode,
  });
  Future<AuthSessionDto> loginWithCode({
    required String account,
    required String code,
  });
  Future<void> registerApply({
    required String account,
    required String code,
    required String intlCode,
    String? contact,
  });
  Future<AuthSessionDto?> refreshSession({required String refreshToken});
  Future<void> logout({required String accessToken});
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

  Map<String, dynamic> _toJsonMap(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data;
    }
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    return <String, dynamic>{};
  }

  bool _isLegacySuccessResponse(Map<String, dynamic> payload) {
    final code = payload['code'];
    final data = payload['data'];
    final codeOk = code == 200 || code == '200';

    if (!codeOk) {
      return false;
    }

    if (data == null) {
      return true;
    }
    if (data is bool) {
      return data;
    }
    if (data is num) {
      return data != 0;
    }
    if (data is String) {
      final normalized = data.toLowerCase();
      return normalized == 'true' || normalized == '1' || normalized == 'ok';
    }
    return true;
  }

  Never _throwLegacyFailure(
    Map<String, dynamic> payload, {
    required String fallbackMessage,
  }) {
    final message = payload['msg'] ?? payload['message'] ?? fallbackMessage;
    throw StateError(message.toString());
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
  Future<void> sendRegisterCode({
    required String account,
    required String intlCode,
  }) async {
    final normalizedAccount = account.trim();
    final normalizedIntlCode = intlCode.trim().isEmpty
        ? defaultIntlCode
        : intlCode.trim();

    if (_isEmailAccount(normalizedAccount)) {
      final response = await _client.dio.get<Map<String, dynamic>>(
        LegacyApiPath.createRegisterEmailCode,
        queryParameters: <String, dynamic>{'email': normalizedAccount},
        options: authRequired(false),
      );
      final payload = _toJsonMap(response.data);
      if (!_isLegacySuccessResponse(payload)) {
        _throwLegacyFailure(
          payload,
          fallbackMessage: 'Failed to send registration code.',
        );
      }
      return;
    }

    final response = await _client.dio.get<Map<String, dynamic>>(
      LegacyApiPath.createRegisterMobileCode,
      queryParameters: <String, dynamic>{
        'mobile': normalizedAccount,
        'biz': normalizedIntlCode,
        'secret': _buildSmsSecret(normalizedAccount),
      },
      options: authRequired(
        false,
      ).copyWith(contentType: Headers.formUrlEncodedContentType),
    );
    final payload = _toJsonMap(response.data);
    if (!_isLegacySuccessResponse(payload)) {
      _throwLegacyFailure(
        payload,
        fallbackMessage: 'Failed to send registration code.',
      );
    }
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

  @override
  Future<void> registerApply({
    required String account,
    required String code,
    required String intlCode,
    String? contact,
  }) async {
    final normalizedAccount = account.trim();
    final normalizedCode = code.trim();
    final normalizedIntlCode = intlCode.trim().isEmpty
        ? defaultIntlCode
        : intlCode.trim();
    final normalizedContact = contact?.trim();

    final isEmail = _isEmailAccount(normalizedAccount);

    final payload = <String, dynamic>{
      'code': normalizedCode,
      'intlTelCode': normalizedIntlCode,
      'type': isEmail ? 'email' : 'mobile',
      if (isEmail) 'email': normalizedAccount else 'mobile': normalizedAccount,
    };

    if (isEmail) {
      if (normalizedContact == null || normalizedContact.isEmpty) {
        throw StateError('Mobile number is required for email registration.');
      }
      payload['mobile'] = normalizedContact;
    } else if (normalizedContact != null && normalizedContact.contains('@')) {
      payload['email'] = normalizedContact;
    }

    final response = await _client.dio.post<Map<String, dynamic>>(
      LegacyApiPath.registerApply,
      data: payload,
      options: authRequired(
        false,
      ).copyWith(contentType: Headers.jsonContentType),
    );
    final responsePayload = _toJsonMap(response.data);
    if (!_isLegacySuccessResponse(responsePayload)) {
      _throwLegacyFailure(
        responsePayload,
        fallbackMessage: 'Registration failed.',
      );
    }
  }

  @override
  Future<AuthSessionDto?> refreshSession({required String refreshToken}) async {
    final normalizedRefreshToken = refreshToken.trim();
    if (normalizedRefreshToken.isEmpty) {
      return null;
    }

    final response = await _client.dio.post<Map<String, dynamic>>(
      LegacyApiPath.oauthToken,
      data: <String, dynamic>{
        'grant_type': 'refresh_token',
        'refresh_token': normalizedRefreshToken,
      },
      options: authRequired(false).copyWith(
        headers: <String, dynamic>{
          'Authorization': legacyOauthClientAuthorization,
        },
        contentType: Headers.formUrlEncodedContentType,
      ),
    );

    final data = response.data;
    if (data == null) {
      return null;
    }

    try {
      return AuthSessionDto.fromJson(data);
    } on FormatException {
      return null;
    }
  }

  @override
  Future<void> logout({required String accessToken}) async {
    final normalizedAccessToken = accessToken.trim();
    if (normalizedAccessToken.isEmpty) {
      return;
    }

    await _client.dio.delete<void>(
      LegacyApiPath.oauthToken,
      data: <String, dynamic>{'accessToken': normalizedAccessToken},
      options: authRequired(false).copyWith(
        headers: <String, dynamic>{
          'Authorization': legacyOauthClientAuthorization,
        },
        contentType: Headers.jsonContentType,
      ),
    );
  }
}
