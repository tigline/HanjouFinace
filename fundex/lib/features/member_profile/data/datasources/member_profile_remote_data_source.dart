import 'dart:io';

import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:core_network/core_network.dart';

import '../../../../app/config/api_paths.dart';
import '../../../../app/network/app_api_response_profiles.dart';
import '../../../../app/network/api_cluster_router.dart';
import '../../domain/constants/member_profile_upload_markers.dart';
import '../models/member_profile_region_dto.dart';

abstract class MemberProfileRemoteDataSource {
  Future<List<MemberProfileRegionDto>> fetchRegionsByZip({required String zip});

  Future<String> uploadPhoto({
    required String filePath,
    required bool isSelfie,
  });

  Future<void> saveMemberInfo({required Map<String, dynamic> payload});
}

class MemberProfileRemoteDataSourceImpl
    implements MemberProfileRemoteDataSource {
  MemberProfileRemoteDataSourceImpl(
    CoreHttpClient oaClient, {
    CoreHttpClient? memberClient,
    ApiClusterRouter? clusterRouter,
    LegacyEnvelopeCodec? envelopeCodec,
  }) : _envelopeCodec =
           envelopeCodec ??
           const LegacyEnvelopeCodec(
             profile: AppApiResponseProfiles.memberMixed,
           ),
       _clusterRouter =
           clusterRouter ??
           ApiClusterRouter.fromClients(
             oaClient: oaClient,
             memberClient: memberClient,
           );

  final ApiClusterRouter _clusterRouter;
  final LegacyEnvelopeCodec _envelopeCodec;

  @override
  Future<List<MemberProfileRegionDto>> fetchRegionsByZip({
    required String zip,
  }) async {
    const path = FundingMemberApiPath.regionByZip;
    final response = await _clusterRouter
        .dioForPath(path)
        .get<Map<String, dynamic>>(
          path,
          queryParameters: <String, dynamic>{'zip': zip},
          options: authRequired(true),
        );

    final rows = _extractRegionRows(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to lookup address by postal code.',
    );

    return rows
        .map((row) => MemberProfileRegionDto.fromJson(row))
        .toList(growable: false);
  }

  @override
  Future<String> uploadPhoto({
    required String filePath,
    required bool isSelfie,
  }) async {
    final normalizedPath = filePath.trim();
    if (normalizedPath.isEmpty) {
      throw StateError('Failed to upload profile photo.');
    }

    final file = File(normalizedPath);
    if (!await file.exists()) {
      throw StateError('Failed to upload profile photo.');
    }

    final uploadPath = isSelfie
        ? FundingMemberApiPath.uploadRealPersonPhoto
        : FundingMemberApiPath.uploadPhoto;
    final response = await _clusterRouter
        .dioForPath(uploadPath)
        .post<dynamic>(
          uploadPath,
          data: FormData.fromMap(<String, dynamic>{
            'file': await MultipartFile.fromFile(normalizedPath),
          }),
          options: authRequired(
            true,
          ).copyWith(contentType: Headers.multipartFormDataContentType),
        );

    _debugUploadResponse(path: uploadPath, data: response.data);

    final payload = _envelopeCodec.toJsonMap(response.data);
    if (isSelfie) {
      _assertSelfieUploadSucceeded(
        responseData: response.data,
        payload: payload,
        fallbackMessage: 'Failed to upload profile photo.',
      );
      return selfieUploadCompletedMarker;
    }

    return _envelopeCodec.extractDataString(
      payload,
      fallbackMessage: 'Failed to upload profile photo.',
      fallbackKeys: const <String>['url'],
    );
  }

  @override
  Future<void> saveMemberInfo({required Map<String, dynamic> payload}) async {
    const path = FundingMemberApiPath.saveMemberInfo;
    final response = await _clusterRouter
        .dioForPath(path)
        .post<Map<String, dynamic>>(
          path,
          data: payload,
          options: authRequired(true),
        );

    _envelopeCodec.assertSuccessIfEnvelope(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to save member profile.',
      requireTruthyData: true,
    );
  }

  List<Map<String, dynamic>> _extractRegionRows(
    Map<String, dynamic> payload, {
    required String fallbackMessage,
  }) {
    final dataRows = _envelopeCodec.extractDataList(
      payload,
      fallbackMessage: fallbackMessage,
    );
    if (dataRows.isNotEmpty) {
      return dataRows;
    }
    return _envelopeCodec.toJsonMapList(payload['rows']);
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

  void _debugUploadResponse({required String path, required dynamic data}) {
    // ignore: avoid_print
    print(
      '[member_profile_upload_debug] path=$path '
      'dataType=${data.runtimeType} data=$data',
    );
  }
}
