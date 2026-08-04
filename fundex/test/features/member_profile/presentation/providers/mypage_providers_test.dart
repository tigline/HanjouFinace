import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/member_profile/domain/entities/mypage_models.dart';
import 'package:fundex/features/member_profile/presentation/providers/mypage_providers.dart';

void main() {
  test(
    'home apply section keeps pending records without loading history',
    () async {
      final pendingRecord = _record('pending', status: 0);
      final container = ProviderContainer(
        overrides: <Override>[
          myPagePendingApplyListProvider.overrideWith(
            (ref) async => <MyPageApplyRecord>[pendingRecord],
          ),
          myPageApplyListProvider.overrideWith(
            (ref) => throw StateError('history should not be loaded'),
          ),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(
        myPageHomeApplySectionProvider.future,
      );

      expect(result.showsHistory, isFalse);
      expect(result.records, <MyPageApplyRecord>[pendingRecord]);
    },
  );

  test('home apply section falls back to records of every status', () async {
    final historyRecords = <MyPageApplyRecord>[
      _record('completed', status: 3),
      _record('invalid', status: 5),
    ];
    final container = ProviderContainer(
      overrides: <Override>[
        myPagePendingApplyListProvider.overrideWith(
          (ref) async => const <MyPageApplyRecord>[],
        ),
        myPageApplyListProvider.overrideWith((ref) async => historyRecords),
      ],
    );
    addTearDown(container.dispose);

    final result = await container.read(myPageHomeApplySectionProvider.future);

    expect(result.showsHistory, isTrue);
    expect(result.records, historyRecords);
    expect(result.records.map((record) => record.status), <int?>[3, 5]);
  });
}

MyPageApplyRecord _record(String projectName, {required int status}) {
  return MyPageApplyRecord(projectName: projectName, status: status);
}
