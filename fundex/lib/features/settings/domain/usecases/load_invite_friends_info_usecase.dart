import '../entities/invite_friends_info.dart';
import '../repositories/invite_friends_repository.dart';

class LoadInviteFriendsInfoUseCase {
  const LoadInviteFriendsInfoUseCase(this._repository);

  final InviteFriendsRepository _repository;

  Future<InviteFriendsInfo> call() => _repository.fetchInviteFriendsInfo();
}
