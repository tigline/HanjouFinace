import '../entities/invite_friends_info.dart';

abstract class InviteFriendsRepository {
  Future<InviteFriendsInfo> fetchInviteFriendsInfo();
}
