# member_app_template

Flutter business template repository for membership investment + hotel booking style apps.

## Principles

- Clean Architecture in each feature: `presentation/domain/data`
- Riverpod as single state-management model
- UI and business logic both testable
- Core capabilities imported from `mobile_core_sdk`

## Suggested modules

- `feature_auth`
- `feature_hotel`
- `feature_financial`
- `feature_notice_contract`
- `feature_identity_legal`
- `feature_profile`

## Structure

```text
lib/
  app/
    app.dart
    bootstrap.dart
    router/
  features/
    auth/
      data/
      domain/
      presentation/
```

## Commands (FVM)

```bash
fvm use 3.35.1
fvm flutter pub get
fvm flutter run
fvm flutter test
```
