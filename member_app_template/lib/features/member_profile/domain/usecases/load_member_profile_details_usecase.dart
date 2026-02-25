import '../entities/member_profile_details.dart';
import '../repositories/member_profile_repository.dart';

class LoadMemberProfileDetailsUseCase {
  LoadMemberProfileDetailsUseCase(this._repository);

  final MemberProfileRepository _repository;

  Future<MemberProfileDetails?> call() {
    return _repository.readLocalProfile();
  }
}
