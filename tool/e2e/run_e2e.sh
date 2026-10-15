#!/usr/bin/env bash
# Runs the beta test protocol (LT-TP-100) automatically on an iOS simulator
# and an Android emulator at the same time.
#
#   tool/e2e/run_e2e.sh                 # build, prepare devices, run everything
#   tool/e2e/run_e2e.sh --no-build      # reuse the last builds
#   tool/e2e/run_e2e.sh --ios | --android
#   tool/e2e/run_e2e.sh --flow 02_add_memory   # one flow only
#
# Two kinds of tests run on each device:
#   - Maestro flows (.maestro/flows): the real app, tapped like a person,
#     including system dialogs, the photo picker, the contact picker and
#     Save to Photos.
#   - Flutter integration tests (integration_test/): Premium purchase and
#     family walls, which need a stand-in store and family server because a
#     simulator has neither a store account nor Google/Apple sign-in.
#
# Results: build/e2e/<timestamp>/ (report.md, JUnit XML, screenshots, logs).
set -uo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT"
export PATH="$PATH:$HOME/.maestro/bin:$HOME/Library/Android/sdk/platform-tools:$HOME/Library/Android/sdk/emulator"
SDK="$HOME/Library/Android/sdk"
ADB="$SDK/platform-tools/adb"

IOS_NAME="LifeThreads E2E iPhone"
IOS_TYPE="com.apple.CoreSimulator.SimDeviceType.iPhone-16-Pro"
IOS_RUNTIME="com.apple.CoreSimulator.SimRuntime.iOS-18-5"
IOS_APP_ID="dev.gkcoding.lifeThreads"
AVD="LifeThreads_E2E_API34"
AVD_IMAGE="system-images;android-34;google_apis;arm64-v8a"
ANDROID_APP_ID="dev.gkcoding.lifethreads"

BUILD=1; RUN_IOS=1; RUN_ANDROID=1; FLOW=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --no-build) BUILD=0 ;;
    --ios) RUN_ANDROID=0 ;;
    --android) RUN_IOS=0 ;;
    --flow) FLOW="$2"; shift ;;
    *) echo "Unknown option $1"; exit 2 ;;
  esac
  shift
done

STAMP="$(date +%Y-%m-%d_%H%M%S)"
OUT="$ROOT/build/e2e/$STAMP"
PHOTOS="$OUT/photos"
mkdir -p "$OUT"
log() { printf '\033[1;33m[e2e]\033[0m %s\n' "$*"; }

# ---------------------------------------------------------------- devices

ios_udid() {
  xcrun simctl list devices -j | python3 -c '
import json, sys
name = sys.argv[1]
for runtime, devices in json.load(sys.stdin)["devices"].items():
    for d in devices:
        if d["name"] == name and d.get("isAvailable", True):
            print(d["udid"]); raise SystemExit
' "$IOS_NAME"
}

prepare_ios() {
  local udid; udid="$(ios_udid)"
  if [[ -z "$udid" ]]; then
    log "Creating simulator $IOS_NAME"
    udid="$(xcrun simctl create "$IOS_NAME" "$IOS_TYPE" "$IOS_RUNTIME")"
  fi
  # A clean device every run: no photos or app data from earlier runs.
  xcrun simctl shutdown "$udid" >/dev/null 2>&1 || true
  xcrun simctl erase "$udid"
  xcrun simctl boot "$udid"
  xcrun simctl bootstatus "$udid" -b >/dev/null
  xcrun simctl spawn "$udid" defaults write -g AppleLanguages -array en
  xcrun simctl spawn "$udid" defaults write -g AppleLocale en_US
  xcrun simctl addmedia "$udid" "$PHOTOS"/*.jpg
  IOS_UDID="$udid"
}

android_serial() {
  "$ADB" devices | awk '/^emulator-/{print $1; exit}'
}

prepare_android() {
  if ! "$SDK/emulator/emulator" -list-avds | grep -qx "$AVD"; then
    log "Creating emulator $AVD"
    echo no | "$SDK/cmdline-tools/latest/bin/avdmanager" create avd -n "$AVD" -k "$AVD_IMAGE" -d pixel_7 >/dev/null
  fi
  if [[ -z "$(android_serial)" ]]; then
    log "Starting emulator $AVD"
    nohup "$SDK/emulator/emulator" -avd "$AVD" -no-audio -no-boot-anim -no-snapshot-save \
      -wipe-data -gpu host -memory 4096 -cores 4 >"$OUT/emulator.log" 2>&1 &
  fi
  "$ADB" wait-for-device
  until [[ "$("$ADB" shell getprop sys.boot_completed 2>/dev/null | tr -d '\r')" == "1" ]]; do sleep 2; done
  ANDROID_SERIAL="$(android_serial)"
  "$ADB" -s "$ANDROID_SERIAL" shell settings put global window_animation_scale 0
  "$ADB" -s "$ANDROID_SERIAL" shell settings put global transition_animation_scale 0
  "$ADB" -s "$ANDROID_SERIAL" shell settings put global animator_duration_scale 0
  "$ADB" -s "$ANDROID_SERIAL" shell rm -rf /sdcard/Pictures/LifeThreadsE2E
  "$ADB" -s "$ANDROID_SERIAL" shell mkdir -p /sdcard/Pictures/LifeThreadsE2E
  for f in "$PHOTOS"/*.jpg; do
    "$ADB" -s "$ANDROID_SERIAL" push "$f" /sdcard/Pictures/LifeThreadsE2E/ >/dev/null
    "$ADB" -s "$ANDROID_SERIAL" shell am broadcast -a android.intent.action.MEDIA_SCANNER_SCAN_FILE \
      -d "file:///sdcard/Pictures/LifeThreadsE2E/$(basename "$f")" >/dev/null
  done
  # A contact for "add a person from contacts" (iOS simulators ship with some).
  if ! "$ADB" -s "$ANDROID_SERIAL" shell content query --uri content://com.android.contacts/contacts \
      --projection display_name 2>/dev/null | grep -q "Kate Bell"; then
    "$ADB" -s "$ANDROID_SERIAL" shell content insert --uri content://com.android.contacts/raw_contacts \
      --bind account_type:n: --bind account_name:n: >/dev/null
    local raw
    raw="$("$ADB" -s "$ANDROID_SERIAL" shell content query --uri content://com.android.contacts/raw_contacts \
      --projection _id | tail -1 | sed -E 's/.*_id=([0-9]+).*/\1/')"
    "$ADB" -s "$ANDROID_SERIAL" shell content insert --uri content://com.android.contacts/data \
      --bind raw_contact_id:i:"$raw" --bind mimetype:s:vnd.android.cursor.item/name \
      --bind data1:s:"Kate Bell" >/dev/null
    "$ADB" -s "$ANDROID_SERIAL" shell content insert --uri content://com.android.contacts/data \
      --bind raw_contact_id:i:"$raw" --bind mimetype:s:vnd.android.cursor.item/phone_v2 \
      --bind data1:s:"(555) 564-8583" --bind data2:i:2 >/dev/null
  fi
}

