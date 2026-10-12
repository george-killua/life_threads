# story_video_encoder example

Renders 5 s of an animated 1080×1920 gradient with `dart:ui` and encodes it
three ways: video only, with the bundled test tone, and with the tone plus a
2 s fade-out. The result path, size and encode time are shown on screen.

`assets/tone.m4a` is synthesised by `tool/make_test_tone.py` (no downloaded
music).

End-to-end tests (need a device, emulator or simulator):

```sh
flutter test integration_test -d <device> \
  --dart-define=EXPORT_DIR=/host/or/sdcard/dir   # optional: keep the MP4s
```

On Android use e.g. `EXPORT_DIR=/sdcard/Download/story_encoder` and
`adb pull` the files; on the iOS simulator any Mac path works.
