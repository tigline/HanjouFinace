import 'dart:math' as math;

import 'package:flutter/material.dart';

enum AppNoticePosition { top, bottom }

class AppNotice {
  const AppNotice._();

  static void show(
    BuildContext context, {
    required String message,
    AppNoticePosition position = AppNoticePosition.top,
    Duration duration = const Duration(seconds: 2),
    bool clearPrevious = true,
    SnackBarAction? action,
  }) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) {
      return;
    }

    if (clearPrevious) {
      messenger.hideCurrentSnackBar();
    }

    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: action,
        behavior: SnackBarBehavior.floating,
        margin: _resolveMargin(context, position),
      ),
    );
  }

  static EdgeInsets _resolveMargin(
    BuildContext context,
    AppNoticePosition position,
  ) {
    final mediaQuery = MediaQuery.maybeOf(context);
    if (mediaQuery == null) {
      return const EdgeInsets.fromLTRB(12, 0, 12, 12);
    }

    const horizontal = 12.0;
    const snackHeight = 56.0;
    final safeTop = mediaQuery.viewPadding.top + 12;
    final safeBottom = mediaQuery.viewPadding.bottom + 12;

    if (position == AppNoticePosition.bottom) {
      return EdgeInsets.fromLTRB(horizontal, 0, horizontal, safeBottom);
    }

    final screenHeight = mediaQuery.size.height;
    final topPinnedBottom = screenHeight - safeTop - snackHeight;
    final bottom = math.max(safeBottom, topPinnedBottom);
    return EdgeInsets.fromLTRB(horizontal, 0, horizontal, bottom);
  }
}
