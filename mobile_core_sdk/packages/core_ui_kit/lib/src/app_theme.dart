import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_color_tokens.dart';
import 'app_theme_extensions.dart';
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
    final contentMuted = onSurface.withValues(alpha: 0.72);

    final authVisualTheme = AppAuthVisualTheme(
      backgroundGradientColors: isDark
          ? const <Color>[
              AppColorTokens.darkBackground,
              Color(0xFF101A2A),
              Color(0xFF15253B),
            ]
          : const <Color>[
              Color(0xFFEAF3FF),
              Color(0xFFF8FBFF),
              Color(0xFFE7FFF8),
            ],
      orbPrimary: AppColorTokens.accent.withValues(alpha: 0.28),
      orbSecondary: AppColorTokens.accentTertiary.withValues(alpha: 0.24),
      orbTertiary: AppColorTokens.accentSecondary.withValues(alpha: 0.22),
      brandLabelStyle: (textTheme.labelLarge ?? const TextStyle()).copyWith(
        color: contentMuted,
        letterSpacing: 2.4,
        fontWeight: FontWeight.w700,
      ),
      subtitleStyle: (textTheme.bodyMedium ?? const TextStyle()).copyWith(
        color: contentMuted,
      ),
      glassSurfaceColor: surface.withValues(alpha: isDark ? 0.66 : 0.82),
      glassBorderColor: onSurface.withValues(alpha: 0.14),
      inlineErrorTextStyle: (textTheme.bodySmall ?? const TextStyle()).copyWith(
        color: AppColorTokens.danger,
      ),
    );

    final travelHotelTheme = AppTravelHotelTheme(
      primaryButtonColor: AppColorTokens.travelPrimaryTeal,
      primaryButtonShadowColor: AppColorTokens.travelPrimaryTeal.withValues(
        alpha: isDark ? 0.22 : 0.15,
      ),
      primaryButtonTextStyle: (textTheme.titleMedium ?? const TextStyle())
          .copyWith(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            height: 22 / 16,
          ),
      categorySelectedBackgroundColor: AppColorTokens.travelPrimaryBlueAlt,
      categorySelectedForegroundColor: Colors.white,
      categorySelectedLabelStyle: (textTheme.bodySmall ?? const TextStyle())
          .copyWith(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            height: 16.5 / 12,
          ),
      categoryIdleBackgroundColor: isDark
          ? const Color(0xFF161E2D)
          : Colors.white,
      categoryIdleBorderColor: isDark
          ? outline.withValues(alpha: 0.9)
          : AppColorTokens.travelBorderSoft,
      categoryIdleIconColor: isDark
          ? AppColorTokens.darkMuted
          : AppColorTokens.travelTextMuted,
      categoryIdleLabelStyle: (textTheme.bodySmall ?? const TextStyle())
          .copyWith(
            color: isDark
                ? AppColorTokens.darkMuted
                : AppColorTokens.travelTextSubtle,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            height: 16.5 / 12,
          ),
      categoryShadowColor: AppColorTokens.travelShadowBlue.withValues(
        alpha: isDark ? 0.18 : 0.5,
      ),
      floatingIconBackgroundColor: isDark
          ? const Color(0xFF17202E)
          : Colors.white,
      floatingIconForegroundColor: isDark
          ? AppColorTokens.darkOnSurface
          : AppColorTokens.travelIconNavy,
      floatingIconShadowColor: Colors.black.withValues(
        alpha: isDark ? 0.24 : 0.10,
      ),
      cardBorderColor: isDark
          ? outline.withValues(alpha: 0.85)
          : AppColorTokens.travelBorderSoft,
      cardTileShadowColor: Colors.black.withValues(alpha: isDark ? 0.22 : 0.10),
      amenityHighlightedShadowColor: Colors.black.withValues(
        alpha: isDark ? 0.26 : 0.10,
      ),
      sectionTitleStyle: (textTheme.headlineSmall ?? const TextStyle())
          .copyWith(
            fontSize: 23,
            fontWeight: FontWeight.w700,
            height: 22 / 23,
            color: isDark ? AppColorTokens.darkOnSurface : Colors.black,
          ),
      sectionActionColor: isDark
          ? const Color(0xFFF3BA55)
          : AppColorTokens.travelLinkGold,
      mediaCardTitleStyle: (textTheme.titleMedium ?? const TextStyle())
          .copyWith(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            height: 15.28 / 16,
          ),
      mediaCardSubtitleStyle: (textTheme.bodySmall ?? const TextStyle())
          .copyWith(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            height: 11.46 / 12,
          ),
      mediaCardPriceStyle: (textTheme.bodySmall ?? const TextStyle()).copyWith(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 11.46 / 12,
      ),
      mediaCardRatingStyle: (textTheme.labelMedium ?? const TextStyle())
          .copyWith(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w400,
            height: 9.55 / 10,
          ),
      mediaCardOverlayGradientColors: <Color>[
        Colors.transparent,
        AppColorTokens.travelOverlayCool.withValues(
          alpha: isDark ? 0.82 : 0.62,
        ),
        Colors.black.withValues(alpha: isDark ? 0.98 : 0.94),
      ],
      dealCardOverlayGradientColors: <Color>[
        AppColorTokens.travelOverlayCharcoal.withValues(
          alpha: isDark ? 0.86 : 0.78,
        ),
        AppColorTokens.travelOverlayCool.withValues(
          alpha: isDark ? 0.70 : 0.59,
        ),
        AppColorTokens.travelOverlayBlackSoft.withValues(
          alpha: isDark ? 0.88 : 0.47,
        ),
        Colors.black.withValues(alpha: isDark ? 1 : 0.96),
      ],
      discountChipBackgroundColor: AppColorTokens.travelDiscountCoral,
      discountChipTextStyle: (textTheme.labelMedium ?? const TextStyle())
          .copyWith(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w500,
            height: 9.55 / 10,
          ),
      photoCountChipBackgroundColor: isDark
          ? const Color(0x99404A56)
          : const Color(0x801D1A19),
      photoCountChipTextStyle: (textTheme.labelMedium ?? const TextStyle())
          .copyWith(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w500,
            height: 9.55 / 10,
          ),
      ratingAccentColor: AppColorTokens.travelRatingOrange,
      hostActionButtonBackgroundColor: AppColorTokens.travelFabOrange,
      hostActionButtonShadowColor: AppColorTokens.travelShadowOrange.withValues(
        alpha: isDark ? 0.55 : 1,
      ),
      iconNavyColor: isDark
          ? AppColorTokens.darkOnSurface
          : AppColorTokens.travelIconNavy,
      tileCornerRadius: 19,
      cardCornerRadius: 17,
      chipCornerRadius: 87,
    );

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: AppColorTokens.fundingPrimary,
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
      extensions: <ThemeExtension<dynamic>>[authVisualTheme, travelHotelTheme],
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
