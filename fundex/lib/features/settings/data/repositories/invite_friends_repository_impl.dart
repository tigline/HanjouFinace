import '../../domain/entities/invite_friends_info.dart';
import '../../domain/repositories/invite_friends_repository.dart';
import '../datasources/invite_friends_remote_data_source.dart';

class InviteFriendsRepositoryImpl implements InviteFriendsRepository {
  const InviteFriendsRepositoryImpl(this._remote);

  final InviteFriendsRemoteDataSource _remote;

  @override
  Future<InviteFriendsInfo> fetchInviteFriendsInfo() async {
    final dto = await _remote.fetchChannelDetail();
    final inviteCode = dto.inviteCode.trim();
    if (inviteCode.isEmpty) {
      throw StateError('Invitation code is missing.');
    }
    return InviteFriendsInfo(
      inviteCode: inviteCode,
      invitedFriendCount: dto.invitedFriendCount < 0
          ? 0
          : dto.invitedFriendCount,
    );
  }
}
