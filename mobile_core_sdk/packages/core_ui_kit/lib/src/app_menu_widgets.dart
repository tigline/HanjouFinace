import 'package:flutter/material.dart';

import 'app_color_tokens.dart';
import 'ui_tokens.dart';

class AppMenuSection extends StatelessWidget {
  const AppMenuSection({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 6),
            child: Text(
              title,
              style:
                  (Theme.of(context).textTheme.labelSmall ?? const TextStyle())
                      .copyWith(
                        color: AppColorTokens.fundexTextTertiary,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}

class AppMenuItem extends StatelessWidget {
  const AppMenuItem({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.trailing,
    this.iconBackgroundColor = const Color(0xFFF1F5F9),
    this.iconForegroundColor = AppColorTokens.fundexTextSecondary,
    this.showChevron = true,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color iconBackgroundColor;
  final Color iconForegroundColor;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Material(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(UiTokens.radius12),
        child: InkWell(
          borderRadius: BorderRadius.circular(UiTokens.radius12),
          onTap: onTap,
          child: Ink(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(UiTokens.radius12),
              border: Border.all(color: AppColorTokens.fundexBorder),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: iconBackgroundColor,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Icon(icon, size: 16, color: iconForegroundColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: (theme.textTheme.bodyMedium ?? const TextStyle())
                        .copyWith(
                          color: AppColorTokens.fundexText,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                if (trailing != null) ...<Widget>[
                  trailing!,
                  if (showChevron) const SizedBox(width: 8),
                ],
                if (showChevron)
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: AppColorTokens.fundexTextTertiary,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
