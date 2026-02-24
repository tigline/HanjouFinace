import 'package:flutter/material.dart';

import 'app_theme_extensions.dart';
import 'hotel_ui_buttons.dart';

class HotelImageCard extends StatelessWidget {
  const HotelImageCard({
    required this.title,
    required this.location,
    required this.priceText,
    required this.ratingText,
    super.key,
    this.background,
    this.width = 152,
    this.height = 251,
    this.overlayHeight = 90,
    this.overlayGradientColors,
  });

  final String title;
  final String location;
  final String priceText;
  final String ratingText;
  final Widget? background;
  final double width;
  final double height;
  final double overlayHeight;
  final List<Color>? overlayGradientColors;

  @override
  Widget build(BuildContext context) {
    final hotelTheme = Theme.of(context).extension<AppTravelHotelTheme>()!;
    final radius = BorderRadius.circular(hotelTheme.cardCornerRadius);

    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: radius,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            background ?? const _HotelPlaceholderArtwork(),
            Align(
              alignment: Alignment.bottomCenter,
              child: IgnorePointer(
                child: Container(
                  height: overlayHeight,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors:
                          overlayGradientColors ??
                          hotelTheme.mediaCardOverlayGradientColors,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: hotelTheme.mediaCardTitleStyle,
                            ),
                            const SizedBox(height: 3),
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 13,
                                  color: Colors.white.withValues(alpha: 0.95),
                                ),
                                const SizedBox(width: 2),
                                Expanded(
                                  child: Text(
                                    location,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: hotelTheme.mediaCardSubtitleStyle,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Text(
                              priceText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: hotelTheme.mediaCardPriceStyle,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      _HotelRatingInline(ratingText: ratingText),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HotelDealBannerCard extends StatelessWidget {
  const HotelDealBannerCard({
    required this.title,
    required this.location,
    required this.priceText,
    required this.ratingText,
    super.key,
    this.discountText,
    this.background,
    this.height = 213,
    this.overlayGradientColors,
  });

  final String title;
  final String location;
  final String priceText;
  final String ratingText;
  final String? discountText;
  final Widget? background;
  final double height;
  final List<Color>? overlayGradientColors;

  @override
  Widget build(BuildContext context) {
    final hotelTheme = Theme.of(context).extension<AppTravelHotelTheme>()!;
    final radius = BorderRadius.circular(hotelTheme.cardCornerRadius);

    return SizedBox(
      width: double.infinity,
      height: height,
      child: ClipRRect(
        borderRadius: radius,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            background ??
                const _HotelPlaceholderArtwork(
                  colors: <Color>[
                    Color(0xFF77927B),
                    Color(0xFF3D6D57),
                    Color(0xFF243D33),
                  ],
                ),
            Align(
              alignment: Alignment.bottomCenter,
              child: IgnorePointer(
                child: Container(
                  height: 72,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors:
                          overlayGradientColors ??
                          hotelTheme.dealCardOverlayGradientColors,
                    ),
                  ),
                ),
              ),
            ),
            if (discountText != null)
              Positioned(
                top: 12,
                left: 12,
                child: HotelPillChip(
                  backgroundColor: hotelTheme.discountChipBackgroundColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  child: Text(
                    discountText!,
                    style: hotelTheme.discountChipTextStyle,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 11),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: hotelTheme.mediaCardTitleStyle,
                            ),
                            const SizedBox(height: 3),
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 13,
                                  color: Colors.white.withValues(alpha: 0.95),
                                ),
                                const SizedBox(width: 2),
                                Expanded(
                                  child: Text(
                                    location,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: hotelTheme.mediaCardSubtitleStyle,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          _HotelRatingInline(ratingText: ratingText),
                          const SizedBox(height: 6),
                          Text(
                            priceText,
                            style: hotelTheme.mediaCardPriceStyle,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HotelPhotoCountBadge extends StatelessWidget {
  const HotelPhotoCountBadge({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final hotelTheme = Theme.of(context).extension<AppTravelHotelTheme>()!;
    return HotelPillChip(
      backgroundColor: hotelTheme.photoCountChipBackgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Text(label, style: hotelTheme.photoCountChipTextStyle),
    );
  }
}

class _HotelRatingInline extends StatelessWidget {
  const _HotelRatingInline({required this.ratingText});

  final String ratingText;

  @override
  Widget build(BuildContext context) {
    final hotelTheme = Theme.of(context).extension<AppTravelHotelTheme>()!;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(Icons.star_rounded, size: 12, color: hotelTheme.ratingAccentColor),
        const SizedBox(width: 2),
        Text(ratingText, style: hotelTheme.mediaCardRatingStyle),
      ],
    );
  }
}

class _HotelPlaceholderArtwork extends StatelessWidget {
  const _HotelPlaceholderArtwork({
    this.colors = const <Color>[
      Color(0xFFD2E8FF),
      Color(0xFF79C8FF),
      Color(0xFF2F82D2),
    ],
  });

  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned(
            right: -10,
            top: 18,
            child: Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.16),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: -24,
            bottom: -38,
            child: Transform.rotate(
              angle: -0.2,
              child: Container(
                width: 170,
                height: 82,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(36),
                ),
              ),
            ),
          ),
          Positioned(
            left: 16,
            top: 16,
            child: Icon(
              Icons.hotel_rounded,
              size: 24,
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
          Positioned(
            bottom: 28,
            right: 16,
            child: Icon(
              Icons.waves_rounded,
              size: 34,
              color: Colors.white.withValues(alpha: 0.88),
            ),
          ),
        ],
      ),
    );
  }
}
