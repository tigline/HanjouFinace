import 'package:core_network/core_network.dart';
import 'package:encrypt/encrypt.dart' as crypto;

import '../../../../app/config/api_paths.dart';
import '../models/auth_login_result_dto.dart';
import '../models/auth_session_dto.dart';
import '../models/auth_user_dto.dart';

abstract class AuthRemoteDataSource {
  Future<void> sendLoginCode({required String account, String? intlCode});
  Future<void> sendRegisterCode({
    required String account,
    required String intlCode,
  });
  Future<AuthLoginResultDto> loginWithCode({
    required String account,
    required String code,
    String? intlCode,
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

  String _normalizedIntlCode(String? intlCode) {
    final value = intlCode?.trim();
    return (value == null || value.isEmpty) ? defaultIntlCode : value;
  }

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

  bool _looksLikeLegacyEnvelope(Map<String, dynamic> payload) {
    return payload.containsKey('code') ||
        payload.containsKey('msg') ||
        payload.containsKey('data');
  }

  bool _hasOauthTokenFields(Map<String, dynamic> payload) {
    return payload.containsKey('access_token') ||
        payload.containsKey('refresh_token') ||
        payload.containsKey('accessToken') ||
        payload.containsKey('refreshToken');
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

  void _assertLegacyBoolSuccessIfPresent(
    Map<String, dynamic> payload, {
    required String fallbackMessage,
  }) {
    if (payload.isEmpty || !_looksLikeLegacyEnvelope(payload)) {
      return;
    }
    if (!_isLegacySuccessResponse(payload)) {
      _throwLegacyFailure(payload, fallbackMessage: fallbackMessage);
    }
  }

  Map<String, dynamic> _extractTokenPayload(
    Map<String, dynamic> payload, {
    required String fallbackMessage,
  }) {
    if (payload.isEmpty) {
      return payload;
    }

    if (_hasOauthTokenFields(payload)) {
      return payload;
    }

    if (_looksLikeLegacyEnvelope(payload)) {
      if (!_isLegacySuccessResponse(payload)) {
        _throwLegacyFailure(payload, fallbackMessage: fallbackMessage);
      }
      return _toJsonMap(payload['data']);
    }

    return payload;
  }

  @override
  Future<void> sendLoginCode({
    required String account,
    String? intlCode,
  }) async {
    final normalizedAccount = account.trim();
    if (_isEmailAccount(normalizedAccount)) {
      final response = await _client.dio.get<Map<String, dynamic>>(
        LegacyApiPath.emailLoginCode,
        queryParameters: <String, dynamic>{'email': normalizedAccount},
        options: authRequired(false),
      );
      _assertLegacyBoolSuccessIfPresent(
        _toJsonMap(response.data),
        fallbackMessage: 'Failed to send login code.',
      );
      return;
    }

    final response = await _client.dio.get<Map<String, dynamic>>(
      LegacyApiPath.smsCode,
      queryParameters: <String, dynamic>{
        'mobile': normalizedAccount,
        'biz': _normalizedIntlCode(intlCode),
        'secret': _buildSmsSecret(normalizedAccount),
      },
      options: authRequired(
        false,
      ).copyWith(contentType: Headers.formUrlEncodedContentType),
    );
    _assertLegacyBoolSuccessIfPresent(
      _toJsonMap(response.data),
      fallbackMessage: 'Failed to send login code.',
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
      _assertLegacyBoolSuccessIfPresent(
        _toJsonMap(response.data),
        fallbackMessage: 'Failed to send registration code.',
      );
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
    _assertLegacyBoolSuccessIfPresent(
      _toJsonMap(response.data),
      fallbackMessage: 'Failed to send registration code.',
    );
  }

  @override
  Future<AuthLoginResultDto> loginWithCode({
    required String account,
    required String code,
    String? intlCode,
  }) async {
    final normalizedAccount = account.trim();
    final isEmail = _isEmailAccount(normalizedAccount);
    final normalizedIntlCode = _normalizedIntlCode(intlCode);

    final response = await _client.dio.post<Map<String, dynamic>>(
      LegacyApiPath.oauthToken,
      data: <String, dynamic>{
        'username': normalizedAccount,
        'password': code.trim(),
        'grant_type': 'password',
        'auth_type': isEmail ? 'email' : 'mobile',
        'scope': 'app',
        if (!isEmail) 'code': normalizedIntlCode,
      },
      options: authRequired(false).copyWith(
        headers: <String, dynamic>{
          'Authorization': legacyOauthClientAuthorization,
        },
        contentType: Headers.formUrlEncodedContentType,
      ),
    );

    final payload = _extractTokenPayload(
      _toJsonMap(response.data),
      fallbackMessage: 'Login failed.',
    );
    final session = AuthSessionDto.fromJson(payload);
    final user = AuthUserDto.tryFromLoginPayload(payload);
    return AuthLoginResultDto(session: session, user: user);
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
    _assertLegacyBoolSuccessIfPresent(
      responsePayload,
      fallbackMessage: 'Registration failed.',
    );
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

    final rawPayload = _toJsonMap(response.data);
    if (rawPayload.isEmpty) {
      return null;
    }

    final tokenPayload = _extractTokenPayload(
      rawPayload,
      fallbackMessage: 'Failed to refresh session.',
    );
    if (tokenPayload.isEmpty) {
      return null;
    }

    try {
      return AuthSessionDto.fromJson(tokenPayload);
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
