import '../entities/member_profile_details.dart';
import '../repositories/member_profile_repository.dart';

class SubmitMemberProfileUseCase {
  SubmitMemberProfileUseCase(this._repository);

  final MemberProfileRepository _repository;

  Future<void> call(MemberProfileDetails profile) {
    return _repository.submitProfile(profile);
  }
}
