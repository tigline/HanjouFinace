import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.notificationsTitle)),
      body: ListView(
        key: const Key('notifications_page_content'),
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.notifications_active_outlined),
            title: Text(l10n.notificationsLotteryTitle),
            subtitle: Text(l10n.notificationsLotterySubtitle),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.receipt_long_outlined),
            title: Text(l10n.notificationsSystemTitle),
            subtitle: Text(l10n.notificationsSystemSubtitle),
          ),
        ],
      ),
    );
  }
}
