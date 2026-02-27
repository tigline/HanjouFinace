import 'package:freezed_annotation/freezed_annotation.dart';

part 'member_profile_details.freezed.dart';

@freezed
class MemberProfileDetails with _$MemberProfileDetails {
  const MemberProfileDetails._();

  const factory MemberProfileDetails({
    @Default('') String familyName,
    @Default('') String givenName,
    @Default('') String address,
    @Default('81') String phoneIntlCode,
    @Default('') String phone,
    @Default('') String email,
    String? idDocumentPhotoPath,
    DateTime? lastUpdatedAt,
    DateTime? lastSkippedAt,
  }) = _MemberProfileDetails;

  bool get isComplete =>
      familyName.trim().isNotEmpty &&
      givenName.trim().isNotEmpty &&
      address.trim().isNotEmpty &&
      phone.trim().isNotEmpty &&
      email.trim().isNotEmpty &&
      (idDocumentPhotoPath?.trim().isNotEmpty ?? false);

  bool get hasAnyInput =>
      familyName.trim().isNotEmpty ||
      givenName.trim().isNotEmpty ||
      address.trim().isNotEmpty ||
      phone.trim().isNotEmpty ||
      email.trim().isNotEmpty ||
      (idDocumentPhotoPath?.trim().isNotEmpty ?? false);

  MemberProfileDetails mergeWithSeed({
    String? familyName,
    String? givenName,
    String? address,
    String? phone,
    String? phoneIntlCode,
    String? email,
  }) {
    String mergeString(String current, String? seed) {
      if (current.trim().isNotEmpty) {
        return current;
      }
      final normalizedSeed = seed?.trim() ?? '';
      return normalizedSeed;
    }

    return copyWith(
      familyName: mergeString(this.familyName, familyName),
      givenName: mergeString(this.givenName, givenName),
      address: mergeString(this.address, address),
      phoneIntlCode: mergeString(this.phoneIntlCode, phoneIntlCode),
      phone: mergeString(this.phone, phone),
      email: mergeString(this.email, email),
    );
  }
}
