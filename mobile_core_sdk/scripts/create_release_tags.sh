#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

created=0

for pubspec in packages/*/pubspec.yaml; do
  package_name="$(basename "$(dirname "$pubspec")")"
  package_version="$(awk -F': ' '/^version:/{print $2; exit}' "$pubspec")"

  if [[ -z "$package_version" ]]; then
    echo "skip ${package_name}: version not found"
    continue
  fi

  tag="${package_name}-v${package_version}"

  if git rev-parse "$tag" >/dev/null 2>&1; then
    echo "skip ${tag}: already exists"
    continue
  fi

  git tag -a "$tag" -m "release(${package_name}): v${package_version}"
  echo "created ${tag}"
  created=$((created + 1))
done

echo "tags created: ${created}"
