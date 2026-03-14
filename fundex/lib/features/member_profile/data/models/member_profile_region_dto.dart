import '../../domain/entities/member_profile_region.dart';

class MemberProfileRegionDto {
  const MemberProfileRegionDto({
    required this.jpName,
    required this.parentId,
    required this.regionId,
    required this.regionType,
    required this.roomName,
  });

  final String jpName;
  final int? parentId;
  final int? regionId;
  final int? regionType;
  final String roomName;

  factory MemberProfileRegionDto.fromJson(Map<String, dynamic> json) {
    return MemberProfileRegionDto(
      jpName: json['jpName']?.toString().trim() ?? '',
      parentId: _toIntOrNull(json['parentId']),
      regionId: _toIntOrNull(json['regionId']),
      regionType: _toIntOrNull(json['regionType']),
      roomName: json['roomName']?.toString().trim() ?? '',
    );
  }

  MemberProfileRegion toEntity() {
    return MemberProfileRegion(
      jpName: jpName,
      parentId: parentId,
      regionId: regionId,
      regionType: regionType,
      roomName: roomName,
    );
  }

  static int? _toIntOrNull(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value.trim());
    }
    return null;
  }
}
