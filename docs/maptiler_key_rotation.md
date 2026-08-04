# MapTiler key rotation (required before public release)

A previous MapTiler key was shared in chat. Rotate it before production traffic.

## Steps

1. Open [MapTiler Cloud](https://cloud.maptiler.com/) → Account → API keys.
2. Create a new key restricted to LifeThreads production usage.
3. Revoke/disable the old key.
4. Update GitHub Actions secret:

```bash
cd /path/to/life_threads
gh secret set MAPTILER_KEY
# paste the new key when prompted
```

5. Export locally and rebuild:

```bash
export MAPTILER_KEY='your-new-key'
export JAVA_HOME="/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home"
flutter build appbundle --release --dart-define=MAPTILER_KEY="$MAPTILER_KEY"
```

6. Or re-run closed testing CI:

```bash
gh workflow run "Play Closed Test" -f play_track=alpha -f release_status=draft
```

## Verification

- Open Map mode on a release build; tiles should load (not the unavailable panel).
- Confirm the key in MapTiler analytics receives traffic only from expected clients.
