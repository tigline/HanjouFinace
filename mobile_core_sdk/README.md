# mobile_core_sdk

Independent Git repository for reusable Flutter core plugins.

## Package list

- `core_foundation`: result/failure/logging primitives
- `core_network`: Dio wrapper + auth/refresh interceptors
- `core_storage`: secure storage abstractions
- `core_tool_kit`: app logging toolkit (file logger + export)
- `core_ui_kit`: design token + common widgets
- `core_testkit`: testing helpers shared by app repos

## Commands (FVM)

```bash
fvm use 3.35.1
fvm dart run melos run bootstrap
fvm dart run melos run analyze
fvm dart run melos run test
```

## Release

```bash
cd mobile_core_sdk
./scripts/release.sh
```

- Release workflow doc: `docs/release_process.md`
- Workspace changelog: `CHANGELOG.md`
- Package changelog: `packages/*/CHANGELOG.md`
