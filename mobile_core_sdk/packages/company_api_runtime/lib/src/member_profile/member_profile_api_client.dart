import 'dart:convert';
import 'dart:io';

import 'package:core_network/core_network.dart';

import '../envelope/legacy_envelope_codec.dart';
import 'member_profile_region_dto.dart';

typedef MemberProfileDioForPath = Dio Function(String path);

class MemberProfileApiPaths {
  const MemberProfileApiPaths._();

  static const String saveMemberInfo = '/crowdfunding/user/save-member-info';
  static const String uploadPhoto = '/crowdfunding/user/upload/photo';
  // Third-party contract: see fundex/README_API.md (ZipCloud postal lookup).
  static const String regionByZip = 'https://zipcloud.ibsnet.co.jp/api/search';
  static const String uploadRealPersonPhoto = '/member/real/person/upload';
  static const String uploadAvatar = '/member/user/avatar-upload';
}

class MemberProfileApiClient {
  MemberProfileApiClient({
    required MemberProfileDioForPath dioForPath,
    LegacyEnvelopeCodec? envelopeCodec,
    this.saveMemberInfoPath = MemberProfileApiPaths.saveMemberInfo,
    this.uploadPhotoPath = MemberProfileApiPaths.uploadPhoto,
    this.regionByZipPath = MemberProfileApiPaths.regionByZip,
    this.uploadRealPersonPhotoPath =
        MemberProfileApiPaths.uploadRealPersonPhoto,
    this.uploadAvatarPath = MemberProfileApiPaths.uploadAvatar,
  }) : _dioForPath = dioForPath,
       _envelopeCodec =
           envelopeCodec ??
           const LegacyEnvelopeCodec(
             profile: LegacyEnvelopeProfile(successCodes: <String>{'0', '200'}),
           );

  final MemberProfileDioForPath _dioForPath;
  final LegacyEnvelopeCodec _envelopeCodec;

  final String saveMemberInfoPath;
  final String uploadPhotoPath;
  final String regionByZipPath;
  final String uploadRealPersonPhotoPath;
  final String uploadAvatarPath;

  Future<List<MemberProfileRegionDto>> fetchRegionsByZip({
    required String zip,
  }) async {
    final response = await _dioForPath(regionByZipPath).get<dynamic>(
      regionByZipPath,
      queryParameters: <String, dynamic>{'zipcode': zip},
      // ZipCloud returns JSON with a text/plain content type.
      options: authRequired(false),
    );

    return _mapZipCloudRegions(_decodeZipCloudPayload(response.data));
  }

  Future<String> uploadDocumentPhoto({required String filePath}) async {
    final normalizedPath = _normalizeAndValidatePath(filePath);
    final response = await _uploadMultipart(
      path: uploadPhotoPath,
      filePath: normalizedPath,
    );

    final payload = _envelopeCodec.toJsonMap(response.data);
    return _envelopeCodec.extractDataString(
      payload,
      fallbackMessage: 'Failed to upload profile photo.',
      fallbackKeys: const <String>['url'],
    );
  }

  Future<void> uploadSelfiePhoto({required String filePath}) async {
    final normalizedPath = _normalizeAndValidatePath(filePath);
    final response = await _uploadMultipart(
      path: uploadRealPersonPhotoPath,
      filePath: normalizedPath,
    );
    final payload = _envelopeCodec.toJsonMap(response.data);
    _assertSelfieUploadSucceeded(
      responseData: response.data,
      payload: payload,
      fallbackMessage: 'Failed to upload profile photo.',
    );
  }

  Future<String> uploadAvatar({required String filePath}) async {
    final normalizedPath = _normalizeAndValidatePath(filePath);
    final response = await _uploadMultipart(
      path: uploadAvatarPath,
      filePath: normalizedPath,
    );

    final payload = _envelopeCodec.toJsonMap(response.data);
    return _envelopeCodec.extractDataString(
      payload,
      fallbackMessage: 'Failed to upload avatar.',
      fallbackKeys: const <String>['url'],
    );
  }

