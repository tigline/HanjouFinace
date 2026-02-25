import 'package:flutter_test/flutter_test.dart';
import 'package:member_app_template/features/member_profile/domain/entities/member_profile_details.dart';
import 'package:member_app_template/features/member_profile/domain/repositories/member_profile_repository.dart';
import 'package:member_app_template/features/member_profile/domain/usecases/is_member_profile_completed_usecase.dart';

class _FakeMemberProfileRepository implements MemberProfileRepository {
  _FakeMemberProfileRepository({this.profile});

  MemberProfileDetails? profile;

  @override
  Future<void> clearLocalProfile() async {
    profile = null;
  }

  @override
  Future<MemberProfileDetails?> readLocalProfile() async => profile;

  @override
  Future<void> saveLocalProfile(MemberProfileDetails profile) async {
    this.profile = profile;
  }
}

void main() {
  group('IsMemberProfileCompletedUseCase', () {
    test('returns false when no profile exists', () async {
      final repository = _FakeMemberProfileRepository();
      final useCase = IsMemberProfileCompletedUseCase(repository);

      expect(await useCase.call(), isFalse);
    });

    test('returns false for incomplete profile', () async {
      final repository = _FakeMemberProfileRepository(
        profile: const MemberProfileDetails(
          familyName: 'Hou',
          givenName: 'Aaron',
          address: 'Tokyo',
          phone: '09012345678',
          email: '',
        ),
      );
      final useCase = IsMemberProfileCompletedUseCase(repository);

      expect(await useCase.call(), isFalse);
    });

    test('returns true for completed profile', () async {
      final repository = _FakeMemberProfileRepository(
        profile: const MemberProfileDetails(
          familyName: 'Hou',
          givenName: 'Aaron',
          address: 'Tokyo',
          phoneIntlCode: '81',
          phone: '09012345678',
          email: 'aaron@example.com',
          idDocumentPhotoPath: '/tmp/id.jpg',
        ),
      );
      final useCase = IsMemberProfileCompletedUseCase(repository);

      expect(await useCase.call(), isTrue);
    });
  });
}
