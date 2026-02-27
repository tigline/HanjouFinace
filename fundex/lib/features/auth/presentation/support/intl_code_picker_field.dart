import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/config/phone_country_codes.dart';
import '../../../../app/localization/app_localizations_ext.dart';

class IntlCodePickerField extends StatelessWidget {
  const IntlCodePickerField({
    super.key,
    required this.selectedIntlCode,
    required this.onChanged,
  });

  final String selectedIntlCode;
  final ValueChanged<String> onChanged;

  Future<void> _showPicker(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final selected = phoneCountryCodeOptionByCode(selectedIntlCode);

    return AppBottomSheet.showAdaptive<void>(
      context: context,
      builder: (BuildContext sheetContext) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              l10n.authIntlCodePickerTitle,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: UiTokens.spacing12),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 360),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: phoneCountryCodeOptions.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: UiTokens.spacing4),
                itemBuilder: (BuildContext context, int index) {
                  final option = phoneCountryCodeOptions[index];
                  final isSelected =
                      option.intlTeleCode == selected.intlTeleCode;
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(UiTokens.radius16),
                      onTap: () {
                        Navigator.of(sheetContext).pop();
                        onChanged(option.intlTeleCode);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: UiTokens.spacing12,
                          vertical: UiTokens.spacing12,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            UiTokens.radius16,
                          ),
                          color: isSelected
                              ? theme.colorScheme.primary.withValues(
                                  alpha: 0.08,
                                )
                              : theme.colorScheme.surface,
                          border: Border.all(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.outline.withValues(
                                    alpha: 0.18,
                                  ),
                          ),
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                option.displayLabel,
                                style: theme.textTheme.bodyMedium,
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check_rounded,
                                color: theme.colorScheme.primary,
                                size: 18,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final travelTheme = theme.extension<AppTravelHotelTheme>()!;
    final selected = phoneCountryCodeOptionByCode(selectedIntlCode);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(context.l10n.authIntlCodeLabel, style: theme.textTheme.labelLarge),
        const SizedBox(height: UiTokens.spacing8),
        InkWell(
          key: const Key('intl_code_picker_field'),
          borderRadius: BorderRadius.circular(UiTokens.radius16),
          onTap: () => _showPicker(context),
          child: Ink(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(UiTokens.radius16),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.16),
              ),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: UiTokens.spacing12,
              vertical: UiTokens.spacing12,
            ),
            child: Row(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: UiTokens.spacing8,
                    vertical: UiTokens.spacing8,
                  ),
                  decoration: BoxDecoration(
                    color: travelTheme.primaryButtonColor.withValues(
                      alpha: 0.08,
                    ),
                    borderRadius: BorderRadius.circular(UiTokens.radius12),
                  ),
                  child: Text(
                    selected.dialLabel,
                    style: (theme.textTheme.labelLarge ?? const TextStyle())
                        .copyWith(
                          color: travelTheme.primaryButtonColor,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                const SizedBox(width: UiTokens.spacing8),
                Expanded(
                  child: Text(
                    selected.displayLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
