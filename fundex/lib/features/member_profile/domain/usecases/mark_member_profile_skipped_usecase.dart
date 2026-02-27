import '../entities/member_profile_details.dart';
import '../repositories/member_profile_repository.dart';

class MarkMemberProfileSkippedUseCase {
  MarkMemberProfileSkippedUseCase(this._repository);

  final MemberProfileRepository _repository;

  Future<void> call({MemberProfileDetails? current}) async {
    final now = DateTime.now().toUtc();
    final existing = current ?? await _repository.readLocalProfile();
    final next = (existing ?? const MemberProfileDetails()).copyWith(
      lastSkippedAt: now,
      lastUpdatedAt: (existing?.lastUpdatedAt ?? now),
    );
    await _repository.saveLocalProfile(next);
  }
}
