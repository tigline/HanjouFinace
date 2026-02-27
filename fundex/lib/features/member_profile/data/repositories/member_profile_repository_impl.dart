import '../../domain/entities/member_profile_details.dart';
import '../../domain/repositories/member_profile_repository.dart';
import '../datasources/member_profile_local_data_source.dart';
import '../models/member_profile_details_dto.dart';

class MemberProfileRepositoryImpl implements MemberProfileRepository {
  MemberProfileRepositoryImpl(this._local);

  final MemberProfileLocalDataSource _local;

  @override
  Future<void> clearLocalProfile() {
    return _local.clearProfile();
  }

  @override
  Future<MemberProfileDetails?> readLocalProfile() async {
    final dto = await _local.readProfile();
    return dto?.toEntity();
  }

  @override
  Future<void> saveLocalProfile(MemberProfileDetails profile) {
    return _local.saveProfile(MemberProfileDetailsDto.fromEntity(profile));
  }
}
