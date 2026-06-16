import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../app/support/app_request_error_message_resolver.dart';

class HotelInlineErrorNotice extends StatelessWidget {
  const HotelInlineErrorNotice({super.key, required this.onRetry, this.error});

  final VoidCallback onRetry;
  final Object? error;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final message = error == null
        ? context.l10n.hotelRefreshFailed
        : resolveAppRequestErrorMessage(
            error!,
            context.l10n.hotelRefreshFailed,
          );
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.dangerSoft,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: colors.dangerBorder),
        ),
        child: ListTile(
          dense: true,
          leading: Icon(Icons.error_outline_rounded, color: colors.danger),
          title: Text(message),
          trailing: TextButton(
            onPressed: onRetry,
            child: Text(context.l10n.commonRetry),
          ),
        ),
      ),
    );
  }
}

class HotelFullPageError extends StatelessWidget {
  const HotelFullPageError({super.key, required this.onRetry, this.error});

  final VoidCallback onRetry;
  final Object? error;

  @override
  Widget build(BuildContext context) {
    final message = error == null
        ? context.l10n.hotelLoadFailed
        : resolveAppRequestErrorMessage(error!, context.l10n.hotelLoadFailed);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.error_outline_rounded, size: 40),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: onRetry,
              child: Text(context.l10n.commonRetry),
            ),
          ],
        ),
      ),
    );
  }
}

class HotelEmptyList extends StatelessWidget {
  const HotelEmptyList({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          context.l10n.hotelEmptyResults,
          style: Theme.of(
            context,
          ).appTextTheme.body.copyWith(color: colors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
