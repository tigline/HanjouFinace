import '../repositories/member_profile_repository.dart';

class IsMemberProfileCompletedUseCase {
  IsMemberProfileCompletedUseCase(this._repository);

  final MemberProfileRepository _repository;

  Future<bool> call() async {
    final profile = await _repository.readLocalProfile();
    return profile?.isComplete ?? false;
  }
}
