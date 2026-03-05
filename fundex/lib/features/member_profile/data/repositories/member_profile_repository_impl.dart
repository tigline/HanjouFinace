import '../../domain/entities/member_profile_details.dart';
import '../../domain/repositories/member_profile_repository.dart';
import '../datasources/member_profile_local_data_source.dart';
import '../models/member_profile_details_dto.dart';

class MemberProfileRepositoryImpl implements MemberProfileRepository {
  MemberProfileRepositoryImpl(this._local);

  final MemberProfileLocalDataSource _local;

  @override
  Future<void> clearLocalProfile() async {
    try {
      await _local.clearProfile();
    } catch (_) {
      // Keep member profile features available even when local cache fails.
    }
  }

  @override
  Future<MemberProfileDetails?> readLocalProfile() async {
    try {
      final dto = await _local.readProfile();
      return dto?.toEntity();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveLocalProfile(MemberProfileDetails profile) async {
    try {
      await _local.saveProfile(MemberProfileDetailsDto.fromEntity(profile));
    } catch (_) {
      // Keep member profile features available even when local cache fails.
    }
  }
}
