# story_video_encoder

Turns frames rendered by Flutter into an H.264 MP4 (e.g. a 1080×1920, 30 fps
story video), optionally with a music track that is trimmed to the video and
faded out. It uses only the platforms' own media APIs, so there is no FFmpeg
and no GPL code (see [Licensing](#licensing)).

Platforms: Android (minSdk 24) and iOS 15+.

## API

```dart
import 'package:story_video_encoder/story_video_encoder.dart';

final session = await StoryVideoEncoder.start(
  outputPath: '${tmpDir.path}/story.mp4',
  width: 1080,
  height: 1920,
  fps: 30,                      // default
  bitRate: 8000000,             // default, 8 Mbit/s
  audioPath: '${tmpDir.path}/music.m4a',   // optional
  audioStart: const Duration(seconds: 12), // optional: where the song starts
  fadeOut: const Duration(seconds: 2),     // optional: fade over the last 2 s
);
try {
  for (var i = 0; i < 600; i++) {
    final image = await renderStoryFrame(i);      // ui.Image, 1080×1920
    final bytes = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    image.dispose();
    await session.addFrame(bytes!.buffer.asUint8List()); // backpressure
  }
  final path = await session.finish();  // the finished MP4
} catch (e) {
  await session.cancel();               // deletes partial output
  rethrow;
}
```

| Member | Meaning |
| --- | --- |
| `StoryVideoEncoder.start(...)` | Validates the arguments, creates the native encoder and returns a `StoryVideoSession`. Width and height must be even (≤ 4096). |
| `session.addFrame(Uint8List rgba)` | One frame of tightly packed RGBA8888, top row first, exactly `width*height*4` bytes (alpha is ignored). Frame *i* is shown at *i / fps*, however long rendering took. The future completes when the native side has consumed the pixels, so awaiting it keeps at most one frame (~8 MB at 1080×1920) in flight. |
| `session.finish()` | Flushes the encoder, adds the audio and returns the output path. |
| `session.cancel()` | Stops and deletes all partial files. Safe to call at any time. |
| `session.state`, `frameCount`, `duration` | Progress information. |

### Errors

Wrong arguments throw `ArgumentError` / `RangeError`, misuse (e.g. `addFrame`
after `finish`) throws `StateError` — both synchronously, without a platform
call. Platform failures are typed `StoryVideoException`s:

| Exception | Code | When |
| --- | --- | --- |
| `UnsupportedVideoSizeException` | `unsupported_size` | No H.264 encoder on the device accepts the size / frame rate. Retry at 720×1280. |
| `VideoEncoderException` | `encoder_failure` | Encoder, OpenGL or muxer failure. |
| `AudioTrackException` | `audio_failure` | Audio file missing, unreadable, without audio track, or `audioStart` beyond its end. Checked in `start`, before any frame is rendered. |
| `EncoderSessionException` | `invalid_session` | The native side no longer knows the session. |

After a platform error the native side has already released everything and
deleted partial files; the session's state is `failed`.

## Formats

* **Output:** MP4, H.264 (High profile when the device offers it, otherwise
  the encoder's default — Baseline on many Android encoders), BT.709 colour
  tags, key frame every second; AAC-LC audio.
* **Audio input:** AAC in `.m4a`/`.mp4` is the intended format. Anything the
  platform can decode (MP3, WAV, ...) also works; on Android a non-AAC source
  is decoded and re-encoded to AAC.
* Audio shorter than the video simply ends early; audio longer than the
  video is cut at the video's end.

## How it works

### Android (Kotlin)

* Each session runs on its own `HandlerThread`; the platform thread only
  routes calls.
* **Video:** `MediaCodec` H.264 encoder with an **input Surface**. Each RGBA
  frame is uploaded into an OpenGL ES 2 texture (`glTexSubImage2D`) and
  drawn as a full-screen quad onto the encoder's surface through EGL; the
  frame's timestamp is set with `eglPresentationTimeANDROID(index / fps)`.
  The GPU does the RGB→YUV conversion in whatever layout the vendor
  encoder wants, which avoids the stride/colour-format differences of YUV
  input buffers across chipsets. The EGL config is RGBA8888 + recordable:
  without the alpha channel the emulator (and some drivers) produce black
  video.
* `MediaMuxer` writes the MP4. With audio, the video goes to a temporary
  file first and is remuxed at the end.
* **Audio, no fade, AAC source:** compressed AAC frames are copied with
  `MediaExtractor` into the muxer from `audioStart` (seek to the previous
  sync frame, timestamps rebased to 0) up to the last frame that ends
  within the video — no re-encoding. Video and audio samples are
  interleaved by timestamp.
* **Audio with fade (or non-AAC source):** decoded to PCM with
  `MediaCodec`, trimmed sample-accurately, multiplied by a linear gain ramp
  (1 → 0 over the last `fadeOut` of the video), re-encoded to AAC-LC into a
  temporary `.m4a`, then copied in as above.

### iOS (Swift)

* Each session has its own serial `DispatchQueue`.
* **Video:** `AVAssetWriter` + `AVAssetWriterInputPixelBufferAdaptor`
  (H.264 High, hardware). RGBA is swizzled to BGRA straight into a
  pool-allocated `CVPixelBuffer` with `vImagePermuteChannels_ARGB8888` and
  appended at `CMTime(index, fps)`; `endSession` at `frameCount / fps`
  makes the last frame last exactly 1/fps. Backpressure: the queue waits
  for `isReadyForMoreMediaData` before answering Flutter.
* **Audio:** the music is inserted into an `AVMutableComposition` from
  `audioStart` for at most the video's duration; an `AVMutableAudioMix`
  with `setVolumeRamp(1 → 0)` over the last `fadeOut` is applied by
  `AVAssetReaderAudioMixOutput`; a second `AVAssetWriter` copies the video
  samples untouched (passthrough) and encodes the audio to AAC-LC
  44.1 kHz stereo. `AVAssetExportSession` is not used: its passthrough
  preset ignores audio mixes and the other presets re-encode the video.

## Performance

Measured with the example's integration test (render with `dart:ui`,
`toByteData`, channel transfer and encode, end to end):

| Target | 150 frames (5 s) | 600 frames (20 s) |
| --- | --- | --- |
| iOS 27 simulator on Apple Silicon | 3.5–4.2 s | 13–14 s |
| Android 14 emulator (software GPU + software encoder) | 10–12 s | 42 s |

The emulator is a worst case (everything in software). On phones the
encoder runs in hardware and is not the bottleneck; the cost is mostly
rendering + reading back each 8 MB frame in Flutter (expected 15–30 ms per
frame on a mid-range phone, i.e. ~10–20 s for 600 frames). Real-device
numbers still need to be measured.

## Licensing

The plugin only calls operating-system APIs (Android `MediaCodec`,
`MediaMuxer`, `MediaExtractor`, EGL/GLES; iOS AVFoundation, Accelerate,
CoreVideo). It bundles no codec, links no FFmpeg/x264/LAME and contains no
third-party source, so it adds no GPL/LGPL obligations to the app. H.264
and AAC patent licensing for the encoders is handled by the device and OS
vendors, as for any app using the platform encoders.

The example's test tone is synthesised by `example/tool/make_test_tone.py`.

## Tests

* `flutter test` — method-channel contract (mocked platform), typed errors,
  argument validation.
* `cd example && flutter test integration_test -d <device>` — real encodes
  on a device/emulator/simulator (see `example/README.md`).
