import '../entities/member_profile_details.dart';

abstract class MemberProfileRepository {
  Future<MemberProfileDetails?> readLocalProfile();
  Future<void> saveLocalProfile(MemberProfileDetails profile);
  Future<void> clearLocalProfile();
  Future<String> uploadProfilePhoto({
    required String filePath,
    required bool isSelfie,
  });
  Future<void> submitProfile(MemberProfileDetails profile);
}
