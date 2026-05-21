# LifeThreads Crash-Safe Logging Strategy

Status: active for closed beta.

## Goal

Collect enough technical context to debug beta crashes without collecting private memory content.

## What Is Logged

LifeThreads keeps a small in-memory ring buffer of safe diagnostics:

- app lifecycle events such as `app_started`
- beta feedback flow events
- uncaught error type
- stack trace hash
- UTC timestamp
- app version and package name when feedback is sent

## What Is Never Logged

The logger must not record:

- memory titles
- memory stories or descriptions
- text note content
- photo file paths
- backup file paths
- exact latitude or longitude
- location labels entered by the user
- connection reasons written by the user
- exported backup contents

## Crash Handling

`AppLogger.installCrashHandlers()` is installed at app startup.

It captures:

- `FlutterError.onError`
- `PlatformDispatcher.instance.onError`
- `runZonedGuarded` uncaught errors

Crash records store only the runtime error type and a stack hash. The actual exception message is intentionally not stored because it may contain private user content.

## Feedback Flow

The Settings beta feedback dialog lets testers write feedback manually. The app attaches safe diagnostics to the email draft.

If an email app is not available, the feedback body is copied to the clipboard so the tester can send it manually to:

```text
info@gkcoding.dev
```

## Current Limitation

Logs are in-memory only. They are useful during the current app session and are intentionally not persisted to disk during closed beta.

If persistent crash reports are added later, the privacy policy and Data Safety form must be reviewed first.
