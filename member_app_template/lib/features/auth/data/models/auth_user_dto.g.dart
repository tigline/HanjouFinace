// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthUserDtoImpl _$$AuthUserDtoImplFromJson(Map<String, dynamic> json) =>
    _$AuthUserDtoImpl(
      username: json['username'] as String,
      userId: (json['userId'] as num?)?.toInt(),
      email: json['email'] as String?,
      mobile: json['mobile'] as String?,
      memberLevel: (json['memberLevel'] as num?)?.toInt(),
      intlTelCode: json['intlTelCode'] as String?,
    );

Map<String, dynamic> _$$AuthUserDtoImplToJson(_$AuthUserDtoImpl instance) =>
    <String, dynamic>{
      'username': instance.username,
      'userId': instance.userId,
      'email': instance.email,
      'mobile': instance.mobile,
      'memberLevel': instance.memberLevel,
      'intlTelCode': instance.intlTelCode,
    };
