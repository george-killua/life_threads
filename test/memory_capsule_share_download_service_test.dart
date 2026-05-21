import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/features/capsule/data/memory_capsule_share_download_service.dart';

void main() {
  group('MemoryCapsuleShareDownloadService', () {
    const service = MemoryCapsuleShareDownloadService();

    test('recognizes LifeThreads share links', () {
      expect(
        service.isShareLink(
          Uri.parse('https://gkcoding.dev/lifethreads/share/share-id'),
        ),
        isTrue,
      );
      expect(
        service.isShareLink(Uri.parse('https://gkcoding.dev/contact')),
        isFalse,
      );
    });

    test('maps share link to API download URL', () {
      expect(
        service
            .downloadUriFor(
              Uri.parse('https://gkcoding.dev/lifethreads/share/share-id'),
            )
            .toString(),
        'https://gkcoding.dev/api/lifethreads/share/share-id/download',
      );
    });

    test('downloads capsule bytes', () async {
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      addTearDown(() => server.close(force: true));

      final requestFuture = () async {
        final request = await server.first;
        expect(request.uri.path, '/api/lifethreads/share/share-id/download');
        request.response.headers.contentType = ContentType.binary;
        request.response.add([1, 2, 3, 4]);
        await request.response.close();
      }();

      final localService = MemoryCapsuleShareDownloadService(
        timeout: const Duration(seconds: 2),
        allowedHosts: {server.address.address},
      );
      final bytes = await localService.downloadCapsule(
        Uri.parse(
          'http://${server.address.address}:${server.port}/lifethreads/share/share-id',
        ),
      );
      await requestFuture;

      expect(bytes, [1, 2, 3, 4]);
    });

    test('uses server error messages for expired links', () async {
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      addTearDown(() => server.close(force: true));

      final requestFuture = () async {
        final request = await server.first;
        request.response.statusCode = 410;
        request.response.headers.contentType = ContentType.json;
        request.response.write(
          jsonEncode({'message': 'This share link has expired.'}),
        );
        await request.response.close();
      }();

      final localService = MemoryCapsuleShareDownloadService(
        timeout: const Duration(seconds: 2),
        allowedHosts: {server.address.address},
      );

      await expectLater(
        localService.downloadCapsule(
          Uri.parse(
            'http://${server.address.address}:${server.port}/lifethreads/share/share-id',
          ),
        ),
        throwsA(
          isA<MemoryCapsuleShareDownloadException>().having(
            (error) => error.message,
            'message',
            'This share link has expired.',
          ),
        ),
      );
      await requestFuture;
    });
  });
}
