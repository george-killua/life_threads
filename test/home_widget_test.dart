import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:life_threads/features/app_lock/app_lock.dart';
import 'package:life_threads/features/home_widget/data/home_widget_sync.dart';
import 'package:life_threads/features/home_widget/domain/home_widget_days.dart';
import 'package:life_threads/features/home_widget/presentation/home_widget_link_listener.dart';
import 'package:life_threads/features/memories/data/memory_repository.dart';
import 'package:life_threads/features/on_this_day/data/on_this_day_providers.dart';
import 'package:life_threads/l10n/generated/app_localizations_en.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/on_this_day_fakes.dart';

class _FakeBridge implements HomeWidgetBridge {
  _FakeBridge(this.path);

  final String path;
  final payloads = <Map<String, Object?>>[];

  @override
  Future<String?> containerPath() async => path;

  @override
  Future<void> update(String payload) async =>
      payloads.add(jsonDecode(payload) as Map<String, Object?>);
}

class _Lock extends AppLockController {
  _Lock({required this.enabled});

  final bool enabled;

  @override
  AppLockState build() =>
      AppLockState(ready: true, enabled: enabled, locked: false);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final l10n = AppLocalizationsEn();

  group('homeWidgetDays', () {
    test('a memory from this day first, then one to remember', () {
      final days = homeWidgetDays(DateTime(2026, 10, 16, 15), [
        memory('anniversary', DateTime(2023, 10, 16)),
        memory('other', DateTime(2025, 3, 2)),
      ], l10n);
      expect(days, hasLength(7));
      expect(days.first.date, DateTime(2026, 10, 16));
      expect(days.first.memory?.id, 'anniversary');
      expect(days.first.subtitle, '3 years ago today');
      expect(days[1].date, DateTime(2026, 10, 17));
      expect(days[1].subtitle, 'Remember this');
      expect(days[1].memory, isNotNull);
    });

    test('memories with a photo are preferred; a new one each day', () {
      final events = [
        memory('a', DateTime(2025, 1, 5)).copyWith(coverPhotoPath: '/a.jpg'),
        memory('b', DateTime(2025, 2, 5)).copyWith(coverPhotoPath: '/b.jpg'),
        memory('no-photo', DateTime(2025, 3, 5)),
      ];
      final ids = homeWidgetDays(
        DateTime(2026, 10, 16),
        events,
        l10n,
      ).map((d) => d.memory?.id).toList();
      expect(ids.toSet(), {'a', 'b'});
      for (var i = 1; i < ids.length; i++) {
        expect(ids[i], isNot(ids[i - 1]));
      }
    });

    test('an empty wall invites to save today', () {
      final day = homeWidgetDays(DateTime(2026, 10, 16), const [], l10n).first;
      expect(day.memory, isNull);
      expect(day.title, 'What happened today?');
    });
  });

  test('widget links open memories only', () {
    expect(
      HomeWidgetLinkListener.memoryIdFrom(
        Uri.parse('lifethreads://memory/abc-1'),
      ),
      'abc-1',
    );
    expect(
      HomeWidgetLinkListener.memoryIdFrom(Uri.parse('lifethreads://wall')),
      isNull,
    );
    expect(
      HomeWidgetLinkListener.memoryIdFrom(
        Uri.parse('https://gkcoding.dev/lifethreads/share/x'),
      ),
      isNull,
    );
  });

  test('thumbnails are scaled down', () {
    final big = img.encodePng(img.Image(width: 2000, height: 1000));
    final small = img.decodeJpg(homeWidgetThumbnail(big)!)!;
    expect((small.width, small.height), (720, 360));
    expect(homeWidgetThumbnail(Uint8List.fromList([1, 2, 3])), isNull);
  });

  group('HomeWidgetSync', () {
    late Directory container;
    late File photo;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      container = await Directory.systemTemp.createTemp('widget_test');
      photo = File('${container.path}/source.png')
        ..writeAsBytesSync(img.encodePng(img.Image(width: 40, height: 30)));
    });
    tearDown(() => container.delete(recursive: true));

    Future<_FakeBridge> run({required bool locked}) async {
      final bridge = _FakeBridge('${container.path}/widget');
      final c = ProviderContainer(
        overrides: [
          memoryRepositoryProvider.overrideWith(
            () => FakeMemoryRepository([
              memory(
                'today',
                DateTime(2024, 10, 16),
              ).copyWith(coverPhotoPath: photo.path),
              memory('secret', DateTime(2022, 10, 16)).copyWith(hidden: true),
            ]),
          ),
          appLockProvider.overrideWith(() => _Lock(enabled: locked)),
          homeWidgetBridgeProvider.overrideWithValue(bridge),
          onThisDayClockProvider.overrideWithValue(
            () => DateTime(2026, 10, 16, 9),
          ),
        ],
      );
      addTearDown(c.dispose);
      c.listen(homeWidgetSyncProvider, (_, _) {});
      for (var i = 0; i < 5; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 20));
        c.read(homeWidgetSyncProvider);
        await c.read(homeWidgetSyncProvider.notifier).idle();
      }
      return bridge;
    }

    test(
      'writes the week with photo copies; hidden memories stay out',
      () async {
        final bridge = await run(locked: false);
        final days = bridge.payloads.last['days']! as List;
        final today = days.first as Map;
        expect(today['date'], '2026-10-16');
        expect(today['memoryId'], 'today');
        expect(today['subtitle'], '2 years ago today');
        final image = today['image']! as String;
        expect(File('${container.path}/widget/$image').existsSync(), isTrue);
        expect(jsonEncode(days), isNot(contains('secret')));
      },
    );

    test('shows nothing personal while the app lock is on', () async {
      final bridge = await run(locked: true);
      final days = bridge.payloads.last['days']! as List;
      expect(days, hasLength(1));
      final day = days.single as Map;
      expect(day['date'], isNull);
      expect(day['memoryId'], isNull);
      expect(day['image'], isNull);
      expect(day['title'], 'LifeThreads is locked');
      expect(Directory('${container.path}/widget/images').listSync(), isEmpty);
    });
  });
}
