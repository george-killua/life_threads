#!/usr/bin/env bash
# Upload a locally built release AAB to Play closed testing (alpha/draft by default).
set -euo pipefail
cd "$(dirname "$0")/.."

if [[ -z "${MAPTILER_KEY:-}" || "${MAPTILER_KEY}" == "PLACEHOLDER_ROTATE_ME" ]]; then
  echo "Set a real rotated MAPTILER_KEY first (see docs/maptiler_key_rotation.md)." >&2
  exit 1
fi

if [[ -z "${GOOGLE_PLAY_JSON_KEY_PATH:-}" && -z "${GOOGLE_PLAY_SERVICE_ACCOUNT_JSON_BASE64:-}" ]]; then
  echo "Set GOOGLE_PLAY_JSON_KEY_PATH or GOOGLE_PLAY_SERVICE_ACCOUNT_JSON_BASE64" >&2
  exit 1
fi

export JAVA_HOME="${JAVA_HOME:-/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home}"
export PATH="$JAVA_HOME/bin:$PATH"
export PLAY_TRACK="${PLAY_TRACK:-alpha}"
export PLAY_RELEASE_STATUS="${PLAY_RELEASE_STATUS:-draft}"

bundle exec fastlane android closed_test
