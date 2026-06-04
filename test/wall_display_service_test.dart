import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/features/display/data/wall_display_service.dart';

void main() {
  group('WallDisplayService', () {
    const service = WallDisplayService();

    test('recognizes dedicated LifeThreads display QR links', () {
      expect(
        service.isDisplayScanLink(
          Uri.parse(
            'https://lifethreads.gkcoding.dev/display/session-id/connect?token=secret',
          ),
        ),
        isTrue,
      );
    });

    test('keeps legacy display QR links working', () {
      expect(
        service.isDisplayScanLink(
          Uri.parse(
            'https://gkcoding.dev/lifethreads/display/session-id/connect?token=secret',
          ),
        ),
        isTrue,
      );
    });

    test('rejects display links without an upload token', () {
      expect(
        service.isDisplayScanLink(
          Uri.parse('https://lifethreads.gkcoding.dev/display/session-id'),
        ),
        isFalse,
      );
    });
  });
}
