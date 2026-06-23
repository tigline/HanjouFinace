import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/social_account/presentation/providers/x_account_providers.dart';
import '../../features/social_account/presentation/support/x_oauth_callback.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../router/app_router.dart';

class AppLinkCoordinator extends ConsumerStatefulWidget {
  const AppLinkCoordinator({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<AppLinkCoordinator> createState() => _AppLinkCoordinatorState();
}

class _AppLinkCoordinatorState extends ConsumerState<AppLinkCoordinator> {
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _subscription;
  String? _lastHandledUri;

  @override
  void initState() {
    super.initState();
    unawaited(_readInitialLink());
    _subscription = _appLinks.uriLinkStream.listen(_handleUri);
  }

  Future<void> _readInitialLink() async {
    final uri = await _appLinks.getInitialLink();
    if (uri != null) {
      _handleUri(uri);
    }
  }

  void _handleUri(Uri uri) {
    final callback = XOAuthCallback.tryParse(uri);
    final uriText = uri.toString();
    if (callback == null || !mounted || _lastHandledUri == uriText) {
      return;
    }
    _lastHandledUri = uriText;
    ref.read(xOAuthCallbackProvider.notifier).state = callback;
    final isAuthenticated =
        ref.read(isAuthenticatedProvider).asData?.value == true;
    if (!isAuthenticated) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      final router = ref.read(appRouterProvider);
      if (router.routeInformationProvider.value.uri.path !=
          '/profile/settings/x-account') {
        router.push('/profile/settings/x-account');
      }
    });
  }

  @override
  void dispose() {
    unawaited(_subscription?.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
