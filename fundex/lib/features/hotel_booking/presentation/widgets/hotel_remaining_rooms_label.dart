import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';

class HotelRemainingRoomsLabel extends StatelessWidget {
  const HotelRemainingRoomsLabel({
    super.key,
    required this.count,
    this.unit = HotelRemainingUnit.room,
    this.textAlign = TextAlign.start,
  });

  final int count;
  final HotelRemainingUnit unit;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final textColor = count < 5 ? colors.danger : colors.brandSecondary;
    return Text(
      _label(context),
      textAlign: textAlign,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: textColor,
        fontWeight: FontWeight.w900,
      ),
    );
  }

  String _label(BuildContext context) {
    if (count <= 0) {
      return context.l10n.hotelNoRooms;
    }
    return switch (unit) {
      HotelRemainingUnit.room => _roomLabel(context),
      HotelRemainingUnit.building => _buildingLabel(context),
    };
  }

  String _roomLabel(BuildContext context) {
    if (count < 5) {
      return context.l10n.hotelRemainingRoomsFew(count);
    }
    return context.l10n.hotelRemainingRoomsMany;
  }

  String _buildingLabel(BuildContext context) {
    if (count < 5) {
      return context.l10n.hotelRemainingBuildingsFew(count);
    }
    return context.l10n.hotelRemainingBuildingsMany;
  }
}

enum HotelRemainingUnit { room, building }

HotelRemainingUnit hotelRemainingUnitForHotelSummary({
  required String buildingType,
  required String buildingCode,
  required int? bookingType,
}) {
  if (bookingType != null && bookingType != 0) {
    return HotelRemainingUnit.building;
  }
  final normalized = '$buildingType $buildingCode'.trim().toLowerCase();
  if (normalized.isEmpty) {
    return HotelRemainingUnit.room;
  }
  if (normalized.contains('町屋') ||
      normalized.contains('町家') ||
      normalized.contains('まちや') ||
      normalized.contains('machiya') ||
      normalized.contains('棟') ||
      normalized.contains('戸建') ||
      normalized.contains('一軒家') ||
      normalized.contains('タウンハウス') ||
      normalized.contains('联排') ||
      normalized.contains('聯排') ||
      normalized.contains('聯排別墅') ||
      normalized.contains('别墅') ||
      normalized.contains('別墅') ||
      normalized.contains('townhouse') ||
      normalized.contains('town house') ||
      normalized.contains('rowhouse') ||
      normalized.contains('terrace house') ||
      normalized.contains('villa') ||
      normalized.contains('house')) {
    return HotelRemainingUnit.building;
  }
  return HotelRemainingUnit.room;
}
