import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../support/fund_lottery_apply_models.dart';

class FundLotteryApplySubmittedStep extends StatelessWidget {
  const FundLotteryApplySubmittedStep({
    super.key,
    required this.headline,
    required this.body,
    required this.announcementLabel,
    required this.announcementValue,
    required this.rows,
    required this.hintBody,
    required this.backHomeLabel,
    required this.onBackHome,
    required this.demoResultLabel,
    required this.onDemoCheckResult,
  });

  final String headline;
  final String body;
  final String announcementLabel;
  final String announcementValue;
  final List<FundLotterySummaryRow> rows;
  final String hintBody;
  final String backHomeLabel;
  final VoidCallback onBackHome;
  final String demoResultLabel;
  final VoidCallback onDemoCheckResult;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 38, 20, 32),
      children: <Widget>[
        DecoratedBox(
          decoration: const BoxDecoration(
            color: Colors.white,
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
                    color: const Color.fromARGB(255, 238, 226, 245),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: const Padding(
                      padding: EdgeInsets.all(1),
                      child: Text('📩', textAlign: TextAlign.center, style: TextStyle(fontSize: 40)),
                  )
                  
                ),
                const SizedBox(height: 22),
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
                const SizedBox(height: 18),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColorTokens.fundexViolet.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColorTokens.fundexBorder),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          announcementLabel,
                          style:
                              (theme.textTheme.bodyMedium ?? const TextStyle())
                                  .copyWith(
                                    color: AppColorTokens.fundexViolet,
                                    fontWeight: FontWeight.w800,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          announcementValue,
                          style:
                              (theme.textTheme.bodyLarge ?? const TextStyle())
                                  .copyWith(
                                    fontSize: 18,
                                    color: AppColorTokens.fundexViolet,
                                    fontWeight: FontWeight.w800,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColorTokens.fundexBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: List<Widget>.generate(rows.length, (int index) {
                      final row = rows[index];
                      Color rightValueColor = AppColorTokens.fundexText;
                      if (index == rows.length - 1) {
                        rightValueColor = AppColorTokens.fundexViolet;
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      row.label,
                                      style:
                                          (theme.textTheme.bodySmall ??
                                                  const TextStyle())
                                              .copyWith(
                                                color: AppColorTokens
                                                    .fundexTextSecondary,
                                              ),
                                    ),
                                  ),
                                  Text(
                                    row.value,
                                    style:
                                        (theme.textTheme.bodyMedium ??
                                                const TextStyle())
                                            .copyWith(
                                              color: rightValueColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                  ),
                                ],
                              ),
                            ),
                            if (index < rows.length - 1)
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
                const SizedBox(height: 18),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColorTokens.fundexBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColorTokens.fundexBorder),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text('💡'),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            hintBody,
                            style:
                                (theme.textTheme.bodySmall ?? const TextStyle())
                                    .copyWith(
                                      color: AppColorTokens.fundexTextSecondary,
                                      height: 1.6,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                PrimaryCtaButton(
                  label: backHomeLabel,
                  onPressed: onBackHome,
                  horizontalPadding: 0,
                ),
                const SizedBox(height: 14),
                OutlinedButton(
                  onPressed: onDemoCheckResult,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    side: const BorderSide(color: AppColorTokens.fundexBorder),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    demoResultLabel,
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
