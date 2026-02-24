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
    final textTheme = theme.textTheme;
    final authVisualTheme = theme.extension<AppAuthVisualTheme>();
    assert(
      authVisualTheme != null,
      'AppAuthVisualTheme must be configured in theme',
    );
    final authTheme = authVisualTheme!;

    return Scaffold(
      key: pageKey,
      body: Stack(
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: authTheme.backgroundGradientColors,
              ),
            ),
            child: const SizedBox.expand(),
          ),
          _GlowOrb(
            alignment: const Alignment(-1.15, -0.78),
            color: authTheme.orbPrimary,
            radius: 220,
          ),
          _GlowOrb(
            alignment: const Alignment(1.15, -0.62),
            color: authTheme.orbSecondary,
            radius: 200,
          ),
          _GlowOrb(
            alignment: const Alignment(0.88, 1.05),
            color: authTheme.orbTertiary,
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
                        Text('HANJOU', style: authTheme.brandLabelStyle),
                        const SizedBox(height: UiTokens.spacing16),
                        Text(title, style: textTheme.displaySmall),
                        const SizedBox(height: UiTokens.spacing8),
                        Text(subtitle, style: authTheme.subtitleStyle),
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
                                color: authTheme.glassSurfaceColor,
                                borderRadius: BorderRadius.circular(
                                  UiTokens.radius28,
                                ),
                                border: Border.all(
                                  color: authTheme.glassBorderColor,
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
