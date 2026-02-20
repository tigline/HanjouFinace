import 'package:flutter/material.dart';

import 'app_color_tokens.dart';

class AppTypographyTokens {
  const AppTypographyTokens._();

  static const List<String> fallbackFamily = <String>[
    '.SF Pro Text',
    '.SF Pro Display',
    'PingFang SC',
    'Hiragino Sans',
    'Noto Sans JP',
    'Helvetica Neue',
    'Arial',
    'sans-serif',
  ];

  static TextTheme textTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final onSurface = isDark
        ? AppColorTokens.darkOnSurface
        : AppColorTokens.lightOnSurface;
    final muted = isDark ? AppColorTokens.darkMuted : AppColorTokens.lightMuted;

    TextStyle baseStyle({
      required double size,
      required FontWeight weight,
      required Color color,
      double? height,
      double? letterSpacing,
    }) {
      return TextStyle(
        fontSize: size,
        fontWeight: weight,
        height: height,
        letterSpacing: letterSpacing,
        color: color,
        fontFamilyFallback: fallbackFamily,
      );
    }

    return TextTheme(
      displaySmall: baseStyle(
        size: 34,
        weight: FontWeight.w700,
        color: onSurface,
        height: 1.12,
      ),
      headlineMedium: baseStyle(
        size: 28,
        weight: FontWeight.w700,
        color: onSurface,
        height: 1.15,
      ),
      headlineSmall: baseStyle(
        size: 22,
        weight: FontWeight.w700,
        color: onSurface,
        height: 1.2,
      ),
      titleLarge: baseStyle(
        size: 20,
        weight: FontWeight.w600,
        color: onSurface,
        height: 1.25,
      ),
      titleMedium: baseStyle(
        size: 16,
        weight: FontWeight.w600,
        color: onSurface,
        height: 1.3,
      ),
      bodyLarge: baseStyle(
        size: 16,
        weight: FontWeight.w500,
        color: onSurface,
        height: 1.4,
      ),
      bodyMedium: baseStyle(
        size: 14,
        weight: FontWeight.w500,
        color: onSurface,
        height: 1.42,
      ),
      bodySmall: baseStyle(
        size: 12,
        weight: FontWeight.w500,
        color: muted,
        height: 1.45,
      ),
      labelLarge: baseStyle(
        size: 14,
        weight: FontWeight.w600,
        color: onSurface,
        letterSpacing: 0.1,
      ),
      labelMedium: baseStyle(
        size: 12,
        weight: FontWeight.w600,
        color: muted,
        letterSpacing: 0.2,
      ),
    );
  }
}
