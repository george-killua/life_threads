#!/usr/bin/env bash
# Renders the Play Store and App Store screenshots from the real app screens.
#   tool/store_screenshots/run.sh                       # everything
#   STORE_SIZES=play-phone STORE_LANGS=de tool/store_screenshots/run.sh
# Output: store_listing_assets/store_screenshots/<size>/<lang>/NN-scene.png
set -euo pipefail
cd "$(dirname "$0")/../.."
flutter test tool/store_screenshots/store_screenshots_test.dart "$@"
