import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_color_tokens.dart';
import 'app_typography_tokens.dart';
import 'ui_tokens.dart';

class AppThemeFactory {
  const AppThemeFactory._();

  static ThemeData light() {
    return _build(Brightness.light);
  }

  static ThemeData dark() {
    return _build(Brightness.dark);
  }

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final background = isDark
        ? AppColorTokens.darkBackground
        : AppColorTokens.lightBackground;
    final surface = isDark
        ? AppColorTokens.darkSurface
        : AppColorTokens.lightSurface;
    final onSurface = isDark
        ? AppColorTokens.darkOnSurface
        : AppColorTokens.lightOnSurface;
    final outline = isDark
        ? AppColorTokens.darkBorder
        : AppColorTokens.lightBorder;
    final textTheme = AppTypographyTokens.textTheme(brightness);

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: AppColorTokens.accent,
      onPrimary: Colors.white,
      secondary: AppColorTokens.accentTertiary,
      onSecondary: Colors.white,
      error: AppColorTokens.danger,
      onError: Colors.white,
      surface: surface,
      onSurface: onSurface,
      tertiary: AppColorTokens.accentSecondary,
      onTertiary: Colors.white,
    );

    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(UiTokens.radius16),
      borderSide: BorderSide(color: outline),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      textTheme: textTheme,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
          TargetPlatform.fuchsia: CupertinoPageTransitionsBuilder(),
        },
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: onSurface,
        titleTextStyle: textTheme.titleLarge,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface.withValues(alpha: isDark ? 0.68 : 0.9),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: (isDark
              ? AppColorTokens.darkMuted
              : AppColorTokens.lightMuted),
        ),
        labelStyle: textTheme.bodyMedium,
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder.copyWith(
          borderSide: const BorderSide(
            color: AppColorTokens.accent,
            width: 1.5,
          ),
        ),
        errorBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: AppColorTokens.danger),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: UiTokens.spacing16,
          vertical: UiTokens.spacing16,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UiTokens.radius20),
          side: BorderSide(color: outline.withValues(alpha: 0.6)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UiTokens.radius20),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(UiTokens.radius28),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll<Size>(
            Size(double.infinity, 52),
          ),
          shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(UiTokens.radius16),
            ),
          ),
          textStyle: WidgetStatePropertyAll<TextStyle?>(textTheme.titleMedium),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll<Size>(
            Size(double.infinity, 52),
          ),
          side: WidgetStatePropertyAll<BorderSide>(BorderSide(color: outline)),
          shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(UiTokens.radius16),
            ),
          ),
          textStyle: WidgetStatePropertyAll<TextStyle?>(textTheme.titleMedium),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UiTokens.radius16),
        ),
        backgroundColor: isDark
            ? const Color(0xFF1B2433)
            : const Color(0xFF1F2937),
      ),
      cupertinoOverrideTheme: NoDefaultCupertinoThemeData(
        brightness: brightness,
        primaryColor: AppColorTokens.accent,
        scaffoldBackgroundColor: background,
        barBackgroundColor: surface.withValues(alpha: 0.8),
        textTheme: CupertinoTextThemeData(
          textStyle: textTheme.bodyLarge,
          navTitleTextStyle: textTheme.titleMedium,
          navLargeTitleTextStyle: textTheme.headlineSmall,
        ),
      ),
    );
  }
}
