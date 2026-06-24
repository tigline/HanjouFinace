import 'package:core_network/core_network.dart';

import '../envelope/company_api_response_profiles.dart';
import '../envelope/legacy_envelope_codec.dart';
import 'x_account_dtos.dart';

class XAccountApiPaths {
  const XAccountApiPaths._();

  static const String startOAuth = '/member/social/x/oauth/start';
  static const String account = '/member/social/x/account';
}

class XAccountApiClient {
  XAccountApiClient(
    this._client, {
    LegacyEnvelopeCodec? envelopeCodec,
    this.startOAuthPath = XAccountApiPaths.startOAuth,
    this.accountPath = XAccountApiPaths.account,
  }) : _envelopeCodec =
           envelopeCodec ??
           const LegacyEnvelopeCodec(
             profile: CompanyApiResponseProfiles.memberMixed,
           );

  final CoreHttpClient _client;
  final LegacyEnvelopeCodec _envelopeCodec;
  final String startOAuthPath;
  final String accountPath;

  Future<XOAuthStartDto> startOAuth() async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      startOAuthPath,
      options: authRequired(true),
    );
    final data = _extractData(
      response.data,
      fallbackMessage: 'Failed to start X OAuth.',
    );
    final result = XOAuthStartDto.fromJson(data);
    if (result.authorizationUrl.isEmpty) {
      throw StateError('Invalid X OAuth start response.');
    }
    return result;
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
