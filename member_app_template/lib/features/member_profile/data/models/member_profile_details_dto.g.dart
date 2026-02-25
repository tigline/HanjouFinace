// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_profile_details_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MemberProfileDetailsDtoImpl _$$MemberProfileDetailsDtoImplFromJson(
  Map<String, dynamic> json,
) => _$MemberProfileDetailsDtoImpl(
  familyName: json['familyName'] as String? ?? '',
  givenName: json['givenName'] as String? ?? '',
  address: json['address'] as String? ?? '',
  phoneIntlCode: json['phoneIntlCode'] as String? ?? '81',
  phone: json['phone'] as String? ?? '',
  email: json['email'] as String? ?? '',
  idDocumentPhotoPath: json['idDocumentPhotoPath'] as String?,
  lastUpdatedAt: json['lastUpdatedAt'] == null
      ? null
      : DateTime.parse(json['lastUpdatedAt'] as String),
  lastSkippedAt: json['lastSkippedAt'] == null
      ? null
      : DateTime.parse(json['lastSkippedAt'] as String),
);

Map<String, dynamic> _$$MemberProfileDetailsDtoImplToJson(
  _$MemberProfileDetailsDtoImpl instance,
) => <String, dynamic>{
  'familyName': instance.familyName,
  'givenName': instance.givenName,
  'address': instance.address,
  'phoneIntlCode': instance.phoneIntlCode,
  'phone': instance.phone,
  'email': instance.email,
  'idDocumentPhotoPath': instance.idDocumentPhotoPath,
  'lastUpdatedAt': instance.lastUpdatedAt?.toIso8601String(),
  'lastSkippedAt': instance.lastSkippedAt?.toIso8601String(),
};
