import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/storage/app_storage_providers.dart';
import '../../data/datasources/member_profile_local_data_source.dart';
import '../../data/repositories/member_profile_repository_impl.dart';
import '../../domain/entities/member_profile_details.dart';
import '../../domain/repositories/member_profile_repository.dart';
import '../../domain/usecases/is_member_profile_completed_usecase.dart';
import '../../domain/usecases/load_member_profile_details_usecase.dart';
import '../../domain/usecases/mark_member_profile_skipped_usecase.dart';
import '../../domain/usecases/save_member_profile_details_usecase.dart';
import '../support/profile_document_image_picker.dart';

final memberProfileLocalDataSourceProvider =
    Provider<MemberProfileLocalDataSource>((ref) {
      return MemberProfileLocalDataSourceImpl(
        ref.watch(largeDataStoreProvider),
      );
    });

final memberProfileRepositoryProvider = Provider<MemberProfileRepository>((
  ref,
) {
  return MemberProfileRepositoryImpl(
    ref.watch(memberProfileLocalDataSourceProvider),
  );
});

final loadMemberProfileDetailsUseCaseProvider =
    Provider<LoadMemberProfileDetailsUseCase>((ref) {
      return LoadMemberProfileDetailsUseCase(
        ref.watch(memberProfileRepositoryProvider),
      );
    });

final saveMemberProfileDetailsUseCaseProvider =
    Provider<SaveMemberProfileDetailsUseCase>((ref) {
      return SaveMemberProfileDetailsUseCase(
        ref.watch(memberProfileRepositoryProvider),
      );
    });

final isMemberProfileCompletedUseCaseProvider =
    Provider<IsMemberProfileCompletedUseCase>((ref) {
      return IsMemberProfileCompletedUseCase(
        ref.watch(memberProfileRepositoryProvider),
      );
    });

final markMemberProfileSkippedUseCaseProvider =
    Provider<MarkMemberProfileSkippedUseCase>((ref) {
      return MarkMemberProfileSkippedUseCase(
        ref.watch(memberProfileRepositoryProvider),
      );
    });

final memberProfileDetailsProvider = FutureProvider<MemberProfileDetails?>((
  ref,
) async {
  return ref.watch(loadMemberProfileDetailsUseCaseProvider).call();
});

final isMemberProfileCompletedProvider = FutureProvider<bool>((ref) async {
  return ref.watch(isMemberProfileCompletedUseCaseProvider).call();
});

final profileDocumentImagePickerProvider = Provider<ProfileDocumentImagePicker>(
  (ref) {
    return DeviceProfileDocumentImagePicker();
  },
);
