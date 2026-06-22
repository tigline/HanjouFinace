import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AppNetworkLottie extends StatelessWidget {
  const AppNetworkLottie({
    required this.url,
    required this.controller,
    required this.onLoaded,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.errorBuilder,
    super.key,
  });

  final String url;
  final AnimationController controller;
  final ValueChanged<LottieComposition> onLoaded;
  final BoxFit fit;
  final Alignment alignment;
  final ImageErrorWidgetBuilder? errorBuilder;

  @override
  Widget build(BuildContext context) {
    return Lottie.network(
      url,
      controller: controller,
      fit: fit,
      alignment: alignment,
      repeat: false,
      onLoaded: onLoaded,
      decoder: url.toLowerCase().endsWith('.lottie')
          ? decodeAppDotLottie
          : null,
      errorBuilder: errorBuilder,
    );
  }
}

Future<LottieComposition?> decodeAppDotLottie(List<int> bytes) {
  return LottieComposition.decodeZip(
    bytes,
    filePicker: (files) {
      for (final file in files) {
        final name = file.name;
        if (name.startsWith('animations/') && name.endsWith('.json')) {
          return file;
        }
      }
      for (final file in files) {
        if (file.name.endsWith('.json')) {
          return file;
        }
      }
      return null;
    },
  );
}
