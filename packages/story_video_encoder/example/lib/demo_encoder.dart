import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/painting.dart' show HSVColor;
import 'package:flutter/services.dart';
import 'package:story_video_encoder/story_video_encoder.dart';

/// Result of one demo encode.
class DemoResult {
  DemoResult(this.path, this.bytes, this.frames, this.elapsed);
  final String path;
  final int bytes;
  final int frames;
  final Duration elapsed;

  @override
  String toString() =>
      '$path\n${(bytes / 1024 / 1024).toStringAsFixed(2)} MB, $frames frames '
      'in ${elapsed.inMilliseconds} ms '
      '(${(elapsed.inMicroseconds / frames / 1000).toStringAsFixed(1)} ms/frame)';
}

/// Copies the bundled test tone (synthesised, see tool/make_test_tone.py)
/// to a real file, because the encoders need a file path.
Future<String> extractTestTone() async {
  final data = await rootBundle.load('assets/tone.m4a');
  final file = File('${Directory.systemTemp.path}/story_video_test_tone.m4a');
  await file.writeAsBytes(data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  return file.path;
}

/// Renders [seconds] of an animated gradient with `dart:ui` (exactly like
/// the app will render story frames) and encodes it.
Future<DemoResult> encodeDemo({
  required String outputPath,
  int width = 1080,
  int height = 1920,
  int fps = 30,
  double seconds = 5,
  String? audioPath,
  Duration? audioStart,
  Duration? fadeOut,
  void Function(int done, int total)? onProgress,
  bool Function()? shouldCancel,
}) async {
  final total = (seconds * fps).round();
  final stopwatch = Stopwatch()..start();
  final session = await StoryVideoEncoder.start(
    outputPath: outputPath,
    width: width,
    height: height,
    fps: fps,
    audioPath: audioPath,
    audioStart: audioStart,
    fadeOut: fadeOut,
  );
  try {
    for (var i = 0; i < total; i++) {
      if (shouldCancel?.call() ?? false) {
        await session.cancel();
        throw const StoryVideoException('cancelled', 'Cancelled by the user');
      }
      final rgba = await renderFrame(i, total, width, height);
      await session.addFrame(rgba); // completes when the encoder took it
      onProgress?.call(i + 1, total);
    }
    final path = await session.finish();
    stopwatch.stop();
    return DemoResult(path, File(path).lengthSync(), total, stopwatch.elapsed);
  } catch (_) {
    await session.cancel();
    rethrow;
  }
}

/// One frame: a rotating two-colour gradient, a moving dot, a frame counter
/// and a white bar at the top (to check the picture is not upside down).
Future<Uint8List> renderFrame(int index, int total, int width, int height) async {
  final t = index / total;
  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas(recorder);
  final size = ui.Size(width.toDouble(), height.toDouble());
  final angle = t * 2 * math.pi;
  final center = size.center(ui.Offset.zero);
  final dir = ui.Offset(math.cos(angle), math.sin(angle)) * size.longestSide / 2;
  final hue = (t * 360) % 360;
  canvas.drawRect(
    ui.Offset.zero & size,
    ui.Paint()
      ..shader = ui.Gradient.linear(center - dir, center + dir, [
        HSVColor.fromAHSV(1, hue, 0.7, 0.95).toColor(),
        HSVColor.fromAHSV(1, (hue + 140) % 360, 0.8, 0.45).toColor(),
      ]),
  );
  canvas.drawRect(
    ui.Rect.fromLTWH(0, 0, size.width, size.height * 0.04),
    ui.Paint()..color = const ui.Color(0xFFFFFFFF),
  );
  canvas.drawCircle(
    ui.Offset(size.width * (0.2 + 0.6 * t), size.height * (0.5 + 0.25 * math.sin(angle * 2))),
    size.width * 0.12,
    ui.Paint()..color = const ui.Color(0xCCFFFFFF),
  );
  final paragraph = (ui.ParagraphBuilder(ui.ParagraphStyle(fontSize: size.width * 0.08))
        ..pushStyle(ui.TextStyle(color: const ui.Color(0xFFFFFFFF)))
        ..addText('frame ${index + 1} / $total'))
      .build()
    ..layout(ui.ParagraphConstraints(width: size.width));
  canvas.drawParagraph(paragraph, ui.Offset(size.width * 0.08, size.height * 0.8));

  final image = await recorder.endRecording().toImage(width, height);
  try {
    final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    return data!.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  } finally {
    image.dispose();
  }
}
