# Changelog

All notable changes to `core_foundation` are documented in this file.

## [Unreleased]

### Added

- Shared `IdentityAuthFlow` decision engine for real-person verification and
  sensitive-action authentication branching.
- Reusable auth flow models and enums:
  `IdentityAuthEntryPoint`, `IdentityAuthAction`,
  `IdentityAuthSnapshot`, `IdentityAuthFlowPolicy`,
  and `DeviceBiometricResult`.
- Unit tests covering security-center and sensitive-action paths.

## [0.1.0] - 2026-02-20

### Added

- Initial `Failure` and `Result` primitives.
