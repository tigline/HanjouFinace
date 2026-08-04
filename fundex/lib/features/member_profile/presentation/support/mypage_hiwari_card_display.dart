import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/mypage_models.dart';

class MyPageHiwariCardDisplayData {
  const MyPageHiwariCardDisplayData({
    this.explanation,
    this.blocks = const <MyPageHiwariCardBlockData>[],
  });

  final String? explanation;
  final List<MyPageHiwariCardBlockData> blocks;

  bool get isEmpty => blocks.isEmpty;
  bool get isNotEmpty => blocks.isNotEmpty;
}

class MyPageHiwariCardBlockData {
  const MyPageHiwariCardBlockData({this.badgeLabel, required this.rows});

  final String? badgeLabel;
  final List<MyPageHiwariCardRowData> rows;
}

class MyPageHiwariCardRowData {
  const MyPageHiwariCardRowData({required this.label, required this.value});

  final String label;
  final String value;
}

MyPageHiwariCardDisplayData buildMyPageHiwariCardDisplayData(
  AppLocalizations l10n,
  List<MyPageHiwariJob> jobs,
) {
  if (jobs.isEmpty) {
    return const MyPageHiwariCardDisplayData();
  }

  final hasPreOperationJob = jobs.any(
    (MyPageHiwariJob job) => job.isPreOperation,
  );
  return MyPageHiwariCardDisplayData(
    explanation: hasPreOperationJob ? l10n.myPageHiwariPreOpExplain : null,
    blocks: jobs
        .map(
          (MyPageHiwariJob job) => job.isPreOperation
              ? MyPageHiwariCardBlockData(
                  badgeLabel: l10n.myPageHiwariPreOpProRataBadge,
                  rows: <MyPageHiwariCardRowData>[
                    MyPageHiwariCardRowData(
                      label: l10n.myPageHiwariReturnPeriod,
                      value: l10n.myPageHiwariPeriodRange(
                        _displayValue(job.startDate, l10n),
                        _displayValue(job.endDate, l10n),
                      ),
                    ),
                    MyPageHiwariCardRowData(
                      label: l10n.myPageHiwariEffectiveDays,
                      value: _displayNum(job.num, l10n),
                    ),
                  ],
                )
              : MyPageHiwariCardBlockData(
                  rows: <MyPageHiwariCardRowData>[
                    MyPageHiwariCardRowData(
                      label: l10n.myPageHiwariRevenueBaseDate,
                      value: _displayValue(job.startDate, l10n),
                    ),
                    MyPageHiwariCardRowData(
                      label: l10n.myPageHiwariContractUnits,
                      value: _displayNum(job.num, l10n),
                    ),
                  ],
                ),
        )
        .toList(growable: false),
  );
}

String _displayValue(String? value, AppLocalizations l10n) {
  final normalized = value?.trim();
  if (normalized == null || normalized.isEmpty) {
    return l10n.myPageHiwariMissingValue;
  }
  return normalized;
}

String _displayNum(int? value, AppLocalizations l10n) {
  return value?.toString() ?? l10n.myPageHiwariMissingValue;
}
