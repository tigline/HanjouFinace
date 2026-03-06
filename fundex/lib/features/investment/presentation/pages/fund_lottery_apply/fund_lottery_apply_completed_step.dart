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
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          child: Column(
            children: <Widget>[
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColorTokens.fundexSuccess.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Icon(
                    Icons.check_rounded,
                    color: AppColorTokens.fundexSuccess,
                    size: 38,
                  ),
                ),
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
              const SizedBox(height: 32),
              PrimaryCtaButton(
                label: backHomeLabel,
                onPressed: onBackHome,
                horizontalPadding: 0,
              ),
            ],
          ),
        ),
      ),
    ]
    );
  }
}
