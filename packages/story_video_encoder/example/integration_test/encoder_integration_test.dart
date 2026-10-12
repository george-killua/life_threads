// End-to-end test of the native encoders. Run on a device or simulator:
//
//   flutter test integration_test -d <device>
//
// It prints the paths of the produced files so they can be inspected with
// ffprobe (on a simulator the paths are on the Mac's file system; on Android
// pull them with `adb exec-out run-as <pkg> cat <path> > out.mp4`).
// `flutter test` uninstalls the app afterwards; on a simulator pass
// `--dart-define=EXPORT_DIR=/some/host/dir` to keep copies of the files.

import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:story_video_encoder/story_video_encoder.dart';
import 'package:story_video_encoder_example/demo_encoder.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final tmp = Directory.systemTemp.path;
  const exportDir = String.fromEnvironment('EXPORT_DIR');

  void expectMp4(String path) {
    final bytes = File(path).readAsBytesSync();
    expect(bytes.length, greaterThan(10 * 1024));
    // ISO BMFF: bytes 4..8 are the 'ftyp' box type.
    expect(String.fromCharCodes(bytes.sublist(4, 8)), 'ftyp');
    if (exportDir.isNotEmpty) {
      Directory(exportDir).createSync(recursive: true);
      File(path).copySync('$exportDir/${path.split('/').last}');
    }
  }

  testWidgets('video only, 5 s at 1080x1920', (tester) async {
    final r = await encodeDemo(outputPath: '$tmp/it_silent.mp4');
    expectMp4(r.path);
    // ignore: avoid_print
    print('RESULT silent: $r');
  });

  testWidgets('with music, trimmed', (tester) async {
    final r = await encodeDemo(
      outputPath: '$tmp/it_music.mp4',
      audioPath: await extractTestTone(),
      audioStart: const Duration(seconds: 1),
    );
    expectMp4(r.path);
    expect(File('${r.path}.video.tmp.mp4').existsSync(), isFalse);
    // ignore: avoid_print
    print('RESULT music: $r');
  });

  testWidgets('with music and fade-out', (tester) async {
    final r = await encodeDemo(
      outputPath: '$tmp/it_fade.mp4',
      audioPath: await extractTestTone(),
      fadeOut: const Duration(seconds: 2),
    );
    expectMp4(r.path);
    // ignore: avoid_print
    print('RESULT fade: $r');
  });

  testWidgets('20 s story (600 frames) with music and fade', (tester) async {
    final r = await encodeDemo(
      outputPath: '$tmp/it_600.mp4',
      seconds: 20,
      audioPath: await extractTestTone(),
      fadeOut: const Duration(seconds: 2),
    );
    expectMp4(r.path);
    // ignore: avoid_print
    print('RESULT 600 frames: $r');
  });

  testWidgets('cancel deletes the partial output', (tester) async {
    final path = '$tmp/it_cancel.mp4';
    final session = await StoryVideoEncoder.start(outputPath: path, width: 720, height: 1280);
    for (var i = 0; i < 10; i++) {
      await session.addFrame(await renderFrame(i, 10, 720, 1280));
    }
    await session.cancel();
    expect(File(path).existsSync(), isFalse);
    expect(session.state, StoryVideoSessionState.cancelled);
  });

  testWidgets('missing audio file is an AudioTrackException', (tester) async {
    await expectLater(
      StoryVideoEncoder.start(
        outputPath: '$tmp/it_bad_audio.mp4',
        width: 720,
        height: 1280,
        audioPath: '$tmp/does_not_exist.m4a',
      ),
      throwsA(isA<AudioTrackException>()),
    );
  });

  testWidgets('audioStart beyond the end is an AudioTrackException', (tester) async {
    await expectLater(
      StoryVideoEncoder.start(
        outputPath: '$tmp/it_bad_start.mp4',
        width: 720,
        height: 1280,
        audioPath: await extractTestTone(),
        audioStart: const Duration(minutes: 5),
      ),
      throwsA(isA<AudioTrackException>()),
    );
  });

  testWidgets('a WAV source is transcoded to AAC', (tester) async {
    final wav = File('$tmp/it_tone.wav')..writeAsBytesSync(_sineWav(seconds: 3));
    final r = await encodeDemo(
      outputPath: '$tmp/it_wav.mp4',
      width: 720,
      height: 1280,
      seconds: 2,
      audioPath: wav.path,
    );
    expectMp4(r.path);
  });
}

/// 16-bit mono 44.1 kHz 440 Hz sine as a WAV file.
List<int> _sineWav({required int seconds}) {
  const rate = 44100;
  final samples = rate * seconds;
  final data = ByteData(44 + samples * 2);
  void ascii(int offset, String s) {
    for (var i = 0; i < s.length; i++) {
      data.setUint8(offset + i, s.codeUnitAt(i));
    }
  }

  ascii(0, 'RIFF');
  data.setUint32(4, 36 + samples * 2, Endian.little);
  ascii(8, 'WAVE');
  ascii(12, 'fmt ');
  data.setUint32(16, 16, Endian.little);
  data.setUint16(20, 1, Endian.little); // PCM
  data.setUint16(22, 1, Endian.little); // mono
  data.setUint32(24, rate, Endian.little);
  data.setUint32(28, rate * 2, Endian.little);
  data.setUint16(32, 2, Endian.little);
  data.setUint16(34, 16, Endian.little);
  ascii(36, 'data');
  data.setUint32(40, samples * 2, Endian.little);
  for (var i = 0; i < samples; i++) {
    final v = (math.sin(2 * math.pi * 440 * i / rate) * 12000).round();
    data.setInt16(44 + i * 2, v, Endian.little);
  }
  return data.buffer.asUint8List();
}
