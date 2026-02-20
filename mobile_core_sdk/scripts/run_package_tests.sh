#!/usr/bin/env bash

set -euo pipefail

package_name="$(basename "$PWD")"

if [[ ! -d test ]]; then
  echo "skip ${package_name}: no test directory"
  exit 0
fi

if grep -qE '^[[:space:]]*flutter:[[:space:]]*$' pubspec.yaml; then
  fvm flutter test
else
  fvm dart test
fi
