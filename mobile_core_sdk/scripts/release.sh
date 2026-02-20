#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

fvm use 3.35.1 >/dev/null
fvm dart run melos run bootstrap
fvm dart run melos run check
fvm dart run melos run version
./scripts/create_release_tags.sh

echo "release commit and tags prepared."
echo "next:"
echo "  git push origin main"
echo "  git push origin --tags"
