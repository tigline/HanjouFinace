import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

class FundLotteryApplyCompletedStep extends StatelessWidget {
  const FundLotteryApplyCompletedStep({
    super.key,
    required this.headline,
    required this.body,
    required this.receiptLabel,
    required this.receiptValue,
    required this.backHomeLabel,
    required this.onBackHome,
  });

  final String headline;
  final String body;
  final String receiptLabel;
  final String receiptValue;
  final String backHomeLabel;
  final VoidCallback onBackHome;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColorTokens.fundexBorder),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
            child: Column(
              children: <Widget>[
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColorTokens.fundexSuccess,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
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
                  style: (theme.textTheme.bodySmall ?? const TextStyle())
                      .copyWith(
                        color: AppColorTokens.fundexTextSecondary,
                        height: 1.7,
                      ),
                ),
                const SizedBox(height: 14),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColorTokens.fundexBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColorTokens.fundexBorder),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                    child: Text.rich(
                      TextSpan(
                        style: (theme.textTheme.bodyMedium ?? const TextStyle())
                            .copyWith(color: AppColorTokens.fundexText),
                        children: <InlineSpan>[
                          TextSpan(text: '$receiptLabel '),
                          TextSpan(
                            text: receiptValue,
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                PrimaryCtaButton(
                  label: backHomeLabel,
                  onPressed: onBackHome,
                  horizontalPadding: 0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
