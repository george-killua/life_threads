import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/features/capsule/data/memory_capsule_cloud_share_service.dart';
import 'package:life_threads/features/capsule/data/memory_capsule_share_download_service.dart';
import 'package:life_threads/features/capsule/domain/memory_capsule_models.dart';

MemoryCapsuleExportResult _capsule(String path, String title) =>
    MemoryCapsuleExportResult(
      path: path,
      title: title,
      photoCount: 0,
      noteCount: 0,
      connectionCount: 0,
      isEncrypted: true,
    );

void main() {
  test('download: stalled body must honour timeout', () async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(() => server.close(force: true));
    server.listen((req) async {
      req.response.contentLength = 100;
      req.response.add([1, 2, 3]);
      await req.response.flush(); // then stall forever
    });
    final service = MemoryCapsuleShareDownloadService(
      timeout: const Duration(milliseconds: 300),
      allowedHosts: {'127.0.0.1'},
    );
    final uri = Uri.parse('http://127.0.0.1:${server.port}/share/abc');
    Object? error;
    try {
      await service.downloadCapsule(uri).timeout(const Duration(seconds: 3));
    } catch (e) {
      error = e;
    }
    expect(
      error,
      isA<MemoryCapsuleShareDownloadException>(),
      reason: 'got ${error.runtimeType}: body read has no timeout',
    );
  });

  test('upload: stalled response body must honour timeout', () async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(() => server.close(force: true));
    server.listen((req) async {
      await req.drain<void>();
      req.response.contentLength = 100;
      req.response.write('{');
      await req.response.flush(); // stall
    });
    final dir = await Directory.systemTemp.createTemp('p3');
    final file = File('${dir.path}/c.zip')..writeAsBytesSync([1, 2, 3]);
    final service = MemoryCapsuleCloudShareService(
      endpoint: 'http://127.0.0.1:${server.port}/api/lifethreads/share',
      timeout: const Duration(milliseconds: 300),
    );
    Object? error;
    try {
      await service
          .uploadCapsule(capsule: _capsule(file.path, 't'))
          .timeout(const Duration(seconds: 3));
    } catch (e) {
      error = e;
    }
    expect(
      error,
      isA<MemoryCapsuleCloudShareException>(),
      reason: 'got ${error.runtimeType}: response body read has no timeout',
    );
  });

  test('upload: non-JSON 502 body yields friendly message', () async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(() => server.close(force: true));
    server.listen((req) async {
      await req.drain<void>();
      req.response.statusCode = 502;
      req.response.write('<html>Bad Gateway</html>');
      await req.response.close();
    });
    final dir = await Directory.systemTemp.createTemp('p3');
    final file = File('${dir.path}/c.zip')..writeAsBytesSync([1, 2, 3]);
    final service = MemoryCapsuleCloudShareService(
      endpoint: 'http://127.0.0.1:${server.port}/api/lifethreads/share',
    );
    await expectLater(
      service.uploadCapsule(capsule: _capsule(file.path, 't')),
      throwsA(
        predicate(
          (e) =>
              e is MemoryCapsuleCloudShareException &&
              !e.message.contains('FormatException'),
        ),
      ),
    );
  });

  test('encrypted share must not send memory title in plaintext', () async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(() => server.close(force: true));
    final received = Completer<String>();
    server.listen((req) async {
      final body = await utf8.decoder.bind(req).join().catchError((_) => '');
      if (!received.isCompleted) received.complete(body);
      req.response.headers.contentType = ContentType.json;
      req.response.write(
        jsonEncode({
          'success': true,
          'shareUrl': 'https://gkcoding.dev/lifethreads/share/x',
        }),
      );
      await req.response.close();
    });
    final dir = await Directory.systemTemp.createTemp('p3');
    // Same naming scheme exportCapsule uses (memory_capsule_service.dart:129).
    final file = File('${dir.path}/lifethreads_capsule_secret_affair_x.zip')
      ..writeAsBytesSync([1, 2, 3]);
    final service = MemoryCapsuleCloudShareService(
      endpoint: 'http://127.0.0.1:${server.port}/api/lifethreads/share',
    );
    await service.uploadCapsule(capsule: _capsule(file.path, 'Secret affair'));
    final body = await received.future;
    expect(
      body.contains('Secret affair'),
      isFalse,
      reason: 'title field leaks plaintext title',
    );
    expect(
      body.contains('secret_affair'),
      isFalse,
      reason: 'filename leaks title slug',
    );
  });

  test('plaintext http share links must be rejected', () {
    const service = MemoryCapsuleShareDownloadService();
    final uri = Uri.parse('http://gkcoding.dev/share/abc');
    expect(service.isShareLink(uri), isFalse);
  });
}
