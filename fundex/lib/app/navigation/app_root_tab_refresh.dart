import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/notifications/presentation/providers/notifications_providers.dart';
import '../network/app_network_connectivity_providers.dart';

Future<void> refreshRootTabSharedData(WidgetRef ref) async {
  if (shouldSkipAppNetworkRefresh(ref)) {
    return;
  }

  final isAuthenticated =
      ref.read(isAuthenticatedProvider).asData?.value ?? false;
  if (!isAuthenticated) {
    return;
  }

  await ref.read(notificationsControllerProvider.notifier).refreshNotices();
}
