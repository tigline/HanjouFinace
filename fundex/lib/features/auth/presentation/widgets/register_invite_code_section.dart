import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

class RegisterInviteCodeSection extends StatelessWidget {
  const RegisterInviteCodeSection({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.helperText,
    required this.optionalLabel,
    this.onChanged,
  });

  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final String helperText;
  final String optionalLabel;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final travelTheme = theme.extension<AppFTKTheme>();
    final accentColor =
        travelTheme?.primaryButtonColor ?? theme.colorScheme.primary;
    final borderColor = accentColor.withValues(alpha: 0.72);
    final helperColor = colors.textSecondary.withValues(alpha: 0.9);
    final iconBackgroundColor = accentColor.withValues(alpha: 0.12);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        UiTokens.spacing12,
        UiTokens.spacing12,
        UiTokens.spacing12,
        UiTokens.spacing8,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(UiTokens.radius12),
        border: Border.all(color: borderColor, width: 1.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            labelText,
            style: theme.appTextTheme.inputLabel.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: UiTokens.spacing8),
          TextField(
            key: const Key('register_invite_code_input'),
            controller: controller,
            onChanged: onChanged,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            textCapitalization: TextCapitalization.characters,
            style: theme.appTextTheme.inputText,
            cursorColor: accentColor,
            decoration: InputDecoration(
              isDense: true,
              hintText: hintText,
              hintStyle: theme.appTextTheme.inputText.copyWith(
                color: helperColor.withValues(alpha: 0.55),
              ),
              prefixIcon: Container(
                width: 34,
                height: 34,
                margin: const EdgeInsetsDirectional.only(
                  start: UiTokens.spacing12,
                  end: UiTokens.spacing8,
                ),
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.confirmation_number_outlined,
                  size: 18,
                  color: accentColor,
                ),
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 54,
                minHeight: 34,
              ),
              suffixIcon: Center(
                widthFactor: 1,
                child: Container(
                  margin: const EdgeInsetsDirectional.only(
                    end: UiTokens.spacing12,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: UiTokens.spacing8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    optionalLabel,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: accentColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              filled: true,
              fillColor: theme.colorScheme.surface,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: UiTokens.spacing12,
                vertical: UiTokens.spacing12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(UiTokens.radius12),
                borderSide: BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(UiTokens.radius12),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(UiTokens.radius12),
                borderSide: BorderSide(color: accentColor, width: 1.6),
              ),
            ),
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
        ],
      ),
    );
  }
}
