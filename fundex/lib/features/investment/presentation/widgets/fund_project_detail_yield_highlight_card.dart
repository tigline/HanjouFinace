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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[Color(0xFFFEF2F2), Color(0xFFFFF1F2)],
        ),
        border: Border.all(color: const Color(0xFFFECACA), width: 1.5),
        borderRadius: BorderRadius.circular(UiTokens.radius16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            label,
            textAlign: TextAlign.center,
            style: (Theme.of(context).textTheme.titleSmall ?? const TextStyle())
                .copyWith(
                  color: AppColorTokens.fundexTextSecondary,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 10),
          _YieldValueText(value: value),
          const SizedBox(height: 6),
          Text(
            disclaimer,
            textAlign: TextAlign.center,
            style: (Theme.of(context).textTheme.labelSmall ?? const TextStyle())
                .copyWith(
                  color: AppColorTokens.fundexTextTertiary,
                  height: 1.4,
                ),
          ),
        ],
      ),
    );
  }
}

class _YieldValueText extends StatelessWidget {
  const _YieldValueText({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    final parsed = _parseYield(value);
    final numberStyle =
        (Theme.of(context).textTheme.displayLarge ?? const TextStyle())
            .copyWith(
              color: AppColorTokens.fundexDanger,
              fontWeight: FontWeight.w900,
              fontSize: 58,
              height: 0.95,
              letterSpacing: -1.2,
            );
    final suffixStyle =
        (Theme.of(context).textTheme.displaySmall ?? const TextStyle())
            .copyWith(
              color: AppColorTokens.fundexDanger,
              fontWeight: FontWeight.w900,
              fontSize: 24,
              height: 1.1,
            );

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(parsed.number, style: numberStyle),
          if (parsed.suffix.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(parsed.suffix, style: suffixStyle),
            ),
        ],
      ),
    );
  }
}

({String number, String suffix}) _parseYield(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) {
    return (number: '--', suffix: '');
  }
  final match = RegExp(r'^([+-]?\d+(?:\.\d+)?)\s*(%)?$').firstMatch(trimmed);
  if (match == null) {
    return (number: trimmed, suffix: '');
  }
  final number = match.group(1) ?? '--';
  final suffix = match.group(2) ?? '';
  return (number: number, suffix: suffix);
}
