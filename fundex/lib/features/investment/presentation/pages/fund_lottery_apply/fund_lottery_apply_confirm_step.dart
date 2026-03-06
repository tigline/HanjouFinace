import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../support/fund_lottery_apply_models.dart';

class FundLotteryApplyConfirmStep extends StatelessWidget {
  const FundLotteryApplyConfirmStep({
    super.key,
    required this.title,
    required this.rows,
    required this.noticeTitle,
    required this.noticeBody,
    required this.agreementLabel,
    required this.agreed,
    required this.onAgreementChanged,
    required this.applyButtonLabel,
    required this.onApply,
  });

  final String title;
  final List<FundLotterySummaryRow> rows;
  final String noticeTitle;
  final String noticeBody;
  final String agreementLabel;
  final bool agreed;
  final ValueChanged<bool> onAgreementChanged;
  final String applyButtonLabel;
  final VoidCallback? onApply;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      children: <Widget>[
        Text(
          title,
          style: (theme.textTheme.titleMedium ?? const TextStyle()).copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColorTokens.fundexText,
          ),
        ),
        const SizedBox(height: 14),
        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColorTokens.fundexBorder),
          ),
          child: Column(
            children: List<Widget>.generate(rows.length, (int index) {
              final row = rows[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              row.label,
                              style:
                                  (theme.textTheme.bodySmall ??
                                          const TextStyle())
                                      .copyWith(
                                        color:
                                            AppColorTokens.fundexTextSecondary,
                                        fontWeight: FontWeight.w600,
                                      ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              row.value,
                              textAlign: TextAlign.end,
                              style:
                                  (theme.textTheme.bodyMedium ??
                                          const TextStyle())
                                      .copyWith(
                                        color: AppColorTokens.fundexText,
                                        fontWeight: FontWeight.w700,
                                      ),
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
        const SizedBox(height: 14),
        DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xFFFFF7ED),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFFCD34D)),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('⚠️'),
                const SizedBox(width: 8),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: (theme.textTheme.bodySmall ?? const TextStyle())
                          .copyWith(
                            color: const Color(0xFF92400E),
                            height: 1.6,
                          ),
                      children: <InlineSpan>[
                        TextSpan(
                          text: '$noticeTitle\n',
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        TextSpan(text: noticeBody),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        InkWell(
          onTap: () => onAgreementChanged(!agreed),
          borderRadius: BorderRadius.circular(14),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColorTokens.fundexBorder),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      agreementLabel,
                      style: (theme.textTheme.bodyMedium ?? const TextStyle())
                          .copyWith(
                            color: AppColorTokens.fundexText,
                            fontWeight: FontWeight.w600,
                            height: 1.5,
                          ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: agreed
                          ? AppColorTokens.fundexAccent
                          : Colors.white,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: agreed
                            ? AppColorTokens.fundexAccent
                            : AppColorTokens.fundexBorder,
                        width: 1.5,
                      ),
                    ),
                    child: agreed
                        ? const Icon(
                            Icons.check_rounded,
                            size: 15,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        PrimaryCtaButton(
          label: applyButtonLabel,
          onPressed: onApply,
          horizontalPadding: 0,
          backgroundColor: AppColorTokens.fundexViolet,
          shadowColor: AppColorTokens.fundexViolet.withValues(alpha: 0.36),
        ),
      ],
    );
  }
}
