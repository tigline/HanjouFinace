import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/hotel_models.dart';
import '../support/hotel_map_app_picker.dart';

class HotelDetailMapSection extends StatelessWidget {
  const HotelDetailMapSection({super.key, required this.detail});

  final HotelDetail detail;

  static bool canShow(HotelDetail detail) =>
      detail.address.trim().isNotEmpty || _coordinateFor(detail) != null;

  @override
  Widget build(BuildContext context) {
    final coordinate = _coordinateFor(detail);
    final address = detail.address.trim();
    if (coordinate == null && address.isEmpty) {
      return const SizedBox.shrink();
    }

    final colors = Theme.of(context).appColors;
    final addressLabel = address.isNotEmpty
        ? address
        : context.l10n.hotelDetailAddress;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.brandWhite,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.borderSoft.withValues(alpha: 0.72)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  Icons.place_outlined,
                  color: colors.brandSecondary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        context.l10n.hotelDetailAddress,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: colors.brandPrimaryDark,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        addressLabel,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colors.textSecondary,
                          fontWeight: FontWeight.w700,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final height = width.isFinite ? width * 0.8 : 190.0;
                return FundPropertyMapPreviewCard(
                  addressLabel: addressLabel,
                  destination: coordinate,
                  height: height,
                  showAddressOverlay: false,
                  showZoomControls: true,
                  onTap: coordinate == null
                      ? null
                      : () => showHotelMapAppPicker(
                          context: context,
                          coordinate: coordinate,
                          queryLabel: addressLabel,
                        ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  static FundPropertyCoordinate? _coordinateFor(HotelDetail detail) {
    final latitude = detail.latitude;
    final longitude = detail.longitude;
    if (latitude == null || longitude == null) {
      return null;
    }
    if (latitude < -90 ||
        latitude > 90 ||
        longitude < -180 ||
        longitude > 180) {
      return null;
    }
    return FundPropertyCoordinate(latitude: latitude, longitude: longitude);
  }
}
