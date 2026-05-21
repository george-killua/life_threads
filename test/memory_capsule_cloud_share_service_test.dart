import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/features/capsule/data/memory_capsule_cloud_share_service.dart';
import 'package:life_threads/features/capsule/domain/memory_capsule_models.dart';
import 'package:path/path.dart' as p;

void main() {
  group('MemoryCapsuleCloudShareService', () {
    test('rejects unencrypted capsules', () async {
      final dir = await Directory.systemTemp.createTemp('capsule-share-test');
      addTearDown(() => dir.delete(recursive: true));
      final file = File(p.join(dir.path, 'capsule.zip'));
      await file.writeAsBytes([1, 2, 3]);

      const service = MemoryCapsuleCloudShareService(
        endpoint: 'http://127.0.0.1/not-called',
      );

      await expectLater(
        service.uploadCapsule(
          capsule: MemoryCapsuleExportResult(
            path: file.path,
            title: 'Test memory',
            photoCount: 1,
            noteCount: 0,
            connectionCount: 0,
            isEncrypted: false,
          ),
        ),
        throwsA(isA<MemoryCapsuleCloudShareException>()),
      );
    });

    test('uploads encrypted capsule multipart payload', () async {
      final dir = await Directory.systemTemp.createTemp('capsule-share-test');
      addTearDown(() => dir.delete(recursive: true));
      final file = File(p.join(dir.path, 'capsule.zip'));
      await file.writeAsBytes([1, 2, 3, 4]);

      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      addTearDown(() => server.close(force: true));

      late String requestBody;
      final requestFuture = () async {
        final request = await server.first;
        final bytes = await request.fold<List<int>>(
          <int>[],
          (buffer, chunk) => buffer..addAll(chunk),
        );
        requestBody = utf8.decode(bytes, allowMalformed: true);
        request.response.headers.contentType = ContentType.json;
        request.response.write(
          jsonEncode({
            'success': true,
            'shareUrl': 'https://gkcoding.dev/lifethreads/share/share-id',
            'expiresAt': '2026-05-28T12:00:00.000Z',
            'revokeToken': 'revoke-token',
          }),
        );
        await request.response.close();
      }();

      final service = MemoryCapsuleCloudShareService(
        endpoint:
            'http://${server.address.address}:${server.port}/api/lifethreads/share',
      );

      final result = await service.uploadCapsule(
        capsule: MemoryCapsuleExportResult(
          path: file.path,
          title: 'Vienna arrival',
          photoCount: 1,
          noteCount: 2,
          connectionCount: 3,
          isEncrypted: true,
        ),
        expiresInDays: 7,
      );
      await requestFuture;

      expect(
        result.shareUrl,
        'https://gkcoding.dev/lifethreads/share/share-id',
      );
      expect(result.revokeToken, 'revoke-token');
      expect(requestBody, contains('name="title"'));
      expect(requestBody, contains('Vienna arrival'));
      expect(requestBody, contains('name="expiresInDays"'));
      expect(requestBody, contains('7'));
      expect(requestBody, contains('name="capsule"'));
      expect(requestBody, contains('filename="capsule.zip"'));
    });

    test('revokes share with token header', () async {
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      addTearDown(() => server.close(force: true));

      final requestFuture = () async {
        final request = await server.first;
        expect(request.method, 'DELETE');
        expect(request.uri.path, '/api/lifethreads/share/share-id');
        expect(request.headers.value('x-revoke-token'), 'revoke-token');
        request.response.headers.contentType = ContentType.json;
        request.response.write(jsonEncode({'success': true}));
        await request.response.close();
      }();

      const service = MemoryCapsuleCloudShareService();
      await service.revokeShare(
        MemoryCapsuleCloudShareResult(
          shareUrl:
              'http://${server.address.address}:${server.port}/lifethreads/share/share-id',
          expiresAt: null,
          revokeToken: 'revoke-token',
        ),
      );
      await requestFuture;
    });
  });
}
