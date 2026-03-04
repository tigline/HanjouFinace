import 'package:flutter/material.dart';

import 'member_profile_form_widgets.dart';

class MemberProfileEditStepScaffold extends StatelessWidget {
  const MemberProfileEditStepScaffold({
    super.key,
    required this.title,
    required this.description,
    required this.child,
    required this.primaryButtonLabel,
    this.onPrimaryPressed,
    this.showSkip = false,
    this.skipLabel,
    this.onSkip,
    this.primaryButtonEnabled = true,
  });

  final String title;
  final String description;
  final Widget child;
  final String primaryButtonLabel;
  final VoidCallback? onPrimaryPressed;
  final bool showSkip;
  final String? skipLabel;
  final VoidCallback? onSkip;
  final bool primaryButtonEnabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: (theme.textTheme.titleLarge ?? const TextStyle()).copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: (theme.textTheme.bodySmall ?? const TextStyle()).copyWith(
              fontSize: 12,
              color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.92),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          child,
          const SizedBox(height: 20),
          MemberProfilePrimaryButton(
            label: primaryButtonLabel,
            onPressed: primaryButtonEnabled ? onPrimaryPressed : null,
          ),
          if (showSkip) ...<Widget>[
            const SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: onSkip,
                child: Text(
                  skipLabel ?? '',
                  style: (theme.textTheme.labelLarge ?? const TextStyle())
                      .copyWith(
                        fontSize: 13,
                        color: theme.textTheme.bodySmall?.color,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