  Future<void> saveMemberInfo({required Map<String, dynamic> payload}) async {
    final response = await _dioForPath(saveMemberInfoPath)
        .post<Map<String, dynamic>>(
          saveMemberInfoPath,
          data: payload,
          options: authRequired(true),
        );

    _envelopeCodec.assertSuccessIfEnvelope(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to save member profile.',
      requireTruthyData: true,
    );
  }

  Future<Response<dynamic>> _uploadMultipart({
    required String path,
    required String filePath,
  }) async {
    return _dioForPath(path).post<dynamic>(
      path,
      data: FormData.fromMap(<String, dynamic>{
        'file': await MultipartFile.fromFile(filePath),
      }),
      options: authRequired(
        true,
      ).copyWith(contentType: Headers.multipartFormDataContentType),
    );
  }

  String _normalizeAndValidatePath(String filePath) {
    final normalizedPath = filePath.trim();
    if (normalizedPath.isEmpty) {
      throw StateError('Failed to upload profile photo.');
    }

    final file = File(normalizedPath);
    if (!file.existsSync()) {
      throw StateError('Failed to upload profile photo.');
    }
    return normalizedPath;
  }

  List<MemberProfileRegionDto> _mapZipCloudRegions(
    Map<String, dynamic> payload,
  ) {
    const fallbackMessage = 'Failed to lookup address by postal code.';
    final status = int.tryParse(payload['status']?.toString() ?? '');
    if (status != HttpStatus.ok) {
      final message = payload['message']?.toString().trim() ?? '';
      throw StateError(message.isEmpty ? fallbackMessage : message);
    }

    final results = _envelopeCodec.toJsonMapList(payload['results']);
    if (results.isEmpty) {
      return const <MemberProfileRegionDto>[];
    }

    final result = results.first;
    final prefecture = result['address1']?.toString().trim() ?? '';
    final city = result['address2']?.toString().trim() ?? '';
    final town = result['address3']?.toString().trim() ?? '';
    final cityAddress = '$city$town';

    return <MemberProfileRegionDto>[
      if (prefecture.isNotEmpty)
        MemberProfileRegionDto(
          jpName: prefecture,
          parentId: null,
          regionId: null,
          regionType: 0,
          roomName: '',
        ),
      if (cityAddress.isNotEmpty)
        MemberProfileRegionDto(
          jpName: cityAddress,
          parentId: null,
          regionId: null,
          regionType: 1,
          roomName: '',
        ),
    ];
  }

  Map<String, dynamic> _decodeZipCloudPayload(dynamic data) {
    if (data is String) {
      try {
        return _envelopeCodec.toJsonMap(jsonDecode(data));
      } on FormatException {
        throw StateError('Failed to lookup address by postal code.');
      }
    }
    return _envelopeCodec.toJsonMap(data);
  }

  void _assertSelfieUploadSucceeded({
    required dynamic responseData,
    required Map<String, dynamic> payload,
    required String fallbackMessage,
  }) {
    if (payload.isEmpty) {
      if (!_envelopeCodec.isTruthyData(responseData?.toString())) {
        throw StateError(fallbackMessage);
      }
      return;
    }

    if (_envelopeCodec.looksLikeEnvelope(payload)) {
      _envelopeCodec.assertSuccessIfEnvelope(
        payload,
        fallbackMessage: fallbackMessage,
        requireTruthyData: true,
      );
      return;
    }

    if (payload.containsKey('success') &&
        !_envelopeCodec.isTruthyData(payload['success'])) {
      throw StateError(fallbackMessage);
    }
    if (payload.containsKey('ok') &&
        !_envelopeCodec.isTruthyData(payload['ok'])) {
      throw StateError(fallbackMessage);
    }
  }
}
