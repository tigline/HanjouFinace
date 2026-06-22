import 'dart:async';

import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'app_network_lottie.dart';

Future<void> showGlobalLottiePlayback(
  BuildContext context, {
  required String url,
}) {
  final colors = Theme.of(context).appColors;
  return showGeneralDialog<void>(
    context: context,
    useRootNavigator: true,
    barrierDismissible: false,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: colors.scrim.withValues(alpha: 0.88),
    transitionDuration: const Duration(milliseconds: 180),
    pageBuilder: (_, __, ___) => _GlobalLottiePlayback(url: url),
    transitionBuilder: (_, Animation<double> animation, __, Widget child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}

class _GlobalLottiePlayback extends StatefulWidget {
  const _GlobalLottiePlayback({required this.url});

  final String url;

  @override
  State<_GlobalLottiePlayback> createState() => _GlobalLottiePlaybackState();
}

class _GlobalLottiePlaybackState extends State<_GlobalLottiePlayback>
    with SingleTickerProviderStateMixin {
  static const Duration _loadTimeout = Duration(seconds: 8);

  late final AnimationController _controller = AnimationController(vsync: this)
    ..addStatusListener(_handleStatus);
  late final Timer _timeout = Timer(_loadTimeout, _finish);
  bool _finished = false;

  @override
  void dispose() {
    _timeout.cancel();
    _controller
      ..removeStatusListener(_handleStatus)
      ..dispose();
    super.dispose();
  }

  void _handleStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _finish();
    }
  }

  void _handleLoaded(LottieComposition composition) {
    if (_finished) {
      return;
    }
    _controller
      ..duration = composition.duration
      ..forward(from: 0);
  }

  void _handleLoadError() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _finish());
  }

  void _finish() {
    if (!mounted || _finished) {
      return;
    }
    _finished = true;
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Center(
              child: AppNetworkLottie(
                key: const Key('global_lottie_playback'),
                url: widget.url,
                controller: _controller,
                onLoaded: _handleLoaded,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) {
                  _handleLoadError();
                  return const SizedBox.shrink();
                },
              ),
            ),
            Center(
              child: ListenableBuilder(
                listenable: _controller,
                builder: (BuildContext context, Widget? child) {
                  return _controller.duration == null ||
                          _controller.status == AnimationStatus.dismissed
                      ? const CircularProgressIndicator()
                      : const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
