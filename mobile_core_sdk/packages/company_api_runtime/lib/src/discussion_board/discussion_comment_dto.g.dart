// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discussion_comment_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DiscussionQuoteDtoImpl _$$DiscussionQuoteDtoImplFromJson(
  Map<String, dynamic> json,
) => _$DiscussionQuoteDtoImpl(
  id: _toNullableInt(json['id']),
  username: json['username'] as String? ?? '',
  content: json['content'] as String? ?? '',
  createTime: json['createTime'] as String? ?? '',
);

Map<String, dynamic> _$$DiscussionQuoteDtoImplToJson(
  _$DiscussionQuoteDtoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'content': instance.content,
  'createTime': instance.createTime,
};

_$DiscussionCommentDtoImpl _$$DiscussionCommentDtoImplFromJson(
  Map<String, dynamic> json,
) => _$DiscussionCommentDtoImpl(
  id: _toNullableInt(json['id']),
  userId: _toNullableInt(json['userId']),
  username: json['username'] as String? ?? '',
  content: json['content'] as String? ?? '',
  createTime: json['createTime'] as String? ?? '',
  projectId: _toNullableInt(json['projectId']),
  projectName: json['projectName'] as String? ?? '',
  quote: _quoteFromJson(json['quote']),
);

Map<String, dynamic> _$$DiscussionCommentDtoImplToJson(
  _$DiscussionCommentDtoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'username': instance.username,
  'content': instance.content,
  'createTime': instance.createTime,
  'projectId': instance.projectId,
  'projectName': instance.projectName,
  'quote': instance.quote,
};
