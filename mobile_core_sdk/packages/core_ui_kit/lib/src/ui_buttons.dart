import 'package:flutter/material.dart';

import 'app_theme_extensions.dart';
import 'ui_tokens.dart';

class PrimaryCtaButton extends StatefulWidget {
  const PrimaryCtaButton({
    super.key,
    this.label,
    this.child,
    this.onPressed,
    this.isLoading = false,
    this.height = 63,
    this.fullWidth = true,
    this.borderRadius,
    this.horizontalPadding = UiTokens.spacing16,
    this.loadingIndicatorSize = 18,
  }) : assert(label != null || child != null, 'label or child is required');

  final String? label;
  final Widget? child;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double height;
  final bool fullWidth;
  final BorderRadius? borderRadius;
  final double horizontalPadding;
  final double loadingIndicatorSize;

  @override
  State<PrimaryCtaButton> createState() => _PrimaryCtaButtonState();
}

class _PrimaryCtaButtonState extends State<PrimaryCtaButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hotelTheme = theme.extension<AppFTKTheme>()!;
    final radius =
        widget.borderRadius ?? BorderRadius.circular(UiTokens.radius20);
    final isEnabled = widget.onPressed != null && !widget.isLoading;

    final buttonChild = widget.isLoading
        ? SizedBox(
            width: widget.loadingIndicatorSize,
            height: widget.loadingIndicatorSize,
            child: const CircularProgressIndicator(
              strokeWidth: 2.2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        : (widget.child ??
              Text(widget.label!, style: hotelTheme.primaryButtonTextStyle));

    final content = SizedBox(
      height: widget.height,
      width: widget.fullWidth ? double.infinity : null,
      child: _PressScale(
        enabled: isEnabled,
        isPressed: _isPressed,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: hotelTheme.primaryButtonColor.withValues(
              alpha: (widget.onPressed != null) ? 1 : 0.42,
            ),
            borderRadius: radius,
            boxShadow: (widget.onPressed != null)
                ? <BoxShadow>[
                    BoxShadow(
                      color: hotelTheme.primaryButtonShadowColor,
                      blurRadius: 21,
                      offset: const Offset(1, 21),
                    ),
                  ]
                : const <BoxShadow>[],
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: isEnabled ? widget.onPressed : null,
              onHighlightChanged: (bool value) {
                if (_isPressed == value) {
                  return;
                }
                setState(() {
                  _isPressed = value;
                });
              },
              borderRadius: radius,
              child: Center(child: buttonChild),
            ),
          ),
        ),
      ),
    );

    if (widget.fullWidth) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
        child: content,
      );
    }
    return content;
  }
}

class CompactActionButton extends StatefulWidget {
  const CompactActionButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.width = 124,
    this.height = 52,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double width;
  final double height;

  @override
  State<CompactActionButton> createState() => _CompactActionButtonState();
}

