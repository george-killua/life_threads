// Regression tests from the 2026-10-16 whole-codebase bug hunt:
// a stop() while play() is still loading must keep the song silent.
import 'dart:async';
import 'dart:io';

// The platform fake needs the plugin's platform interface (a transitive
// dependency of audioplayers).
// ignore: depend_on_referenced_packages
import 'package:audioplayers_platform_interface/audioplayers_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/features/stories/data/music_catalog.dart';
import 'package:life_threads/features/stories/data/music_preview.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class _FakePaths extends PathProviderPlatform with MockPlatformInterfaceMixin {
  _FakePaths(this.root);
  final String root;
  @override
  Future<String?> getTemporaryPath() async => root;
}

class _FakeGlobal implements GlobalAudioplayersPlatformInterface {
  @override
  Stream<GlobalAudioEvent> getGlobalEventStream() => const Stream.empty();
  @override
  dynamic noSuchMethod(Invocation invocation) => Future<void>.value();
}

/// Records platform calls; setSourceUrl waits on [sourceGate] (a slow
/// decode / file copy on a real phone) before reporting "prepared".
class _FakeAudio implements AudioplayersPlatformInterface {
  final calls = <String>[];
  final events = <String, StreamController<AudioEvent>>{};
  final sourceGate = Completer<void>();

  @override
  Stream<AudioEvent> getEventStream(String playerId) =>
      (events[playerId] ??= StreamController<AudioEvent>.broadcast()).stream;

  @override
  Future<void> setSourceUrl(
    String playerId,
    String url, {
    bool? isLocal,
    String? mimeType,
  }) async {
    calls.add('setSource');
    await sourceGate.future;
    events[playerId]!.add(
      const AudioEvent(eventType: AudioEventType.prepared, isPrepared: true),
    );
  }

  @override
  Future<int?> getCurrentPosition(String playerId) async => 0;

  @override
  dynamic noSuchMethod(Invocation invocation) {
    calls.add(invocation.memberName.toString().split('"')[1]);
    return Future<void>.value();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('stop() during a pending play() leaves the song stopped', () async {
    final dir = Directory.systemTemp.createTempSync('s1_audio_');
    PathProviderPlatform.instance = _FakePaths(dir.path);
    GlobalAudioplayersPlatformInterface.instance = _FakeGlobal();
    final platform = _FakeAudio();
    AudioplayersPlatformInterface.instance = platform;

    final preview = AudioplayersMusicPreview();
    final track = bundledMusicTracks.first;
    // User taps a song...
    final playing = preview.play(track, length: const Duration(seconds: 15));
    // ...and leaves Create Story before the source is prepared.
    while (!platform.calls.contains('setSource')) {
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
    await preview.stop(); // CreateStoryPage.dispose
    final afterStop = platform.calls.length;
    platform.sourceGate.complete();
    await playing;

    final later = platform.calls.sublist(afterStop);
    expect(
      later,
      isNot(contains('resume')),
      reason: 'calls after stop(): $later',
    );
  });
}
