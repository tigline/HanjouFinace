import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FundLotteryApplyAmountStep extends StatelessWidget {
  const FundLotteryApplyAmountStep({
    super.key,
    required this.title,
    required this.balanceLabel,
    required this.balanceValue,
    required this.depositActionLabel,
    required this.investmentAmountLabel,
    required this.amountController,
    required this.quickAmounts,
    required this.selectedAmount,
    required this.onQuickAmountTap,
    required this.onDepositTap,
    required this.estimatedDistributionLabel,
    required this.estimatedDistributionValue,
    required this.nextButtonLabel,
    required this.onNext,
    this.showBalanceWarning = false,
    this.balanceWarningTitle,
    this.balanceWarningBody,
    this.balanceWarningActionLabel,
    this.onBalanceWarningActionTap,
  });

  final String title;
  final String balanceLabel;
  final String balanceValue;
  final String depositActionLabel;
  final String investmentAmountLabel;
  final TextEditingController amountController;
  final List<int> quickAmounts;
  final int selectedAmount;
  final ValueChanged<int> onQuickAmountTap;
  final VoidCallback onDepositTap;
  final String estimatedDistributionLabel;
  final String estimatedDistributionValue;
  final String nextButtonLabel;
  final VoidCallback? onNext;
  final bool showBalanceWarning;
  final String? balanceWarningTitle;
  final String? balanceWarningBody;
  final String? balanceWarningActionLabel;
  final VoidCallback? onBalanceWarningActionTap;

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
        _BalanceCard(
          label: balanceLabel,
          value: balanceValue,
          actionLabel: depositActionLabel,
          onTap: onDepositTap,
        ),
        const SizedBox(height: 14),
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColorTokens.fundexBackground,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColorTokens.fundexBorder),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  investmentAmountLabel,
                  style: (theme.textTheme.bodySmall ?? const TextStyle())
                      .copyWith(
                        color: AppColorTokens.fundexTextSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '¥',
                      style:
                          (theme.textTheme.headlineSmall ?? const TextStyle())
                              .copyWith(
                                color: AppColorTokens.fundexTextSecondary,
                                fontWeight: FontWeight.w700,
                              ),
                    ),
                    const SizedBox(width: 6),
                    SizedBox(
                      width: 190,
                      child: TextField(
                        controller: amountController,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        style:
                            (theme.textTheme.headlineSmall ?? const TextStyle())
                                .copyWith(
                                  color: AppColorTokens.fundexText,
                                  fontWeight: FontWeight.w900,
                                ),
                        decoration: const InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: quickAmounts
              .map(
                (int amount) => _QuickAmountChip(
                  label: _formatQuickAmount(amount),
                  selected: selectedAmount == amount,
                  onTap: () => onQuickAmountTap(amount),
                ),
              )
              .toList(growable: false),
        ),
        if (showBalanceWarning) ...<Widget>[
          const SizedBox(height: 14),
          _BalanceWarningCard(
            title: balanceWarningTitle ?? '',
            body: balanceWarningBody ?? '',
            actionLabel: balanceWarningActionLabel,
            onActionTap: onBalanceWarningActionTap,
          ),
        ],
        const SizedBox(height: 14),
        DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColorTokens.fundexBorder),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  estimatedDistributionLabel,
                  style: (theme.textTheme.bodySmall ?? const TextStyle())
                      .copyWith(
                        color: AppColorTokens.fundexTextSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  estimatedDistributionValue,
                  style: (theme.textTheme.titleLarge ?? const TextStyle())
                      .copyWith(
                        color: AppColorTokens.fundexText,
                        fontWeight: FontWeight.w900,
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

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({
    required this.label,
    required this.value,
    required this.actionLabel,
    required this.onTap,
  });

  final String label;
  final String value;
  final String actionLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColorTokens.fundexBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 12, 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    label,
                    style: (theme.textTheme.bodySmall ?? const TextStyle())
                        .copyWith(
                          color: AppColorTokens.fundexTextSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: (theme.textTheme.headlineSmall ?? const TextStyle())
                        .copyWith(
                          fontWeight: FontWeight.w900,
                          color: AppColorTokens.fundexText,
                        ),
                  ),
                ],
              ),
            ),
            FilledButton.tonal(
              onPressed: onTap,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFDBEAFE),
                foregroundColor: AppColorTokens.fundexAccent,
                minimumSize: const Size(86, 34),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                actionLabel,
                style: (theme.textTheme.labelMedium ?? const TextStyle())
                    .copyWith(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAmountChip extends StatelessWidget {
  const _QuickAmountChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: selected
              ? AppColorTokens.fundexAccent.withValues(alpha: 0.14)
              : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected
                ? AppColorTokens.fundexAccent
                : AppColorTokens.fundexBorder,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Text(
            label,
            style:
                (Theme.of(context).textTheme.labelMedium ?? const TextStyle())
                    .copyWith(
                      color: selected
                          ? AppColorTokens.fundexAccent
                          : AppColorTokens.fundexTextSecondary,
                      fontWeight: FontWeight.w700,
                    ),
          ),
        ),
      ),
    );
  }
}

class _BalanceWarningCard extends StatelessWidget {
  const _BalanceWarningCard({
    required this.title,
    required this.body,
    this.actionLabel,
    this.onActionTap,
  });

  final String title;
  final String body;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFFEE2E2),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFCA5A5)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('⚠️'),
                const SizedBox(width: 8),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: (theme.textTheme.bodySmall ?? const TextStyle())
                          .copyWith(
                            color: AppColorTokens.fundexDanger,
                            height: 1.6,
                          ),
                      children: <InlineSpan>[
                        TextSpan(
                          text: '$title\n',
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        TextSpan(text: body),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if ((actionLabel?.isNotEmpty ?? false) &&
                onActionTap != null) ...<Widget>[
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: onActionTap,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 42),
                  foregroundColor: AppColorTokens.fundexDanger,
                  side: const BorderSide(color: AppColorTokens.fundexDanger),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  actionLabel!,
                  style: (theme.textTheme.labelLarge ?? const TextStyle())
                      .copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

String _formatQuickAmount(int amount) {
  if (amount % 10000 == 0) {
    return '${amount ~/ 10000}万';
  }
  return amount.toString();
}
