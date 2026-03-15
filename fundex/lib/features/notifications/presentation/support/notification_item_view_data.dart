import 'package:company_api_runtime/company_api_runtime.dart';

class NotificationItemViewData {
  const NotificationItemViewData({
    required this.key,
    required this.id,
    required this.noticeType,
    required this.title,
    required this.body,
    required this.dateLabel,
    required this.createdAt,
    required this.isRead,
    required this.isImportant,
  });

  factory NotificationItemViewData.fromNoticeDto(NoticeItemDto dto) {
    final title = dto.noticeTitle?.trim() ?? '';
    final body = dto.detail?.trim() ?? '';
    final rawDate = dto.createTime?.trim().isNotEmpty == true
        ? dto.createTime
        : dto.updateTime;
    final createdAt = _tryParseDate(rawDate);

    return NotificationItemViewData(
      key: _buildStableKey(dto.id, rawDate, title, body),
      id: dto.id,
      noticeType: dto.noticeType,
      title: title,
      body: body,
      dateLabel: _formatDateLabel(createdAt, rawDate),
      createdAt: createdAt,
      isRead: dto.status ?? false,
      isImportant: _resolveImportantFlag(
        noticeType: dto.noticeType,
        title: title,
        body: body,
      ),
    );
  }

  final String key;
  final int? id;
  final int? noticeType;
  final String title;
  final String body;
  final String dateLabel;
  final DateTime? createdAt;
  final bool isRead;
  final bool isImportant;

  NotificationItemViewData copyWith({
    String? key,
    int? id,
    int? noticeType,
    String? title,
    String? body,
    String? dateLabel,
    DateTime? createdAt,
    bool? isRead,
    bool? isImportant,
  }) {
    return NotificationItemViewData(
      key: key ?? this.key,
      id: id ?? this.id,
      noticeType: noticeType ?? this.noticeType,
      title: title ?? this.title,
      body: body ?? this.body,
      dateLabel: dateLabel ?? this.dateLabel,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      isImportant: isImportant ?? this.isImportant,
    );
  }
}

String _buildStableKey(int? id, String? rawDate, String title, String body) {
  if (id != null) {
    return id.toString();
  }
  return '${rawDate ?? ''}|$title|$body';
}

DateTime? _tryParseDate(String? rawDate) {
  final source = rawDate?.trim() ?? '';
  if (source.isEmpty) {
    return null;
  }

  final normalized = source.replaceFirst(' ', 'T');
  final direct = DateTime.tryParse(normalized);
  if (direct != null) {
    return direct;
  }

  final matcher = RegExp(
    r'(\d{4})[./-](\d{1,2})[./-](\d{1,2})',
  ).firstMatch(source);
  if (matcher == null) {
    return null;
  }
  final year = int.tryParse(matcher.group(1) ?? '');
  final month = int.tryParse(matcher.group(2) ?? '');
  final day = int.tryParse(matcher.group(3) ?? '');
  if (year == null || month == null || day == null) {
    return null;
  }
  return DateTime(year, month, day);
}

String _formatDateLabel(DateTime? date, String? rawDate) {
  if (date != null) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y.$m.$d';
  }

  final source = rawDate?.trim() ?? '';
  if (source.isEmpty) {
    return '';
  }

  final matcher = RegExp(
    r'(\d{4})[./-](\d{1,2})[./-](\d{1,2})',
  ).firstMatch(source);
  if (matcher == null) {
    return source;
  }
  final y = matcher.group(1) ?? '';
  final m = (matcher.group(2) ?? '').padLeft(2, '0');
  final d = (matcher.group(3) ?? '').padLeft(2, '0');
  return '$y.$m.$d';
}

bool _resolveImportantFlag({
  required int? noticeType,
  required String title,
  required String body,
}) {
  if (noticeType == 1) {
    return true;
  }

  final sample = '${title.toLowerCase()} ${body.toLowerCase()}';
  const keywords = <String>[
    '要対応',
    '要確認',
    '要同意',
    '重要',
    'urgent',
    'important',
    'action required',
    '本人情報',
    'クーリングオフ',
    '同意',
    '请处理',
    '請處理',
  ];
  return keywords.any(sample.contains);
}
