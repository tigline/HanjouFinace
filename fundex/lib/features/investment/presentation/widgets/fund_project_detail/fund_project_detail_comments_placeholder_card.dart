import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../../app/localization/app_localizations_ext.dart';

class FundProjectDetailCommentsPlaceholderCard extends StatelessWidget {
  const FundProjectDetailCommentsPlaceholderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return FundDetailContentCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColorTokens.fundexVioletLight,
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Icon(
              Icons.chat_bubble_outline_rounded,
              size: 18,
              color: AppColorTokens.fundexViolet,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              context.l10n.fundDetailCommentsPlaceholder,
              style:
                  (Theme.of(context).textTheme.bodySmall ?? const TextStyle())
                      .copyWith(
                        color: AppColorTokens.fundexTextSecondary,
                        height: 1.7,
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
