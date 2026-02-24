import 'package:flutter/material.dart';

@immutable
class AppAuthVisualTheme extends ThemeExtension<AppAuthVisualTheme> {
  const AppAuthVisualTheme({
    required this.backgroundGradientColors,
    required this.orbPrimary,
    required this.orbSecondary,
    required this.orbTertiary,
    required this.brandLabelStyle,
    required this.subtitleStyle,
    required this.glassSurfaceColor,
    required this.glassBorderColor,
    required this.inlineErrorTextStyle,
  });

  final List<Color> backgroundGradientColors;
  final Color orbPrimary;
  final Color orbSecondary;
  final Color orbTertiary;
  final TextStyle brandLabelStyle;
  final TextStyle subtitleStyle;
  final Color glassSurfaceColor;
  final Color glassBorderColor;
  final TextStyle inlineErrorTextStyle;

  @override
  AppAuthVisualTheme copyWith({
    List<Color>? backgroundGradientColors,
    Color? orbPrimary,
    Color? orbSecondary,
    Color? orbTertiary,
    TextStyle? brandLabelStyle,
    TextStyle? subtitleStyle,
    Color? glassSurfaceColor,
    Color? glassBorderColor,
    TextStyle? inlineErrorTextStyle,
  }) {
    return AppAuthVisualTheme(
      backgroundGradientColors:
          backgroundGradientColors ?? this.backgroundGradientColors,
      orbPrimary: orbPrimary ?? this.orbPrimary,
      orbSecondary: orbSecondary ?? this.orbSecondary,
      orbTertiary: orbTertiary ?? this.orbTertiary,
      brandLabelStyle: brandLabelStyle ?? this.brandLabelStyle,
      subtitleStyle: subtitleStyle ?? this.subtitleStyle,
      glassSurfaceColor: glassSurfaceColor ?? this.glassSurfaceColor,
      glassBorderColor: glassBorderColor ?? this.glassBorderColor,
      inlineErrorTextStyle: inlineErrorTextStyle ?? this.inlineErrorTextStyle,
    );
  }

  @override
  AppAuthVisualTheme lerp(
    covariant ThemeExtension<AppAuthVisualTheme>? other,
    double t,
  ) {
    if (other is! AppAuthVisualTheme) {
      return this;
    }

    Color _lerpColor(Color a, Color b) => Color.lerp(a, b, t) ?? b;

    List<Color> _lerpColorList(List<Color> a, List<Color> b) {
      final maxLength = a.length > b.length ? a.length : b.length;
      return List<Color>.generate(maxLength, (int index) {
        final aColor = index < a.length ? a[index] : a.last;
        final bColor = index < b.length ? b[index] : b.last;
        return _lerpColor(aColor, bColor);
      });
    }

    return AppAuthVisualTheme(
      backgroundGradientColors: _lerpColorList(
        backgroundGradientColors,
        other.backgroundGradientColors,
      ),
      orbPrimary: _lerpColor(orbPrimary, other.orbPrimary),
      orbSecondary: _lerpColor(orbSecondary, other.orbSecondary),
      orbTertiary: _lerpColor(orbTertiary, other.orbTertiary),
      brandLabelStyle: TextStyle.lerp(
        brandLabelStyle,
        other.brandLabelStyle,
        t,
      )!,
      subtitleStyle: TextStyle.lerp(subtitleStyle, other.subtitleStyle, t)!,
      glassSurfaceColor: _lerpColor(glassSurfaceColor, other.glassSurfaceColor),
      glassBorderColor: _lerpColor(glassBorderColor, other.glassBorderColor),
      inlineErrorTextStyle: TextStyle.lerp(
        inlineErrorTextStyle,
        other.inlineErrorTextStyle,
        t,
      )!,
    );
  }
}
