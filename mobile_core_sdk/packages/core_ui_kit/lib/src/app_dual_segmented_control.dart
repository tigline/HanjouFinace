import 'package:flutter/material.dart';

import 'app_theme_extensions.dart';

class AppDualSegmentItem<T> {
  const AppDualSegmentItem({
    required this.value,
    required this.label,
    this.icon,
    this.key,
  });

  final T value;
  final String label;
  final IconData? icon;
  final Key? key;
}

class AppDualSegmentedControl<T> extends StatelessWidget {
  const AppDualSegmentedControl({
    super.key,
    required this.first,
    required this.second,
    required this.value,
    required this.onChanged,
    this.height = 56,
    this.radius = 18,
  });

  final AppDualSegmentItem<T> first;
  final AppDualSegmentItem<T> second;
  final T value;
  final ValueChanged<T> onChanged;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final isDark = theme.brightness == Brightness.dark;
    final radius = BorderRadius.circular(this.radius);
    final selectedBackgroundColor = isDark
        ? Color.alphaBlend(
            colors.highlightGold.withValues(alpha: 0.20),
            colors.surfaceAlt,
          )
        : Color.alphaBlend(
            colors.highlightGold.withValues(alpha: 0.28),
            colors.surface,
          );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: radius,
        border: Border.all(
          color: isDark
              ? colors.border
              : colors.textPrimary.withValues(alpha: 0.12),
        ),
        boxShadow: isDark
            ? const <BoxShadow>[]
            : <BoxShadow>[
                BoxShadow(
                  color: colors.scrim.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: SizedBox(
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            AnimatedAlign(
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeOutCubic,
              alignment: value == first.value
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: FractionallySizedBox(
                widthFactor: 0.5,
                heightFactor: 1,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: selectedBackgroundColor,
                    borderRadius: BorderRadius.circular(this.radius - 4),
                  ),
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: _AppDualSegmentButton<T>(
                    item: first,
                    selected: value == first.value,
                    onTap: () => onChanged(first.value),
                  ),
                ),
                Expanded(
                  child: _AppDualSegmentButton<T>(
                    item: second,
                    selected: value == second.value,
                    onTap: () => onChanged(second.value),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AppDualSegmentButton<T> extends StatelessWidget {
  const _AppDualSegmentButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final AppDualSegmentItem<T> item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final isDark = theme.brightness == Brightness.dark;
    final selectedForegroundColor = isDark ? colors.onDark : colors.primary;
    final idleForegroundColor = isDark
        ? colors.textSecondary
        : colors.textSecondary.withValues(alpha: 0.94);
    final foregroundColor = selected
        ? selectedForegroundColor
        : idleForegroundColor;

    return GestureDetector(
      key: item.key,
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (item.icon != null) ...<Widget>[
              Icon(item.icon, size: 17, color: foregroundColor),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOutCubic,
                style: (theme.textTheme.labelLarge ?? const TextStyle())
                    .copyWith(
                      color: foregroundColor,
                      fontWeight: FontWeight.w700,
                    ),
                child: Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
