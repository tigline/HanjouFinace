# Changelog

All notable changes to `core_identity_auth` are documented in this file.

## [Unreleased]

### Added

- Initial reusable identity-auth SDK structure.
- RealPerson REST API client (`/member/real/person/*`) with legacy envelope parsing.
- Flow coordinator for:
  - security-center real-person path
  - sensitive-action auth path (biometric -> liveness fallback)
- Pluggable interfaces for host-app adapters:
  - biometric authenticator
  - liveness collector
  - verification state store

