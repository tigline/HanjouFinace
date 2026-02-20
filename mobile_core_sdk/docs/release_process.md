# mobile_core_sdk Release Process

## 1. Versioning Rules

- Follow Semantic Versioning: `MAJOR.MINOR.PATCH`.
- Use Conventional Commits for release notes and automated version decisions.
- Every package keeps its own `CHANGELOG.md`.
- Workspace-level summary is maintained in `/mobile_core_sdk/CHANGELOG.md`.

## 2. Changelog Rules

For every user-visible change, update `## [Unreleased]` in the impacted package changelog:

- `Added`
- `Changed`
- `Fixed`
- `Removed`
- `Security`

Before release, ensure Unreleased entries are complete and concise.

## 3. Release Commands (FVM + Melos)

Run from `/mobile_core_sdk`:

```bash
fvm use 3.35.1
fvm dart run melos run bootstrap
fvm dart run melos run check
fvm dart run melos run version
./scripts/create_release_tags.sh
```

Then push commit and tags:

```bash
git push origin main
git push origin --tags
```

## 4. Tag Convention

- Package tags: `<package-name>-v<version>`
- Examples:
  - `core_network-v0.2.0`
  - `core_storage-v0.3.1`

## 5. Rollback

If release commit is not pushed yet:

```bash
git reset --hard HEAD~1
git tag -d <tag-name>
```

If release commit/tags are already pushed, create a follow-up patch release instead of rewriting history.
