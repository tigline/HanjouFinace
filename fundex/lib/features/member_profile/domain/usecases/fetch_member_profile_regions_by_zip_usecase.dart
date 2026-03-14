import '../entities/member_profile_region.dart';
import '../repositories/member_profile_repository.dart';

class FetchMemberProfileRegionsByZipUseCase {
  FetchMemberProfileRegionsByZipUseCase(this._repository);

  final MemberProfileRepository _repository;

  Future<List<MemberProfileRegion>> call({required String zip}) {
    return _repository.fetchRegionsByZip(zip: zip);
  }
}
