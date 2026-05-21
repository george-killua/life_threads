#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

if [[ -z "${MAPTILER_KEY:-}" ]]; then
  echo "Missing MAPTILER_KEY" >&2
  exit 1
fi

if [[ -z "${GOOGLE_PLAY_JSON_KEY_PATH:-}" && -z "${GOOGLE_PLAY_SERVICE_ACCOUNT_JSON_BASE64:-}" ]]; then
  echo "Set GOOGLE_PLAY_JSON_KEY_PATH or GOOGLE_PLAY_SERVICE_ACCOUNT_JSON_BASE64" >&2
  exit 1
fi

if [[ ! -f android/key.properties || ! -f android/release/lifethreads-release-key.jks ]]; then
  echo "Missing Android release signing files." >&2
  echo "Expected android/key.properties and android/release/lifethreads-release-key.jks" >&2
  exit 1
fi

bundle exec fastlane android closed_test