class _CompactActionButtonState extends State<CompactActionButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hotelTheme = theme.extension<AppFTKTheme>()!;
    final baseColor = hotelTheme.primaryButtonColor;
    final isEnabled = widget.onPressed != null && !widget.isLoading;
    final radius = BorderRadius.circular(UiTokens.radius16);
    final textStyle = (theme.textTheme.labelLarge ?? const TextStyle())
        .copyWith(color: baseColor, fontWeight: FontWeight.w600);

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: _PressScale(
        enabled: isEnabled,
        isPressed: _isPressed,
        scale: 0.97,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: baseColor.withValues(alpha: isEnabled ? 0.12 : 0.06),
            borderRadius: radius,
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: isEnabled ? widget.onPressed : null,
              onHighlightChanged: (bool value) {
                if (_isPressed == value) {
                  return;
                }
                setState(() {
                  _isPressed = value;
                });
              },
              borderRadius: radius,
              child: Center(
                child: widget.isLoading
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            baseColor.withValues(alpha: 0.92),
                          ),
                        ),
                      )
                    : Text(
                        widget.label,
                        style: widget.onPressed == null
                            ? textStyle.copyWith(
                                color: baseColor.withValues(alpha: 0.45),
                              )
                            : textStyle,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    required this.icon,
    super.key,
    this.onPressed,
    this.size = 44,
    this.padding,
    this.backgroundColor,
    this.foregroundColor,
  });

  final Widget icon;
  final VoidCallback? onPressed;
  final double size;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final hotelTheme = Theme.of(context).extension<AppFTKTheme>()!;
    final radius = BorderRadius.circular(size / 2);

    return SizedBox.square(
      dimension: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor ?? hotelTheme.floatingIconBackgroundColor,
          borderRadius: radius,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: hotelTheme.floatingIconShadowColor,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onPressed,
            borderRadius: radius,
            child: Padding(
              padding: padding ?? EdgeInsets.all(size * 0.22),
              child: IconTheme(
                data: IconThemeData(
                  color:
                      foregroundColor ?? hotelTheme.floatingIconForegroundColor,
                  size: size * 0.45,
                ),
                child: Center(child: icon),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AccentSquareIconButton extends StatelessWidget {
  const AccentSquareIconButton({
    required this.icon,
    super.key,
    this.onPressed,
    this.size = 40,
  });

  final Widget icon;
  final VoidCallback? onPressed;
  final double size;

  @override
  Widget build(BuildContext context) {
    final hotelTheme = Theme.of(context).extension<AppFTKTheme>()!;
    final radius = BorderRadius.circular(9);

    return SizedBox.square(
      dimension: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: hotelTheme.hostActionButtonBackgroundColor,
          borderRadius: radius,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: hotelTheme.hostActionButtonShadowColor,
              blurRadius: 25,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onPressed,
            borderRadius: radius,
            child: IconTheme(
              data: const IconThemeData(color: Colors.white, size: 20),
              child: Center(child: icon),
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryTileButton extends StatelessWidget {
  const CategoryTileButton({
    required this.icon,
    required this.label,
    super.key,
    this.isSelected = false,
    this.onPressed,
    this.width = 77,
    this.height = 102,
  });

  final Widget icon;
  final String label;
  final bool isSelected;
  final VoidCallback? onPressed;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final hotelTheme = Theme.of(context).extension<AppFTKTheme>()!;
    final borderRadius = BorderRadius.circular(hotelTheme.tileCornerRadius);
    final foregroundColor = isSelected
        ? hotelTheme.categorySelectedForegroundColor
        : hotelTheme.categoryIdleIconColor;

    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isSelected
              ? hotelTheme.categorySelectedBackgroundColor
              : hotelTheme.categoryIdleBackgroundColor,
          borderRadius: borderRadius,
          border: isSelected
              ? null
              : Border.all(
                  color: hotelTheme.categoryIdleBorderColor,
                  width: 1.5,
                ),
          boxShadow: isSelected
              ? <BoxShadow>[
                  BoxShadow(
                    color: hotelTheme.categoryShadowColor,
                    blurRadius: 24,
                    offset: const Offset(12, 25),
                  ),
                ]
              : const <BoxShadow>[],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onPressed,
            borderRadius: borderRadius,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconTheme(
                    data: IconThemeData(color: foregroundColor, size: 28),
                    child: Center(child: icon),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: isSelected
                        ? hotelTheme.categorySelectedLabelStyle
                        : hotelTheme.categoryIdleLabelStyle,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AmenityTileCard extends StatelessWidget {
  const AmenityTileCard({
    required this.icon,
    required this.label,
    super.key,
    this.highlighted = false,
    this.onPressed,
    this.width = 70,
    this.height = 84,
  });

  final Widget icon;
  final String label;
  final bool highlighted;
  final VoidCallback? onPressed;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final hotelTheme = Theme.of(context).extension<AppFTKTheme>()!;
    final borderRadius = BorderRadius.circular(hotelTheme.tileCornerRadius);

    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: hotelTheme.categoryIdleBackgroundColor,
          borderRadius: borderRadius,
          border: Border.all(color: hotelTheme.cardBorderColor, width: 1.5),
          boxShadow: highlighted
              ? <BoxShadow>[
                  BoxShadow(
                    color: hotelTheme.amenityHighlightedShadowColor,
                    blurRadius: 31,
                    offset: const Offset(5, 10),
                  ),
                ]
              : const <BoxShadow>[],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onPressed,
            borderRadius: borderRadius,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconTheme(
                    data: IconThemeData(
                      color: hotelTheme.categoryIdleIconColor,
                      size: 22,
                    ),
                    child: Center(child: icon),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: hotelTheme.categoryIdleLabelStyle,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PillChip extends StatelessWidget {
  const PillChip({
    required this.child,
    super.key,
    this.backgroundColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    this.borderRadius,
  });

  final Widget child;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final hotelTheme = Theme.of(context).extension<AppFTKTheme>()!;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor ?? hotelTheme.photoCountChipBackgroundColor,
        borderRadius:
            borderRadius ?? BorderRadius.circular(hotelTheme.chipCornerRadius),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

class _PressScale extends StatelessWidget {
  const _PressScale({
    required this.enabled,
    required this.isPressed,
    required this.child,
    this.scale = 0.985,
  });

  final bool enabled;
  final bool isPressed;
  final Widget child;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: enabled && isPressed ? scale : 1,
      duration: const Duration(milliseconds: 110),
      curve: Curves.easeOutCubic,
      child: child,
    );
  }
}
