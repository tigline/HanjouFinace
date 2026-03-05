import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../support/fund_lottery_apply_models.dart';

class FundLotteryApplyDocumentsStep extends StatelessWidget {
  const FundLotteryApplyDocumentsStep({
    super.key,
    required this.title,
    required this.description,
    required this.documents,
    required this.checkedIndexes,
    required this.onToggleDocument,
    required this.infoBody,
    required this.nextButtonLabel,
    required this.onNext,
  });

  final String title;
  final String description;
  final List<FundLotteryDocumentItem> documents;
  final Set<int> checkedIndexes;
  final ValueChanged<int> onToggleDocument;
  final String infoBody;
  final String nextButtonLabel;
  final VoidCallback? onNext;

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
        const SizedBox(height: 8),
        Text(
          description,
          style: (theme.textTheme.bodySmall ?? const TextStyle()).copyWith(
            color: AppColorTokens.fundexTextSecondary,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 14),
        ...List<Widget>.generate(documents.length, (int index) {
          final item = documents[index];
          return Padding(
            padding: EdgeInsets.only(
              bottom: index == documents.length - 1 ? 0 : 10,
            ),
            child: _DocumentTile(
              title: item.title,
              subtitle: item.subtitle,
              checked: checkedIndexes.contains(index),
              onTap: () => onToggleDocument(index),
            ),
          );
        }),
        const SizedBox(height: 14),
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColorTokens.fundexBackground,
            borderRadius: BorderRadius.circular(14),
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
                    infoBody,
                    style: (theme.textTheme.bodySmall ?? const TextStyle())
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
          label: nextButtonLabel,
          onPressed: onNext,
          horizontalPadding: 0,
        ),
      ],
    );
  }
}

class _DocumentTile extends StatelessWidget {
  const _DocumentTile({
    required this.title,
    required this.subtitle,
    required this.checked,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool checked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColorTokens.fundexBorder),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          child: Row(
            children: <Widget>[
              DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColorTokens.fundexBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    Icons.description_outlined,
                    size: 18,
                    color: AppColorTokens.fundexTextSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: (theme.textTheme.bodyMedium ?? const TextStyle())
                          .copyWith(
                            color: AppColorTokens.fundexText,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: (theme.textTheme.labelSmall ?? const TextStyle())
                          .copyWith(
                            color: AppColorTokens.fundexTextSecondary,
                            height: 1.5,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: checked ? AppColorTokens.fundexAccent : Colors.white,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: checked
                        ? AppColorTokens.fundexAccent
                        : AppColorTokens.fundexBorder,
                    width: 1.5,
                  ),
                ),
                child: checked
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
    );
  }
}
