class RealPersonIdentifyRequest {
  const RealPersonIdentifyRequest({required this.photoBase64, this.groupId});

  final String photoBase64;
  final String? groupId;

  Map<String, dynamic> toJson() {
    final payload = <String, dynamic>{'photo': photoBase64};
    final normalizedGroupId = groupId?.trim() ?? '';
    if (normalizedGroupId.isNotEmpty) {
      payload['groupId'] = normalizedGroupId;
    }
    return payload;
  }
}

class RealPersonIdentifyResponse {
  const RealPersonIdentifyResponse({
    required this.userId,
    required this.rawData,
  });

  final int? userId;
  final Map<String, dynamic> rawData;

  bool get isVerified => userId != null && userId! > 0;
}
