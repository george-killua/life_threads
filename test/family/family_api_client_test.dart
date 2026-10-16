import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:life_threads/features/family/data/family_api_client.dart';
import 'package:life_threads/features/family/data/family_photo_processor.dart';
import 'package:life_threads/features/family/domain/family_models.dart';
import 'package:path/path.dart' as p;

class _ScriptedHttp implements FamilyHttp {
  _ScriptedHttp(this.responses);

  final List<Object> responses; // FamilyHttpResponse or an Exception
  final List<FamilyHttpRequest> requests = [];

  @override
  Future<FamilyHttpResponse> send(FamilyHttpRequest request) async {
    requests.add(request);
    final next = responses.removeAt(0);
    if (next is Exception) throw next;
    return next as FamilyHttpResponse;
  }

  @override
  void close() {}
}

/// Answers every request with [answer], called when the request is sent.
class _DelayedHttp implements FamilyHttp {
  _DelayedHttp(this.log, this.answer);

  final _ScriptedHttp log;
  final FamilyHttpResponse Function() answer;

  @override
  Future<FamilyHttpResponse> send(FamilyHttpRequest request) async {
    log.requests.add(request);
    return answer();
  }

  @override
  void close() {}
}

FamilyHttpResponse _json(int status, Map<String, Object?> body) =>
    FamilyHttpResponse(
      statusCode: status,
      headers: const {'content-type': 'application/json'},
      body: Uint8List.fromList(utf8.encode(jsonEncode(body))),
    );

void main() {
  FamilyApiClient client(_ScriptedHttp http) => FamilyApiClient(
    baseUrl: 'https://family.test/api/',
    http: http,
    retryDelays: const [Duration.zero, Duration.zero],
  )..tokenProvider = (() async => 'lts_token');

  test('sends the bearer token and maps error bodies to codes', () async {
    final http = _ScriptedHttp([
      _json(402, {
        'success': false,
        'code': 'subscription_required',
        'message': 'The family owner needs Premium.',
      }),
    ]);
    await expectLater(
      client(http).sendJson('POST', '/families', json: {'encryptedName': 'x'}),
      throwsA(
        isA<FamilyApiException>()
            .having((e) => e.code, 'code', 'subscription_required')
            .having((e) => e.statusCode, 'status', 402)
            .having((e) => e.message, 'message', contains('Premium')),
      ),
    );
    final request = http.requests.single;
    expect(request.uri.toString(), 'https://family.test/api/families');
    expect(request.headers['authorization'], 'Bearer lts_token');
    expect(request.headers['content-type'], 'application/json');
  });

  test('retries GETs on 503 and network errors, not POSTs', () async {
    final http = _ScriptedHttp([
      _json(503, {'success': false, 'code': 'server_error'}),
      const SocketException('reset'),
      _json(200, {'success': true, 'families': []}),
    ]);
    final json = await client(http).getJson('/families');
    expect(json['families'], isEmpty);
    expect(http.requests, hasLength(3));

    final post = _ScriptedHttp([TimeoutException('slow')]);
    await expectLater(
      client(post).sendJson('POST', '/invites/accept', json: {'token': 't'}),
      throwsA(
        isA<FamilyException>().having((e) => e.code, 'code', 'network_error'),
      ),
    );
    expect(post.requests, hasLength(1));
  });

  test('a version conflict carries the current version', () async {
    final http = _ScriptedHttp([
      _json(412, {
        'success': false,
        'code': 'version_conflict',
        'message': 'The item changed on the server.',
        'currentVersion': 3,
      }),
    ]);
    await expectLater(
      client(http).putBlob('/x', bytes: [1], baseVersion: 2, keyId: 'k'),
      throwsA(
        isA<FamilyApiException>()
            .having((e) => e.code, 'code', 'version_conflict')
            .having((e) => e.details['currentVersion'], 'current', 3),
      ),
    );
    final request = http.requests.single;
    expect(request.headers['if-match'], '2');
    expect(request.headers['x-key-id'], 'k');
    expect(request.headers['content-type'], 'application/octet-stream');
  });

  test('creating uses If-None-Match: * and a 401 ends the session', () async {
    var expired = false;
    final http = _ScriptedHttp([
      _json(401, {'success': false, 'code': 'unauthorized'}),
    ]);
    final api = client(http)..onUnauthorized = () async => expired = true;
    await expectLater(
      api.putBlob('/x', bytes: [1], baseVersion: 0),
      throwsA(
        isA<FamilyException>().having((e) => e.code, 'code', 'unauthorized'),
      ),
    );
    expect(http.requests.single.headers['if-none-match'], '*');
    expect(http.requests.single.headers.containsKey('if-match'), isFalse);
    expect(expired, isTrue);
  });

  test(
    'a 401 for a request sent with an older token keeps the new session',
    () async {
      var expired = false;
      var token = 'lts_old';
      late final FamilyApiClient api;
      final http = _ScriptedHttp([]);
      api =
          FamilyApiClient(
              baseUrl: 'https://family.test/api/',
              http: _DelayedHttp(http, () {
                // Signed out and in again while the request was on its way.
                token = 'lts_new';
                return _json(401, {'success': false, 'code': 'unauthorized'});
              }),
              retryDelays: const [Duration.zero],
            )
            ..tokenProvider = (() async => token)
            ..onUnauthorized = () async => expired = true;
      await expectLater(
        api.getJson('/account'),
        throwsA(isA<FamilyException>()),
      );
      expect(expired, isFalse);
    },
  );

  test('photos are resized to 2048 px and lose their metadata', () async {
    final dir = await Directory.systemTemp.createTemp('family-photo-test');
    addTearDown(() => dir.delete(recursive: true));
    final image = img.Image(width: 1200, height: 2600);
    image.exif.gpsIfd['GPSLatitude'] = img.IfdValueRational(48, 1);
    image.exif.imageIfd['Make'] = img.IfdValueAscii('Camera');
    final path = p.join(dir.path, 'tall.jpg');
    await File(path).writeAsBytes(img.encodeJpg(image));
    expect(
      img.decodeJpg(await File(path).readAsBytes())!.exif.isEmpty,
      isFalse,
    );

    final jpeg = await const DefaultFamilyPhotoProcessor().prepare(path);
    final out = img.decodeJpg(jpeg)!;
    expect(out.height, 2048);
    expect(out.width, (1200 * 2048 / 2600).round());
    expect(out.exif.isEmpty, isTrue);

    await expectLater(
      const DefaultFamilyPhotoProcessor().prepare(p.join(dir.path, 'missing')),
      throwsA(
        isA<FamilyException>().having(
          (e) => e.code,
          'code',
          'photo_unreadable',
        ),
      ),
    );
  });
}
