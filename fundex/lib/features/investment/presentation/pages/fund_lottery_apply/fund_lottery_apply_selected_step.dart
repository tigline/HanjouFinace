import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../support/fund_lottery_apply_models.dart';

class FundLotteryApplySelectedStep extends StatelessWidget {
  const FundLotteryApplySelectedStep({
    super.key,
    required this.headline,
    required this.body,
    required this.deadlineLabel,
    required this.deadlineValue,
    required this.coolingOffTitle,
    required this.coolingOffBody,
    required this.depositRows,
    required this.reportDepositButtonLabel,
    required this.onReportDeposit,
    required this.laterButtonLabel,
    required this.onLaterDeposit,
    required this.copyButtonLabel,
    required this.onCopyValue,
  });

  final String headline;
  final String body;
  final String deadlineLabel;
  final String deadlineValue;
  final String coolingOffTitle;
  final String coolingOffBody;
  final List<FundLotteryDepositRow> depositRows;
  final String reportDepositButtonLabel;
  final VoidCallback onReportDeposit;
  final String laterButtonLabel;
  final VoidCallback onLaterDeposit;
  final String copyButtonLabel;
  final ValueChanged<String> onCopyValue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 32),
      children: <Widget>[
        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            //border: Border.all(color: AppColorTokens.fundexBorder),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 18),
            child: Column(
              children: <Widget>[
                Container(
                  width: 80,
                  height: 80,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColorTokens.fundexSuccess.withValues(alpha: 0.20),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('🎉',textAlign: TextAlign.center, style: TextStyle(fontSize: 32)),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  headline,
                  textAlign: TextAlign.center,
                  style: (theme.textTheme.titleLarge ?? const TextStyle())
                      .copyWith(
                        color: AppColorTokens.fundexText,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  body,
                  textAlign: TextAlign.center,
                  style: (theme.textTheme.bodyMedium ?? const TextStyle())
                      .copyWith(
                        color: AppColorTokens.fundexTextSecondary,
                        height: 1.7,
                      ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColorTokens.fundexDangerLight,
                    borderRadius: BorderRadius.circular(12),
                    //border: Border.all(color: const Color(0xFFFCD34D)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          deadlineLabel,
                          style:
                              (theme.textTheme.bodyMedium ?? const TextStyle())
                                  .copyWith(
                                    color: AppColorTokens.fundexDanger,
                                    fontWeight: FontWeight.w800,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          deadlineValue,
                          style:
                              (theme.textTheme.bodyLarge ?? const TextStyle())
                                  .copyWith(
                                    fontSize: 18,
                                    color: AppColorTokens.fundexDanger,
                                    fontWeight: FontWeight.w900,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(12),
                    //border: Border.all(color: const Color(0xFFFCD34D)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text('📋', style: TextStyle(fontSize: 18),),
                        const SizedBox(width: 8),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style:
                                  (theme.textTheme.bodySmall ??
                                          const TextStyle())
                                      .copyWith(
                                        color: const Color(0xFF92400E),
                                        height: 1.6,
                                      ),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: '$coolingOffTitle\n',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                TextSpan(text: coolingOffBody),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColorTokens.fundexBackground,
                    borderRadius: BorderRadius.circular(12),
                    //border: Border.all(color: AppColorTokens.fundexBorder),
                  ),
                  child: Column(
                    children: List<Widget>.generate(depositRows.length, (
                      int index,
                    ) {
                      final row = depositRows[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                      row.label,
                                      style:
                                          (theme.textTheme.bodySmall ??
                                                  const TextStyle())
                                              .copyWith(
                                                color: AppColorTokens
                                                    .fundexTextSecondary,
                                              ),
                                  ),
                                  
                                  Flexible(
                                    child: Wrap(
                                      spacing: 8,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      alignment: WrapAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          row.value,
                                          textAlign: TextAlign.end,
                                          style:
                                              (theme.textTheme.bodyMedium ??
                                                      const TextStyle())
                                                  .copyWith(
                                                    color: AppColorTokens
                                                        .fundexText,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                        ),
                                        if (row.copyable)
                                          _CopyButton(
                                            label: copyButtonLabel,
                                            onTap: () => onCopyValue(row.value),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (index < depositRows.length - 1)
                              const Divider(
                                height: 1,
                                thickness: 1,
                                color: AppColorTokens.fundexBorder,
                              ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 16),
                PrimaryCtaButton(
                  label: reportDepositButtonLabel,
                  onPressed: onReportDeposit,
                  horizontalPadding: 0,
                  backgroundColor: AppColorTokens.fundexSuccess,
                  shadowColor: AppColorTokens.fundexSuccess.withValues(
                    alpha: 0.34,
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: onLaterDeposit,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    side: const BorderSide(color: AppColorTokens.fundexBorder),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    laterButtonLabel,
                    style: (theme.textTheme.labelLarge ?? const TextStyle())
                        .copyWith(
                          color: AppColorTokens.fundexText,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CopyButton extends StatelessWidget {
  const _CopyButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFDBEAFE),
      borderRadius: BorderRadius.circular(7),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(7),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(
            label,
            style: (Theme.of(context).textTheme.labelSmall ?? const TextStyle())
                .copyWith(
                  color: AppColorTokens.fundexAccent,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
      ),
    );
  }
}
