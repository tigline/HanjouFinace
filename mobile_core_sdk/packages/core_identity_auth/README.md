# core_identity_auth

Reusable identity-auth SDK for FUNDEX-family apps.

This package standardizes the same flow used in legacy apps:

1. Security center real-person enrollment.
2. Sensitive action guard (device biometric first, liveness fallback).
3. RealPersonRest communication (`/member/real/person/*`).

## Core components

- `IdentityAuthFlow` (from `core_foundation`): pure state-machine policy.
- `IdentityAuthCoordinator`: orchestrates flow + side effects.
- `RealPersonApiClient`: RealPersonRest HTTP client.
- Contracts to be implemented by host app:
  - `IdentityAuthStateStore`
  - `DeviceBiometricAuthenticator`
  - `LivenessCollector`

## Endpoints

Default endpoint set:

- `/member/real/person/token`
- `/member/real/person/result`
- `/member/real/person/image`
- `/member/real/person/upload`
- `/member/real/person/upload/userId`
- `/member/real/person/identify`

Supports legacy `R` envelope codes `0/200` as success.

## Basic integration

```dart
final gateway = RealPersonApiClient(client: coreHttpClient);
final coordinator = IdentityAuthCoordinator(
  apiGateway: gateway,
  stateStore: myStateStore,
  biometricAuthenticator: myBiometricAuthenticator,
  livenessCollector: myLivenessCollector,
);

final decision = await coordinator.evaluate(
  entryPoint: IdentityAuthEntryPoint.sensitiveAction,
);
```

For sensitive actions, use:

```dart
final result = await coordinator.authenticateSensitiveAction();
if (result.action == IdentityAuthAction.allowTargetAction) {
  // continue business action
}
```

For security-center flow:

1. Upload photo.
2. Collect liveness photo.
3. Call `verifyWithPhotoBase64(...)` or `completeRealPersonEnrollment(...)`.
