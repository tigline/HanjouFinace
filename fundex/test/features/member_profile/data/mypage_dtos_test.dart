import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/member_profile/data/models/mypage_dtos.dart';

void main() {
  test('maps hiwari jobs from SDK DTO to the domain entity', () {
    const dto = UserInvestmentRecordDto(
      projectId: 'p-1',
      projectName: '白馬ホテルファンド',
      hiwariJobs: <UserInvestmentHiwariJobDto>[
        UserInvestmentHiwariJobDto(
          startDate: '2026-03-10',
          endDate: '2026-03-31',
          num: 500,
        ),
        UserInvestmentHiwariJobDto(
          processId: 'proc-1',
          startDate: '2026-04-01',
          num: 500,
        ),
      ],
    );

    final entity = dto.toEntity();

    expect(entity.hiwariJobs, hasLength(2));
    expect(entity.hiwariJobs.first.isPreOperation, isTrue);
    expect(entity.hiwariJobs.first.endDate, '2026-03-31');
    expect(entity.hiwariJobs.last.isPreOperation, isFalse);
    expect(entity.hiwariJobs.last.processId, 'proc-1');
  });
}
