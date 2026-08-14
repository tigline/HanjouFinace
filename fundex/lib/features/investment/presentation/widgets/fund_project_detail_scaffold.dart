import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

class FundProjectDetailScaffold extends StatelessWidget {
  const FundProjectDetailScaffold({
    super.key,
    required this.body,
    this.actionBar,
    this.onBack,
  });

  final Widget body;
  final Widget? actionBar;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.background,
      body: onBack == null
          ? body
          : Stack(
              children: <Widget>[
                Positioned.fill(child: body),
                Positioned(
                  top: 0,
                  left: 0,
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.all(UiTokens.spacing12),
                      child: AppNavigationIconButton(
                        icon: Icons.arrow_back_rounded,
                        onTap: onBack!,
                        backgroundColor: context.appColors.surface.withValues(
                          alpha: 0.92,
                        ),
                        foregroundColor: context.appColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: actionBar,
    );
  }
}
