import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:story_video_encoder/story_video_encoder.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final calls = <MethodCall>[];
  // Per-method fake responses; a function may throw a PlatformException.
  late Map<String, Object? Function(MethodCall)> handlers;

  setUp(() {
    calls.clear();
    handlers = {
      'start': (_) => 7,
      'addFrame': (_) => null,
      'finish': (_) => '/tmp/out.mp4',
      'cancel': (_) => null,
    };
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(StoryVideoEncoder.channel, (call) async {
      calls.add(call);
      return handlers[call.method]!(call);
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(StoryVideoEncoder.channel, null);
  });

  Future<StoryVideoSession> start({int width = 4, int height = 2}) =>
      StoryVideoEncoder.start(outputPath: '/tmp/out.mp4', width: width, height: height);

  Uint8List frame([int width = 4, int height = 2]) => Uint8List(width * height * 4);

  group('method channel contract', () {
    test('start sends every argument and returns a session', () async {
      final session = await StoryVideoEncoder.start(
        outputPath: '/tmp/out.mp4',
        width: 1080,
        height: 1920,
        fps: 25,
        bitRate: 6000000,
        audioPath: '/tmp/a.m4a',
        audioStart: const Duration(milliseconds: 1500),
        fadeOut: const Duration(seconds: 2),
      );
      expect(session.id, 7);
      expect(calls.single.method, 'start');
      expect(calls.single.arguments, {
        'outputPath': '/tmp/out.mp4',
        'width': 1080,
        'height': 1920,
        'fps': 25,
        'bitRate': 6000000,
        'audioPath': '/tmp/a.m4a',
        'audioStartUs': 1500000,
        'fadeOutUs': 2000000,
      });
    });

    test('start defaults: 30 fps, 8 Mbit/s, no audio', () async {
      await start();
      final args = calls.single.arguments as Map;
      expect(args['fps'], 30);
      expect(args['bitRate'], 8000000);
      expect(args['audioPath'], isNull);
      expect(args['audioStartUs'], isNull);
      expect(args['fadeOutUs'], isNull);
    });

    test('addFrame sends id, running index and the pixels', () async {
      final session = await start();
      final a = frame()..[0] = 1;
      final b = frame()..[0] = 2;
      await session.addFrame(a);
      await session.addFrame(b);
      final adds = calls.where((c) => c.method == 'addFrame').toList();
      expect(adds.map((c) => (c.arguments as Map)['index']), [0, 1]);
      expect(adds.map((c) => (c.arguments as Map)['id']), [7, 7]);
      expect(((adds[1].arguments as Map)['rgba'] as Uint8List)[0], 2);
      expect(session.frameCount, 2);
    });

    test('addFrame completes only when the platform answers (backpressure)', () async {
      final gate = <Completer<void>>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(StoryVideoEncoder.channel, (call) async {
        if (call.method == 'start') return 1;
        final c = Completer<void>();
        gate.add(c);
        await c.future;
        return null;
      });
      final session = await start();
      var done = false;
      final future = session.addFrame(frame()).then((_) => done = true);
      await Future<void>.delayed(Duration.zero);
      expect(done, isFalse);
      gate.single.complete();
      await future;
      expect(done, isTrue);
    });

    test('finish sends the frame count and returns the path', () async {
      final session = await start();
      await session.addFrame(frame());
      expect(await session.finish(), '/tmp/out.mp4');
      expect(calls.last.method, 'finish');
      expect(calls.last.arguments, {'id': 7, 'frameCount': 1});
      expect(session.state, StoryVideoSessionState.finished);
      expect(session.duration, const Duration(microseconds: 33333));
    });

    test('cancel is sent once and is a no-op afterwards', () async {
      final session = await start();
      await session.cancel();
      await session.cancel();
      expect(calls.where((c) => c.method == 'cancel'), hasLength(1));
      expect(session.state, StoryVideoSessionState.cancelled);
    });

    test('cancel during finish fails the finish future', () async {
      final gate = Completer<void>();
      handlers['finish'] = (_) => gate.future.then((_) => '/nonexistent/out.mp4');
      final session = await start();
      await session.addFrame(frame());
      final finishing = session.finish();
      await session.cancel();
      gate.complete();
      await expectLater(
        finishing,
        throwsA(isA<StoryVideoException>().having((e) => e.code, 'code', 'cancelled')),
      );
      expect(session.state, StoryVideoSessionState.cancelled);
    });

    test('cancel ignores a session the platform already dropped', () async {
      handlers['cancel'] = (_) => throw PlatformException(code: 'invalid_session');
      final session = await start();
      await session.cancel();
      expect(session.state, StoryVideoSessionState.cancelled);
    });
  });

  group('typed platform errors', () {
    final cases = <String, Matcher>{
      'unsupported_size': isA<UnsupportedVideoSizeException>(),
      'encoder_failure': isA<VideoEncoderException>(),
      'audio_failure': isA<AudioTrackException>(),
      'invalid_session': isA<EncoderSessionException>(),
      'something_new': isA<StoryVideoException>().having((e) => e.code, 'code', 'something_new'),
    };
    cases.forEach((code, matcher) {
      test('$code on start', () async {
        handlers['start'] = (_) => throw PlatformException(code: code, message: 'boom');
        await expectLater(start(), throwsA(matcher));
      });
    });

    test('a failed addFrame marks the session failed', () async {
      handlers['addFrame'] = (_) => throw PlatformException(code: 'encoder_failure');
      final session = await start();
      await expectLater(session.addFrame(frame()), throwsA(isA<VideoEncoderException>()));
      expect(session.state, StoryVideoSessionState.failed);
      expect(() => session.addFrame(frame()), throwsStateError);
      await session.cancel(); // no-op, no platform call
      expect(calls.where((c) => c.method == 'cancel'), isEmpty);
    });

    test('a failed finish surfaces AudioTrackException', () async {
      handlers['finish'] = (_) => throw PlatformException(code: 'audio_failure', message: 'bad');
      final session = await start();
      await session.addFrame(frame());
      await expectLater(
        session.finish(),
        throwsA(isA<AudioTrackException>().having((e) => e.message, 'message', 'bad')),
      );
      expect(session.state, StoryVideoSessionState.failed);
    });
  });

  group('argument validation (no platform call)', () {
    Future<void> expectRejected(Future<Object?> Function() call, Matcher matcher) async {
      await expectLater(call(), throwsA(matcher));
      expect(calls, isEmpty);
    }

    test('odd, zero and huge sizes', () async {
      await expectRejected(() => start(width: 1081), isArgumentError);
      await expectRejected(() => start(height: 1919), isArgumentError);
      await expectRejected(() => start(width: 0), isRangeError);
      await expectRejected(() => start(height: 8192), isRangeError);
    });

    test('fps and bit rate ranges', () async {
      await expectRejected(
        () => StoryVideoEncoder.start(outputPath: '/o.mp4', width: 2, height: 2, fps: 0),
        isRangeError,
      );
      await expectRejected(
        () => StoryVideoEncoder.start(outputPath: '/o.mp4', width: 2, height: 2, fps: 240),
        isRangeError,
      );
      await expectRejected(
        () => StoryVideoEncoder.start(outputPath: '/o.mp4', width: 2, height: 2, bitRate: 10),
        isRangeError,
      );
    });

    test('paths and audio options', () async {
      await expectRejected(
        () => StoryVideoEncoder.start(outputPath: '', width: 2, height: 2),
        isArgumentError,
      );
      await expectRejected(
        () => StoryVideoEncoder.start(
            outputPath: '/o.mp4', width: 2, height: 2, fadeOut: const Duration(seconds: 1)),
        isArgumentError,
      );
      await expectRejected(
        () => StoryVideoEncoder.start(
            outputPath: '/o.mp4',
            width: 2,
            height: 2,
            audioPath: '/a.m4a',
            audioStart: const Duration(seconds: -1)),
        isArgumentError,
      );
      await expectRejected(
        () => StoryVideoEncoder.start(
            outputPath: '/o.mp4', width: 2, height: 2, audioPath: '/a.m4a', fadeOut: Duration.zero),
        isArgumentError,
      );
    });

    test('frame byte length must be width * height * 4', () async {
      final session = await start();
      calls.clear();
      expect(() => session.addFrame(Uint8List(31)), throwsArgumentError);
      expect(() => session.addFrame(Uint8List(33)), throwsArgumentError);
      expect(calls, isEmpty);
      expect(session.frameCount, 0);
    });

    test('finish needs a frame; nothing works after finish', () async {
      final session = await start();
      expect(() => session.finish(), throwsStateError);
      await session.addFrame(frame());
      await session.finish();
      expect(() => session.addFrame(frame()), throwsStateError);
      expect(() => session.finish(), throwsStateError);
    });
  });
}
