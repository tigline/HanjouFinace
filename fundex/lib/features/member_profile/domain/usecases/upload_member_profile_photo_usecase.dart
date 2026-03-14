import '../repositories/member_profile_repository.dart';

class UploadMemberProfilePhotoUseCase {
  UploadMemberProfilePhotoUseCase(this._repository);

  final MemberProfileRepository _repository;

  Future<String> call({required String filePath, required bool isSelfie}) {
    return _repository.uploadProfilePhoto(
      filePath: filePath,
      isSelfie: isSelfie,
    );
  }
}
