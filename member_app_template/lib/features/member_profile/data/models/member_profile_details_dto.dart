import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/member_profile_details.dart';

part 'member_profile_details_dto.freezed.dart';
part 'member_profile_details_dto.g.dart';

@freezed
class MemberProfileDetailsDto with _$MemberProfileDetailsDto {
  const MemberProfileDetailsDto._();

  const factory MemberProfileDetailsDto({
    @Default('') String familyName,
    @Default('') String givenName,
    @Default('') String address,
    @Default('81') String phoneIntlCode,
    @Default('') String phone,
    @Default('') String email,
    String? idDocumentPhotoPath,
    DateTime? lastUpdatedAt,
    DateTime? lastSkippedAt,
  }) = _MemberProfileDetailsDto;

  factory MemberProfileDetailsDto.fromJson(Map<String, dynamic> json) =>
      _$MemberProfileDetailsDtoFromJson(json);

  factory MemberProfileDetailsDto.fromEntity(MemberProfileDetails entity) {
    return MemberProfileDetailsDto(
      familyName: entity.familyName,
      givenName: entity.givenName,
      address: entity.address,
      phoneIntlCode: entity.phoneIntlCode,
      phone: entity.phone,
      email: entity.email,
      idDocumentPhotoPath: entity.idDocumentPhotoPath,
      lastUpdatedAt: entity.lastUpdatedAt,
      lastSkippedAt: entity.lastSkippedAt,
    );
  }

  MemberProfileDetails toEntity() {
    return MemberProfileDetails(
      familyName: familyName,
      givenName: givenName,
      address: address,
      phoneIntlCode: phoneIntlCode,
      phone: phone,
      email: email,
      idDocumentPhotoPath: idDocumentPhotoPath,
      lastUpdatedAt: lastUpdatedAt,
      lastSkippedAt: lastSkippedAt,
    );
  }
}
