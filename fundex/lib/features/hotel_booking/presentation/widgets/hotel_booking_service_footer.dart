import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';

class HotelBookingServiceFooter extends StatelessWidget {
  const HotelBookingServiceFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(1, 8, 1, 34),
      child: Text(
        context.l10n.hotelBookingServiceProviderFooter,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: colors.textTertiary,
          fontWeight: FontWeight.w500,
          height: 1.35,
        ),
      ),
    );
  }
}
