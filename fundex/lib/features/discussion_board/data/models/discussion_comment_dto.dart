class DiscussionQuoteDto {
  const DiscussionQuoteDto({
    required this.id,
    required this.username,
    required this.content,
    required this.createTime,
  });

  final int? id;
  final String username;
  final String content;
  final String createTime;

  factory DiscussionQuoteDto.fromJson(Map<String, dynamic> json) {
    return DiscussionQuoteDto(
      id: _toNullableInt(json['id']),
      username: json['username']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      createTime: json['createTime']?.toString() ?? '',
    );
  }
}

class DiscussionCommentDto {
  const DiscussionCommentDto({
    required this.id,
    required this.userId,
    required this.username,
    required this.content,
    required this.createTime,
    required this.projectId,
    required this.projectName,
    this.quote,
  });

  final int? id;
  final int? userId;
  final String username;
  final String content;
  final String createTime;
  final int? projectId;
  final String projectName;
  final DiscussionQuoteDto? quote;

  factory DiscussionCommentDto.fromJson(Map<String, dynamic> json) {
    final quoteRaw = json['quote'];
    return DiscussionCommentDto(
      id: _toNullableInt(json['id']),
      userId: _toNullableInt(json['userId']),
      username: json['username']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      createTime: json['createTime']?.toString() ?? '',
      projectId: _toNullableInt(json['projectId']),
      projectName: json['projectName']?.toString() ?? '',
      quote: quoteRaw is Map
          ? DiscussionQuoteDto.fromJson(Map<String, dynamic>.from(quoteRaw))
          : null,
    );
  }
}

int? _toNullableInt(Object? value) {
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
