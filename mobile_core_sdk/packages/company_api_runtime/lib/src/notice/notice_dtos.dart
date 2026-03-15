class NoticeListRequestDto {
  const NoticeListRequestDto({
    this.startPage = 1,
    this.limit = 20,
    this.memberId,
    this.status,
  });

  final int startPage;
  final int limit;
  final int? memberId;
  final bool? status;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'startPage': startPage,
      'limit': limit,
      if (memberId != null) 'memberId': memberId,
      if (status != null) 'status': status,
    };
  }
}

class NoticeItemDto {
  const NoticeItemDto({
    this.id,
    this.memberId,
    this.noticeType,
    this.status,
    this.noticeTitle,
    this.detail,
    this.createUser,
    this.createTime,
    this.updateTime,
  });

  factory NoticeItemDto.fromJson(Map<String, dynamic> json) {
    return NoticeItemDto(
      id: _intOrNull(json['id']),
      memberId: _intOrNull(json['memberId']),
      noticeType: _intOrNull(json['noticeType']),
      status: _boolOrNull(json['status']),
      noticeTitle: _stringOrNull(json['noticeTitle']),
      detail: _stringOrNull(json['detail']),
      createUser: _stringOrNull(json['createUser']),
      createTime: _stringOrNull(json['createTime']),
      updateTime: _stringOrNull(json['updateTime']),
    );
  }

  final int? id;
  final int? memberId;
  final int? noticeType;
  final bool? status;
  final String? noticeTitle;
  final String? detail;
  final String? createUser;
  final String? createTime;
  final String? updateTime;
}

class NoticePageResultDto {
  const NoticePageResultDto({
    required this.rows,
    this.currentPage,
    this.limit,
    this.total,
  });

  factory NoticePageResultDto.fromJson(Map<String, dynamic> json) {
    return NoticePageResultDto(
      currentPage: _intOrNull(json['currentPage']),
      limit: _intOrNull(json['limit']),
      total: _intOrNull(json['total']),
      rows: _listOrEmpty(json['rows'])
          .map((dynamic item) => NoticeItemDto.fromJson(_jsonMapOrEmpty(item)))
          .toList(growable: false),
    );
  }

  final int? currentPage;
  final int? limit;
  final int? total;
  final List<NoticeItemDto> rows;
}

class NoticeStatisticsDto {
  const NoticeStatisticsDto({this.check, this.uncheck});

  factory NoticeStatisticsDto.fromJson(Map<String, dynamic> json) {
    return NoticeStatisticsDto(
      check: _intOrNull(json['check']),
      uncheck: _intOrNull(json['uncheck']),
    );
  }

  final int? check;
  final int? uncheck;
}

int? _intOrNull(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  return int.tryParse(value.toString());
}

bool? _boolOrNull(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is bool) {
    return value;
  }
  if (value is num) {
    return value != 0;
  }
  final normalized = value.toString().trim().toLowerCase();
  if (normalized.isEmpty) {
    return null;
  }
  if (normalized == 'true' || normalized == '1') {
    return true;
  }
  if (normalized == 'false' || normalized == '0') {
    return false;
  }
  return null;
}

String? _stringOrNull(dynamic value) {
  if (value == null) {
    return null;
  }
  final text = value.toString().trim();
  return text.isEmpty ? null : text;
}

Map<String, dynamic> _jsonMapOrEmpty(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }
  if (value is Map) {
    return Map<String, dynamic>.from(value);
  }
  return const <String, dynamic>{};
}

List<dynamic> _listOrEmpty(dynamic value) {
  if (value is List) {
    return value;
  }
  return const <dynamic>[];
}
