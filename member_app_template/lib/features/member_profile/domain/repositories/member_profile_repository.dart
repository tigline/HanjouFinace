import '../entities/member_profile_details.dart';

abstract class MemberProfileRepository {
  Future<MemberProfileDetails?> readLocalProfile();
  Future<void> saveLocalProfile(MemberProfileDetails profile);
  Future<void> clearLocalProfile();
}
