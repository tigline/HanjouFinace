import 'package:core_network/core_network.dart';

import '../envelope/legacy_envelope_codec.dart';
import 'x_account_dtos.dart';

class XAccountApiPaths {
  const XAccountApiPaths._();

  static const String startBinding = '/member/social/x/auth/start';
  static const String bindingStatus = '/member/social/x/auth/status';
  static const String account = '/member/social/x/account';
}

class XAccountApiClient {
  XAccountApiClient(
    this._client, {
    LegacyEnvelopeCodec? envelopeCodec,
    this.startBindingPath = XAccountApiPaths.startBinding,
    this.bindingStatusPath = XAccountApiPaths.bindingStatus,
    this.accountPath = XAccountApiPaths.account,
  }) : _envelopeCodec = envelopeCodec ?? const LegacyEnvelopeCodec();

  final CoreHttpClient _client;
  final LegacyEnvelopeCodec _envelopeCodec;
  final String startBindingPath;
  final String bindingStatusPath;
  final String accountPath;

  Future<XBindingAttemptDto> startBinding({required String callbackUri}) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      startBindingPath,
      data: <String, dynamic>{'callbackUri': callbackUri},
      options: authRequired(true),
    );
    final data = _extractData(
      response.data,
      fallbackMessage: 'Failed to start X account binding.',
    );
    final result = XBindingAttemptDto.fromJson(data);
    if (result.attemptId.isEmpty || result.authorizationUrl.isEmpty) {
      throw StateError('Invalid X account binding response.');
    }
    return result;
  }

  Future<XBindingStatusDto> fetchBindingStatus({
    required String attemptId,
  }) async {
    final response = await _client.dio.get<Map<String, dynamic>>(
      bindingStatusPath,
      queryParameters: <String, dynamic>{'attemptId': attemptId},
      options: authRequired(true),
    );
    return XBindingStatusDto.fromJson(
      _extractData(
        response.data,
        fallbackMessage: 'Failed to read X account binding status.',
      ),
    );
  }

  Future<XAccountConnectionDto> fetchAccount() async {
    final response = await _client.dio.get<Map<String, dynamic>>(
      accountPath,
      options: authRequired(true),
    );
    final payload = _envelopeCodec.toJsonMap(response.data);
    _envelopeCodec.assertSuccessIfEnvelope(
      payload,
      fallbackMessage: 'Failed to load X account.',
    );
    final isEnvelope = _envelopeCodec.looksLikeEnvelope(payload);
    final data = isEnvelope ? payload[_envelopeCodec.profile.dataKey] : payload;
    if (data == null || data == false) {
      return const XAccountConnectionDto.disconnected();
    }
    return XAccountConnectionDto.fromJson(
      isEnvelope ? _envelopeCodec.toJsonMap(data) : payload,
    );
  }

  Future<void> disconnectAccount() async {
    final response = await _client.dio.delete<Map<String, dynamic>>(
      accountPath,
      options: authRequired(true),
    );
    _envelopeCodec.assertSuccessIfEnvelope(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to disconnect X account.',
      requireTruthyData: true,
    );
  }

  Map<String, dynamic> _extractData(
    Map<String, dynamic>? responseData, {
    required String fallbackMessage,
  }) {
    return _envelopeCodec.extractDataMap(
      _envelopeCodec.toJsonMap(responseData),
      fallbackMessage: fallbackMessage,
    );
  }
}
