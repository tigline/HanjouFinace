import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/network/app_network_providers.dart';
import '../../data/datasources/invite_friends_remote_data_source.dart';
import '../../data/repositories/invite_friends_repository_impl.dart';
import '../../domain/entities/invite_friends_info.dart';
import '../../domain/repositories/invite_friends_repository.dart';
import '../../domain/usecases/load_invite_friends_info_usecase.dart';

final inviteFriendsRemoteDataSourceProvider =
    Provider<InviteFriendsRemoteDataSource>((ref) {
      return InviteFriendsRemoteDataSourceImpl(
        ref.watch(memberCoreHttpClientProvider),
      );
    });

final inviteFriendsRepositoryProvider = Provider<InviteFriendsRepository>((
  ref,
) {
  return InviteFriendsRepositoryImpl(
    ref.watch(inviteFriendsRemoteDataSourceProvider),
  );
});

final inviteFriendsInfoProvider = FutureProvider.autoDispose<InviteFriendsInfo>(
  (ref) {
    return LoadInviteFriendsInfoUseCase(
      ref.watch(inviteFriendsRepositoryProvider),
    ).call();
  },
);
