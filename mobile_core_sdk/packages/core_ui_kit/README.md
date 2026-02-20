# core_ui_kit

Reusable UI foundation for template apps.

## UI Baseline (Mandatory)

- Visual language follows iOS interaction and motion principles.
- Support both light and dark mode from day one.
- Keep typography, color, and spacing/radius under shared tokens.
- Reuse shared components for dialog and bottom sheet instead of ad-hoc implementations.
- Feature pages should compose from this package first, then add business-specific skins.

## Included

- `AppThemeFactory.light()` / `AppThemeFactory.dark()`
- `AppColorTokens` / `AppTypographyTokens` / `UiTokens`
- `AppDialogs.showAdaptiveAlert(...)`
- `AppBottomSheet.showAdaptive(...)`
