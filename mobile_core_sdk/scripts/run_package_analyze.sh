#!/usr/bin/env bash

set -euo pipefail

if grep -qE '^[[:space:]]*flutter:[[:space:]]*$' pubspec.yaml; then
  fvm flutter analyze
else
  fvm dart analyze .
fi
