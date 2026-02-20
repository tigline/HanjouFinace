import 'dart:ui';

import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

class AuthVisualScaffold extends StatelessWidget {
  const AuthVisualScaffold({
    super.key,
    required this.pageKey,
    required this.title,
    required this.subtitle,
    required this.child,
    this.footer,
  });

  final Key pageKey;
  final String title;
  final String subtitle;
  final Widget child;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textTheme = theme.textTheme;

    final gradientColors = isDark
        ? <Color>[
            const Color(0xFF0B0F17),
            const Color(0xFF101A2A),
            const Color(0xFF15253B),
          ]
        : <Color>[
            const Color(0xFFEAF3FF),
            const Color(0xFFF8FBFF),
            const Color(0xFFE7FFF8),
          ];

    return Scaffold(
      key: pageKey,
      body: Stack(
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradientColors,
              ),
            ),
            child: const SizedBox.expand(),
          ),
          _GlowOrb(
            alignment: const Alignment(-1.15, -0.78),
            color: AppColorTokens.accent.withValues(alpha: 0.28),
            radius: 220,
          ),
          _GlowOrb(
            alignment: const Alignment(1.15, -0.62),
            color: AppColorTokens.accentTertiary.withValues(alpha: 0.24),
            radius: 200,
          ),
          _GlowOrb(
            alignment: const Alignment(0.88, 1.05),
            color: AppColorTokens.accentSecondary.withValues(alpha: 0.22),
            radius: 240,
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    UiTokens.spacing20,
                    UiTokens.spacing20,
                    UiTokens.spacing20,
                    UiTokens.spacing24,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 40,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: UiTokens.spacing8),
                        Text(
                          'HANJOU',
                          style: textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.72,
                            ),
                            letterSpacing: 2.4,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: UiTokens.spacing16),
                        Text(title, style: textTheme.displaySmall),
                        const SizedBox(height: UiTokens.spacing8),
                        Text(
                          subtitle,
                          style: textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.72,
                            ),
                          ),
                        ),
                        const SizedBox(height: UiTokens.spacing24),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                            UiTokens.radius28,
                          ),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surface.withValues(
                                  alpha: isDark ? 0.66 : 0.82,
                                ),
                                borderRadius: BorderRadius.circular(
                                  UiTokens.radius28,
                                ),
                                border: Border.all(
                                  color: theme.colorScheme.onSurface.withValues(
                                    alpha: 0.14,
                                  ),
                                ),
                              ),
                              padding: const EdgeInsets.all(UiTokens.spacing20),
                              child: child,
                            ),
                          ),
                        ),
                        if (footer != null) ...<Widget>[
                          const SizedBox(height: UiTokens.spacing20),
                          footer!,
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({
    required this.alignment,
    required this.color,
    required this.radius,
  });

  final Alignment alignment;
  final Color color;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: IgnorePointer(
        child: Container(
          width: radius,
          height: radius,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: <Color>[color, color.withValues(alpha: 0)],
            ),
          ),
        ),
      ),
    );
  }
}
