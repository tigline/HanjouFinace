import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/social_account/presentation/providers/x_account_providers.dart';
import '../../features/social_account/presentation/support/x_oauth_callback.dart';

final appLinkCoordinatorProvider = Provider<AppLinkCoordinator>((ref) {
  final coordinator = AppLinkCoordinator(ref);
  ref.onDispose(coordinator.dispose);
  unawaited(coordinator.start());
  return coordinator;
});

class AppLinkCoordinator {
  AppLinkCoordinator(this._ref);

  final Ref _ref;
  final AppLinks _appLinks = AppLinks();

  StreamSubscription<Uri>? _linkSubscription;
  String? _lastHandledUri;

  Future<void> start() async {
    final initialLink = await _appLinks.getInitialLink().catchError(
      (_) => null,
    );
    if (initialLink != null) {
      _handleUri(initialLink);
    }
    _linkSubscription = _appLinks.uriLinkStream.listen(
      _handleUri,
      onError: (_) {},
    );
  }

  void dispose() {
    unawaited(_linkSubscription?.cancel());
  }

  void _handleUri(Uri uri) {
    if (!isXOAuthCallbackUri(uri)) {
      return;
    }
    final uriText = uri.toString();
    if (_lastHandledUri == uriText) {
      return;
    }
    _lastHandledUri = uriText;

    _ref.invalidate(xAccountControllerProvider);
    final signal = _ref.read(xOAuthCallbackSignalProvider.notifier);
    signal.state = signal.state + 1;
  }
}