# ------------------------------------------------------------------ build

build_ios() {
  log "Building iOS (simulator, debug)"
  flutter build ios --simulator --debug >"$OUT/build-ios.log" 2>&1 || { log "iOS build failed, see $OUT/build-ios.log"; return 1; }
}

build_android() {
  log "Building Android (debug APK)"
  flutter build apk --debug >"$OUT/build-android.log" 2>&1 || { log "Android build failed, see $OUT/build-android.log"; return 1; }
}

# ------------------------------------------------------------------- runs

# Dates as the photo picker labels them ("Photo from Oct 15, 2025").
eval "$(python3 - <<'PY'
import datetime
today = datetime.date.today()
try:
    ago = today.replace(year=today.year - 1)
except ValueError:
    ago = today.replace(year=today.year - 1, day=28)
fmt = lambda d: d.strftime("%b ") + str(d.day) + d.strftime(", %Y")
print(f'PHOTO_YEAR_AGO="{fmt(ago)}"')
print(f'PHOTO_SUMMIT="{fmt(datetime.date(ago.year, 7, 20))}"')
print(f'PHOTO_GARDEN="{fmt(datetime.date(ago.year, 5, 18))}"')
print(f'LAST_YEAR="{ago.year}"')
PY
)"

maestro_env=(
  -e "PHOTO_YEAR_AGO=$PHOTO_YEAR_AGO" -e "PHOTO_SUMMIT=$PHOTO_SUMMIT"
  -e "PHOTO_GARDEN=$PHOTO_GARDEN" -e "PHOTO_SALZBURG=Jun 12, 2021"
  -e "PHOTO_LINZ=Sep 3, 2022" -e "PHOTO_GRAZ=Dec 23, 2023" -e "LAST_YEAR=$LAST_YEAR"
)

run_platform() {
  local platform="$1" device="$2" app_id="$3"
  local dir="$OUT/$platform"
  mkdir -p "$dir"
  local target=".maestro/flows"
  [[ -n "$FLOW" ]] && target=".maestro/flows/$FLOW.yaml"
  log "$platform: Maestro flows on $device"
  maestro --device "$device" test "$target" \
    -e "APP_ID=$app_id" -e "PLATFORM=$platform" "${maestro_env[@]}" \
    --format junit --output "$dir/maestro-junit.xml" \
    --test-output-dir "$dir/maestro" >"$dir/maestro.log" 2>&1
  echo $? >"$dir/maestro.exit"
  if [[ -z "$FLOW" ]]; then
    log "$platform: Flutter integration tests (Premium purchase, family walls)"
    flutter test integration_test/app_e2e_test.dart -d "$device" \
      --reporter expanded >"$dir/flutter.log" 2>&1
    echo $? >"$dir/flutter.exit"
  fi
  log "$platform: done"
}

# ------------------------------------------------------------------- main

log "Output: $OUT"
python3 tool/e2e/make_photos.py "$PHOTOS" >/dev/null

pids=()
if (( RUN_IOS )); then
  ( prepare_ios
    if (( BUILD )); then build_ios || exit 1; fi
    xcrun simctl install "$IOS_UDID" build/ios/iphonesimulator/Runner.app
    xcrun simctl privacy "$IOS_UDID" grant photos "$IOS_APP_ID"
    xcrun simctl privacy "$IOS_UDID" grant photos-add "$IOS_APP_ID"
    xcrun simctl privacy "$IOS_UDID" grant contacts "$IOS_APP_ID"
    run_platform iOS "$IOS_UDID" "$IOS_APP_ID"
  ) &
  pids+=($!)
fi
if (( RUN_ANDROID )); then
  ( prepare_android
    if (( BUILD )); then build_android || exit 1; fi
    "$ADB" -s "$ANDROID_SERIAL" install -r -g build/app/outputs/flutter-apk/app-debug.apk >/dev/null
    run_platform Android "$ANDROID_SERIAL" "$ANDROID_APP_ID"
  ) &
  pids+=($!)
fi
for pid in "${pids[@]}"; do wait "$pid"; done

python3 tool/e2e/report.py "$OUT"
log "Report: $OUT/report.md"
