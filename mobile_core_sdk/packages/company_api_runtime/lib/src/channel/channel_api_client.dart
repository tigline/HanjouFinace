import 'package:core_network/core_network.dart';

import '../envelope/company_api_response_profiles.dart';
import '../envelope/legacy_envelope_codec.dart';
import 'channel_dtos.dart';

class ChannelApiPaths {
  const ChannelApiPaths._();

  /// Member Swagger: GET /channel/detail with basePath `/member/`.
  static const String detail = '/member/channel/detail';
}

class ChannelApiClient {
  ChannelApiClient(
    this._client, {
    LegacyEnvelopeCodec? envelopeCodec,
    this.detailPath = ChannelApiPaths.detail,
  }) : _envelopeCodec =
           envelopeCodec ??
           const LegacyEnvelopeCodec(
             profile: CompanyApiResponseProfiles.memberMixed,
           );

  final CoreHttpClient _client;
  final LegacyEnvelopeCodec _envelopeCodec;
  final String detailPath;

  Future<ChannelPartnerDto> fetchMyChannelDetail() async {
    final response = await _client.dio.get<Map<String, dynamic>>(
      detailPath,
      options: authRequired(true, refreshOnForbidden: true),
    );
    final data = _envelopeCodec.extractDataMap(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to load invitation details.',
    );
    return ChannelPartnerDto.fromJson(data);
  }
}
