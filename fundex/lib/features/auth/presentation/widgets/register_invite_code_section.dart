import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

class RegisterInviteCodeSection extends StatelessWidget {
  const RegisterInviteCodeSection({
    super.key,
    required this.controller,
    required this.labelText,
    required this.titleText,
    required this.holderOnlyText,
    required this.hintText,
    required this.helperText,
    required this.optionalLabel,
    this.onChanged,
  });

  final TextEditingController controller;
  final String labelText;
  final String titleText;
  final String holderOnlyText;
  final String hintText;
  final String helperText;
  final String optionalLabel;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final helperColor = colors.textSecondary.withValues(alpha: 0.9);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        UiTokens.spacing12,
        UiTokens.spacing12,
        UiTokens.spacing12,
        UiTokens.spacing8,
      ),
      decoration: BoxDecoration(color: theme.colorScheme.surface),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Divider(
                  color: colors.textSecondary.withValues(alpha: 0.52),
                  thickness: 1,
                  endIndent: UiTokens.spacing12,
                ),
              ),
              const SizedBox(width: UiTokens.spacing8),
              Text(
                labelText,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.textSecondary,
                ),
              ),
              const SizedBox(width: UiTokens.spacing8),
              Expanded(
                child: Divider(
                  color: colors.textSecondary.withValues(alpha: 0.52),
                  thickness: 1,
                  indent: UiTokens.spacing12,
                ),
              ),
            ],
          ),
          const SizedBox(height: UiTokens.spacing12),
          Row(
            children: [
              Text(
                titleText,
                style: theme.appTextTheme.inputLabel.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: UiTokens.spacing4),
              Text(
                holderOnlyText,
                style: theme.appTextTheme.inputLabel.copyWith(
                  color: colors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: UiTokens.spacing8),
          InviteCodeTextField(
            inputKey: const Key('register_invite_code_input'),
            controller: controller,
            labelText: labelText,
            hintText: hintText,
            optionalLabel: optionalLabel,
            onChanged: onChanged,
          ),
          const SizedBox(height: UiTokens.spacing8),
          Text(
            helperText,
            style: theme.textTheme.bodySmall?.copyWith(
              color: helperColor,
              height: 1.35,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: UiTokens.spacing12),
        ],
      ),
    );
  }
}
