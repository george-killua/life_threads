#!/usr/bin/env bash
# Records the app's ad footage on an iOS simulator (no captions, no sound):
#   tool/ad_video/record.sh            # English
#   tool/ad_video/record.sh de         # German (ar for Arabic)
# Output: build/ad_video/<lang>/
#   lifethreads_<lang>_screen.mp4   the scenes at the simulator's resolution
#   lifethreads_<lang>_9x16.mp4     1080×1920 on the app's dark background
#   scenes.txt                      where each scene starts (seconds)
set -euo pipefail
cd "$(dirname "$0")/../.."
LANG_CODE="${1:-en}"
SIM="${AD_SIM:-LifeThreads E2E iPhone}"
UDID="$(xcrun simctl list devices | grep -F "$SIM (" | grep -oE '[0-9A-F-]{36}' | head -1)"
OUT="build/ad_video/$LANG_CODE"
mkdir -p "$OUT"
xcrun simctl boot "$UDID" 2>/dev/null || true
xcrun simctl status_bar "$UDID" override --time 9:41 --batteryState charged \
  --batteryLevel 100 --cellularBars 4 --wifiBars 3 --dataNetwork wifi

RAW="$OUT/raw.mov"
rm -f "$RAW"
xcrun simctl io "$UDID" recordVideo --codec h264 --force "$RAW" &
REC=$!
sleep 1
REC_START="$(python3 -c 'import time; print(int(time.time()*1000))')"

flutter test integration_test/ad_video_test.dart -d "$UDID" \
  --dart-define=AD_LANG="$LANG_CODE" 2>&1 | tee "$OUT/run.log" | grep -E "AD_MARK|All tests|Some tests|Error" || true

kill -INT "$REC"; wait "$REC" 2>/dev/null || true
xcrun simctl status_bar "$UDID" clear

python3 - "$OUT" "$REC_START" "$LANG_CODE" <<'PY'
import re, subprocess, sys
out, rec_start, lang = sys.argv[1], int(sys.argv[2]), sys.argv[3]
marks = re.findall(r'AD_MARK (\S+) (\d+)', open(f'{out}/run.log').read())
t = {name: (int(ms) - rec_start) / 1000 for name, ms in marks}
start, end = t['AD_START'], t['AD_END']
with open(f'{out}/scenes.txt', 'w') as f:
    for name, sec in t.items():
        if name not in ('AD_START', 'AD_END'):
            f.write(f'{sec - start:6.1f}s  {name}\n')
screen = f'{out}/lifethreads_{lang}_screen.mp4'
subprocess.run(['ffmpeg', '-y', '-loglevel', 'error', '-ss', f'{start:.2f}', '-to', f'{end:.2f}',
    '-i', f'{out}/raw.mov', '-c:v', 'libx264', '-crf', '18', '-pix_fmt', 'yuv420p', '-an', screen], check=True)
subprocess.run(['ffmpeg', '-y', '-loglevel', 'error', '-i', screen, '-vf',
    'scale=-2:1920,pad=1080:1920:(ow-iw)/2:0:color=0x0A070B', '-c:v', 'libx264', '-crf', '18',
    '-pix_fmt', 'yuv420p', '-an', f'{out}/lifethreads_{lang}_9x16.mp4'], check=True)
print(open(f'{out}/scenes.txt').read())
PY
ls -la "$OUT"
