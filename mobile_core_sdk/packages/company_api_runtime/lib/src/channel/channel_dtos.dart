class ChannelPartnerDto {
  const ChannelPartnerDto({
    required this.inviteCode,
    required this.invitedFriendCount,
    this.channelName,
  });

  factory ChannelPartnerDto.fromJson(Map<String, dynamic> json) {
    return ChannelPartnerDto(
      inviteCode: _toString(json['inviteCode']),
      invitedFriendCount: _toInt(json['countNum']),
      channelName: _toNullableString(json['channelName']),
    );
  }

  final String inviteCode;
  final int invitedFriendCount;
  final String? channelName;
}

String _toString(Object? value) => value?.toString().trim() ?? '';

String? _toNullableString(Object? value) {
  final normalized = _toString(value);
  return normalized.isEmpty ? null : normalized;
}

int _toInt(Object? value) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  return int.tryParse(value?.toString() ?? '') ?? 0;
}
