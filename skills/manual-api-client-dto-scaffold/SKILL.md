---
name: manual-api-client-dto-scaffold
description: Generate manual API client + DTO scaffolding from assigned Swagger APIs (company clusters) when OpenAPI generation is not reliable. Use this when user provides swagger url/tag/path/operation and wants production-ready handwritten client, DTOs, and tests.
---

# Manual API Client DTO Scaffold

Use this skill when the user asks to:

- add or update API integrations from Swagger,
- keep manual `client + DTO` implementation,
- generate reusable scaffolding in `company_api_runtime`.

Do not use this skill for UI tasks.

## Required Inputs

Collect these fields before generating code:

```yaml
cluster: oa|member|hotel
swagger_url: https://.../v2/api-docs
swagger_tag: user-rest (optional but recommended)
operations: [operationId1, operationId2] (or path+method list)
module_name: user_investment
auth_required: true|false
success_codes: ["200"] # member often ["0","200"]
pagination: data.rows | rows | none
```

If `operations` is missing, accept explicit `path + method`.

## Output Targets

Generate or update:

- `mobile_core_sdk/packages/company_api_runtime/lib/src/<module>/<module>_api_client.dart`
- `mobile_core_sdk/packages/company_api_runtime/lib/src/<module>/<module>_dtos.dart`
- `mobile_core_sdk/packages/company_api_runtime/test/<module>_api_client_test.dart`

Optional thin app adapter (only when requested):

- `fundex/lib/features/.../data/datasources/..._remote_data_source.dart`
- `fundex/lib/app/network/...provider...`

## Execution Workflow

1. Read and extract API contract

- Fetch Swagger JSON from `swagger_url`.
- Filter by `swagger_tag` and/or `operations`.
- Build a contract table:
  - `path`
  - `method`
  - `auth_required`
  - request body/query fields
  - response envelope and row/data location
  - success code policy

2. Decide cluster and envelope strategy

- Keep cluster routing via `ApiClusterRouter` + `dioForPath`.
- Use `LegacyEnvelopeCodec` for `code/msg/data` style payloads.
- Apply cluster success-code profile:
  - `oa`: usually `200`
  - `member`: usually `0` and `200`
  - `hotel`: usually `0`

3. Generate API paths and client methods

- Add `<Module>ApiPaths` constants.
- Add `<Module>ApiClient` with:
  - constructor receiving `DioForPath`,
  - `LegacyEnvelopeCodec`,
  - optional `LegacyPageProfile`,
  - request method using `authRequired(true/false)`.

4. Generate DTOs with tolerant parsing

- Prefer manual `fromJson` with coercion helpers during unstable Swagger period.
- Handle common drift:
  - `int|string` ids,
  - nullable numeric strings,
  - alias keys (e.g. typo/backward-compatible key),
  - optional nested objects/lists.

5. Generate tests

- Add at least:
  - one success parse test,
  - one envelope failure test,
  - one pagination extraction test (if paged API).

6. Validate

- Run:
  - `fvm dart format <changed files>`
  - `fvm flutter analyze` or package-scoped analyze
  - targeted tests for touched module

7. Report

- Return:
  - generated file list,
  - assumptions and unresolved Swagger ambiguities,
  - validation results.

## Code Skeleton Rules

- Reuse existing runtime primitives:
  - `LegacyEnvelopeCodec`
  - `LegacyPageProfile`
  - `authRequired`
  - `ApiClusterRouter` / `dioForPath`
- Do not duplicate envelope parsing in app feature layers.
- Keep app side as thin adapter; core API logic stays in SDK runtime.

## Failure and Fallback Rules

When Swagger is incomplete or inconsistent:

- Prefer the Swagger contract first.
- If missing fields block implementation:
  - use existing runtime patterns and best-effort tolerant parsing,
  - mark assumptions in code comments and final summary.
- Never silently invent success-code policy; state chosen policy explicitly.

## Response Format (when using this skill)

Always respond with:

1. `Contract Summary` (path/method/auth/success code)
2. `Generated Files`
3. `Assumptions`
4. `Validation`
5. `Next Step` (if any)

## References

- `MANUAL_API_CLIENT_DTO_SCAFFOLD_TEMPLATE.md`
- `ARCHITECTURE_IMPLEMENTATION.md`
- `mobile_core_sdk/packages/company_api_runtime/lib/src/envelope/legacy_envelope_codec.dart`
- `mobile_core_sdk/packages/company_api_runtime/lib/src/routing/api_cluster_router.dart`
