import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

class FundProjectDetailYieldHighlightCard extends StatelessWidget {
  const FundProjectDetailYieldHighlightCard({
    super.key,
    required this.label,
    required this.value,
    required this.disclaimer,
  });

  final String label;
  final String value;
  final String disclaimer;

  @override
  Widget build(BuildContext context) {
    return FundDetailContentCard(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  label,
                  style:
                      (Theme.of(context).textTheme.labelMedium ??
                              const TextStyle())
                          .copyWith(color: AppColorTokens.fundexTextSecondary),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style:
                      (Theme.of(context).textTheme.displaySmall ??
                              const TextStyle())
                          .copyWith(
                            color: AppColorTokens.fundexDanger,
                            fontWeight: FontWeight.w900,
                            height: 1,
                          ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              disclaimer,
              textAlign: TextAlign.end,
              style:
                  (Theme.of(context).textTheme.labelSmall ?? const TextStyle())
                      .copyWith(
                        color: AppColorTokens.fundexTextTertiary,
                        height: 1.5,
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
