class MemberProfileRegion {
  const MemberProfileRegion({
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

  String get displayName {
    final normalizedJpName = jpName.trim();
    if (normalizedJpName.isNotEmpty) {
      return normalizedJpName;
    }
    return roomName.trim();
  }
}
