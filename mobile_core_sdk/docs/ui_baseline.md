# UI Baseline Standard

This standard applies to all future UI implementations in template apps.

## 1) Design direction

- Visual direction: iOS-first interaction model.
- Market fit: clean, premium, international-friendly, including Japanese readability.
- Avoid dense layouts and aggressive color blocks; prefer depth, spacing, and soft contrast.

## 2) Theming

- Must provide both light and dark themes.
- Use shared tokens from `core_ui_kit` for colors, typography, spacing, and radius.
- Feature-level overrides are allowed only when business-specific and documented.

## 3) Reusable components

- Dialogs must use `AppDialogs.showAdaptiveAlert`.
- Bottom sheets must use `AppBottomSheet.showAdaptive`.
- New common controls should be added to `core_ui_kit`, not copied across apps.

## 4) Engineering constraints

- Keep UI components testable (widget tests for states and navigation).
- Keep business logic out of visual widgets.
- Reuse existing tokens and components before introducing new patterns.
