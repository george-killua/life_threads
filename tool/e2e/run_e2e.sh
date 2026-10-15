#!/usr/bin/env bash
# Runs the beta test protocol (LT-TP-100) automatically on an iOS simulator
# and an Android emulator at the same time.
#
#   tool/e2e/run_e2e.sh                 # iOS simulator: build, prepare, run all
#   tool/e2e/run_e2e.sh --no-build      # reuse the last build
#   tool/e2e/run_e2e.sh --android       # Android emulator only
#   tool/e2e/run_e2e.sh --both          # iOS and Android in parallel
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

BUILD=1; RUN_IOS=1; RUN_ANDROID=0; FLOW=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --no-build) BUILD=0 ;;
    --ios) RUN_IOS=1; RUN_ANDROID=0 ;;
    --android) RUN_IOS=0; RUN_ANDROID=1 ;;
    --both) RUN_IOS=1; RUN_ANDROID=1 ;;
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
  "$ADB" devices | awk '/^emulator-.*\tdevice$/{print $1; exit}'
}

prepare_android() {
  if ! "$SDK/emulator/emulator" -list-avds | grep -qx "$AVD"; then
    log "Creating emulator $AVD"
    echo no | "$SDK/cmdline-tools/latest/bin/avdmanager" create avd -n "$AVD" -k "$AVD_IMAGE" -d pixel_7 >/dev/null
  fi
  # An emulator that shows up as "offline" is restarted.
  if "$ADB" devices | grep -q "emulator-.*offline"; then
    log "Emulator offline, restarting it"
    "$ADB" emu kill >/dev/null 2>&1 || true
    sleep 5
  fi
  if [[ -z "$(android_serial)" ]]; then
    log "Starting emulator $AVD"
    # Leftovers of an emulator that was killed make the next one wait on a
    # crash-report dialog or refuse to start.
    rm -f /tmp/android-"$USER"/emu-crash-*.db
    find "$HOME/.android/avd/$AVD.avd" -name "*.lock" -delete 2>/dev/null || true
    nohup "$SDK/emulator/emulator" -avd "$AVD" -no-audio -no-boot-anim -no-snapshot-save \
      -wipe-data -gpu host -memory 4096 -cores 4 >"$OUT/emulator.log" 2>&1 </dev/null &
    disown
  fi
  "$ADB" wait-for-device
  until [[ "$("$ADB" shell getprop sys.boot_completed 2>/dev/null | tr -d '\r')" == "1" ]]; do sleep 2; done
  ANDROID_SERIAL="$(android_serial)"
  "$ADB" -s "$ANDROID_SERIAL" shell settings put global window_animation_scale 0
  "$ADB" -s "$ANDROID_SERIAL" shell settings put global transition_animation_scale 0
  "$ADB" -s "$ANDROID_SERIAL" shell settings put global animator_duration_scale 0
  # Overwrite instead of deleting the folder: right after a delete, Android's
  # media storage can refuse new files for a moment.
  "$ADB" -s "$ANDROID_SERIAL" shell mkdir -p /sdcard/Pictures/LifeThreadsE2E
  sleep 1
  for f in "$PHOTOS"/*.jpg; do
    "$ADB" -s "$ANDROID_SERIAL" push "$f" /sdcard/Pictures/LifeThreadsE2E/ >/dev/null \
      || { sleep 2; "$ADB" -s "$ANDROID_SERIAL" push "$f" /sdcard/Pictures/LifeThreadsE2E/ >/dev/null; }
    "$ADB" -s "$ANDROID_SERIAL" shell am broadcast -a android.intent.action.MEDIA_SCANNER_SCAN_FILE \
      -d "file:///sdcard/Pictures/LifeThreadsE2E/$(basename "$f")" >/dev/null
  done
  # An encrypted backup made on an iPhone, restored in the backup flow.
  "$ADB" -s "$ANDROID_SERIAL" push "$ROOT/tool/e2e/fixtures/lifethreads_e2e_backup.zip" /sdcard/Download/ >/dev/null
  "$ADB" -s "$ANDROID_SERIAL" shell am broadcast -a android.intent.action.MEDIA_SCANNER_SCAN_FILE \
    -d file:///sdcard/Download/lifethreads_e2e_backup.zip >/dev/null
  # A contact for "add a person from contacts" (iOS simulators ship with
  # some). The contacts are wiped first so every run has the same one.
  "$ADB" -s "$ANDROID_SERIAL" shell pm clear com.android.providers.contacts >/dev/null
  "$ADB" -s "$ANDROID_SERIAL" shell content insert --uri content://com.android.contacts/raw_contacts \
    --bind account_type:n: --bind account_name:n: >/dev/null
  "$ADB" -s "$ANDROID_SERIAL" shell content insert --uri content://com.android.contacts/data \
    --bind raw_contact_id:i:1 --bind mimetype:s:vnd.android.cursor.item/name \
    --bind "data1:s:'Kate Bell'" --bind "data2:s:Kate" --bind "data3:s:Bell" >/dev/null
  "$ADB" -s "$ANDROID_SERIAL" shell content insert --uri content://com.android.contacts/data \
    --bind raw_contact_id:i:1 --bind mimetype:s:vnd.android.cursor.item/phone_v2 \
    --bind "data1:s:'(555) 564-8583'" --bind data2:i:2 >/dev/null
}

# ------------------------------------------------------------------ build

# The app builds are copied to build/e2e/app: `flutter test` later builds its
# own test version of the app into the same output folders.
APPS="$ROOT/build/e2e/app"

build_ios() {
  log "Building iOS (simulator, debug)"
  flutter build ios --simulator --debug >"$OUT/build-ios.log" 2>&1 || { log "iOS build failed, see $OUT/build-ios.log"; return 1; }
  mkdir -p "$APPS" && rm -rf "$APPS/Runner.app" && cp -R build/ios/iphonesimulator/Runner.app "$APPS/"
}

build_android() {
  log "Building Android (debug APK)"
  flutter build apk --debug >"$OUT/build-android.log" 2>&1 || { log "Android build failed, see $OUT/build-android.log"; return 1; }
  mkdir -p "$APPS" && cp build/app/outputs/flutter-apk/app-debug.apk "$APPS/lifethreads-debug.apk"
}

# ------------------------------------------------------------------- runs

# Dates as the photo picker labels them ("Photo from Oct 15, 2025").
eval "$(python3 tool/e2e/dates.py)"

maestro_env=(
  -e "PHOTO_YEAR_AGO=$PHOTO_YEAR_AGO" -e "PHOTO_SUMMIT=$PHOTO_SUMMIT"
  -e "PHOTO_GARDEN=$PHOTO_GARDEN" -e "LAST_YEAR=$LAST_YEAR"
)

flutter_tests() {
  local platform="$1" device="$2"
  mkdir -p "$OUT/$platform"
  log "$platform: Flutter integration tests (Premium purchase, family walls)"
  flutter test integration_test/app_e2e_test.dart -d "$device" \
    --reporter expanded >"$OUT/$platform/flutter.log" 2>&1
  echo $? >"$OUT/$platform/flutter.exit"
}

# ------------------------------------------------------------------- main

log "Output: $OUT"
python3 tool/e2e/make_photos.py "$PHOTOS" >/dev/null

# 1. Prepare and build both platforms at the same time.
pids=()
if (( RUN_IOS )); then
  ( prepare_ios
    if (( BUILD )); then build_ios || exit 1; fi
    xcrun simctl install "$IOS_UDID" "$APPS/Runner.app"
    for service in photos photos-add contacts; do
      xcrun simctl privacy "$IOS_UDID" grant "$service" "$IOS_APP_ID"
    done
    echo "$IOS_UDID" >"$OUT/.ios_device"
  ) &
  pids+=($!)
fi
if (( RUN_ANDROID )); then
  ( prepare_android
    if (( BUILD )); then build_android || exit 1; fi
    "$ADB" -s "$ANDROID_SERIAL" install -r -g "$APPS/lifethreads-debug.apk" >/dev/null
    echo "$ANDROID_SERIAL" >"$OUT/.android_device"
  ) &
  pids+=($!)
fi
for pid in "${pids[@]}"; do wait "$pid"; done

devices=()
[[ -f "$OUT/.ios_device" ]] && devices+=("$(cat "$OUT/.ios_device")")
[[ -f "$OUT/.android_device" ]] && devices+=("$(cat "$OUT/.android_device")")
if (( ${#devices[@]} == 0 )); then log "No device ready."; exit 1; fi
device_list="$(IFS=,; echo "${devices[*]}")"

# 2. Maestro: one process drives both devices in parallel, every flow on each.
#    (Two separate Maestro processes get in each other's way.)
target=".maestro/flows"
[[ -n "$FLOW" ]] && target=".maestro/flows/$FLOW.yaml"
log "Maestro flows on ${device_list}"
maestro test --device "$device_list" --shard-all "${#devices[@]}" "$target" \
  "${maestro_env[@]}" --format junit --output "$OUT/maestro-junit.xml" \
  --test-output-dir "$OUT/maestro" >"$OUT/maestro.log" 2>&1
echo $? >"$OUT/maestro.exit"

# 3. Flutter integration tests, both devices at the same time.
if [[ -z "$FLOW" ]]; then
  pids=()
  [[ -f "$OUT/.ios_device" ]] && { flutter_tests iOS "$(cat "$OUT/.ios_device")" & pids+=($!); }
  [[ -f "$OUT/.android_device" ]] && { flutter_tests Android "$(cat "$OUT/.android_device")" & pids+=($!); }
  for pid in "${pids[@]}"; do wait "$pid"; done
  # Two installs at the same moment can fail; such a run is retried alone.
  for platform in iOS Android; do
    if grep -q "Unable to start the app" "$OUT/$platform/flutter.log" 2>/dev/null; then
      log "$platform: retrying the Flutter tests"
      flutter_tests "$platform" "$(cat "$OUT/.$(echo "$platform" | tr '[:upper:]' '[:lower:]')_device")"
    fi
  done
fi

python3 tool/e2e/report.py "$OUT"
log "Report: $OUT/report.md"
