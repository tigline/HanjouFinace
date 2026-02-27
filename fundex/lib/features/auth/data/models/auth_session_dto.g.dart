// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_session_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthSessionDtoImpl _$$AuthSessionDtoImplFromJson(Map<String, dynamic> json) =>
    _$AuthSessionDtoImpl(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );

Map<String, dynamic> _$$AuthSessionDtoImplToJson(
  _$AuthSessionDtoImpl instance,
) => <String, dynamic>{
  'accessToken': instance.accessToken,
  'refreshToken': instance.refreshToken,
  'expiresAt': instance.expiresAt.toIso8601String(),
};
