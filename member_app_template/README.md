# member_app_template

Flutter business template repository for membership investment + hotel booking style apps.

## Principles

- Clean Architecture in each feature: `presentation/domain/data`
- Riverpod as single state-management model
- UI and business logic both testable
- Core capabilities imported from `mobile_core_sdk`

## Logging & Error Infrastructure

- Uses `core_tool_kit` `FileAppLogger` (`logging` package based) as unified log entry.
- Logs are persisted to local files (daily rotation by date).
- Supports log export API: `ref.read(appLoggerProvider).exportLogs()`.
- Global UI error messages are shown via root `ScaffoldMessenger`.

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

## Flavor & Environment

The template provides three runtime flavors via separate entrypoints:

- `lib/main_dev.dart`
- `lib/main_staging.dart`
- `lib/main_prod.dart`

Native alignment:

- Android `productFlavors`: `dev`, `staging`, `prod`
- iOS schemes: `dev`, `staging`, `prod`

Default environment values are defined in `lib/app/config/app_environment.dart`.

Current defaults (aligned with legacy `http_conf.dart`):

- `dev/staging`
  - `API_BASE_URL=https://sit-new.gutingjun.com/api`
  - `HOTEL_API_BASE_URL=https://hotel-sit.gutingjun.com/api`
  - `OA_API_BASE_URL=https://testoa.gutingjun.com/api`
- `prod`
  - `API_BASE_URL=https://new.gutingjun.com/api`
  - `HOTEL_API_BASE_URL=https://hotel.gutingjun.com/api`
  - `OA_API_BASE_URL=https://oa.gutingjun.com/api`

SIT Swagger reference:

- `https://sit-admin.gutingjun.com/api/swagger-ui.html#/`

Auth endpoints currently aligned with legacy `http_conf.dart`:

- `mss/smsCode`
- `member/user/emailLoginCode`
- `uaa/oauth/token` (login + refresh token)

Run examples:

```bash
# dev
fvm flutter run --flavor dev -t lib/main_dev.dart

# staging
fvm flutter run --flavor staging -t lib/main_staging.dart

# prod
fvm flutter run --flavor prod -t lib/main_prod.dart
```

Override API endpoints with `--dart-define`:

```bash
fvm flutter run --flavor staging -t lib/main_staging.dart \
  --dart-define=API_BASE_URL=https://sit-new.gutingjun.com/api \
  --dart-define=HOTEL_API_BASE_URL=https://hotel-sit.gutingjun.com/api \
  --dart-define=OA_API_BASE_URL=https://testoa.gutingjun.com/api \
  --dart-define='SWAGGER_UI_URL=https://sit-admin.gutingjun.com/api/swagger-ui.html#/' \
  --dart-define=ENABLE_HTTP_LOG=true
```
