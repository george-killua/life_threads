import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

import '../../memories/data/memory_repository.dart';
import '../../memories/domain/memory_photo.dart';
import '../../wall/domain/wall_attachment_layout.dart';
import '../../wall/domain/wall_item.dart';

final wallDisplayServiceProvider = Provider<WallDisplayService>((ref) {
  return const WallDisplayService();
});

class WallDisplayPublishResult {
  const WallDisplayPublishResult({
    required this.displayUrl,
    required this.expiresAt,
    required this.memoryCount,
  });

  final String displayUrl;
  final DateTime? expiresAt;
  final int memoryCount;
}

class WallDisplayException implements Exception {
  const WallDisplayException(this.message);

  final String message;

  @override
  String toString() => message;
}

class WallDisplayService {
  const WallDisplayService({
    this.timeout = const Duration(seconds: 45),
    this.allowedHosts = const {
      'gkcoding.dev',
      'www.gkcoding.dev',
      'display.gkcoding.dev',
      'lifethreads.gkcoding.dev',
    },
  });

  final Duration timeout;
  final Set<String> allowedHosts;

  bool isDisplayScanLink(Uri uri) {
    return _displaySessionId(uri) != null;
  }

  String? _displaySessionId(Uri uri) {
    if ((uri.scheme != 'https' && uri.scheme != 'http') ||
        !allowedHosts.contains(uri.host) ||
        !(uri.queryParameters['token']?.isNotEmpty ?? false)) {
      return null;
    }

    if (uri.pathSegments.length == 3 &&
        uri.pathSegments[0] == 'display' &&
        uri.pathSegments[1].isNotEmpty &&
        uri.pathSegments[2] == 'connect') {
      return uri.pathSegments[1];
    }

    if (uri.pathSegments.length == 4 &&
        uri.pathSegments[0] == 'lifethreads' &&
        uri.pathSegments[1] == 'display' &&
        uri.pathSegments[2].isNotEmpty &&
        uri.pathSegments[3] == 'connect') {
      return uri.pathSegments[2];
    }

    return null;
  }

  bool _usesDedicatedDisplayPath(Uri uri) {
    return (uri.scheme == 'https' || uri.scheme == 'http') &&
        allowedHosts.contains(uri.host) &&
        uri.pathSegments.length == 3 &&
        uri.pathSegments[0] == 'display';
  }

  Future<WallDisplayPublishResult> publishSnapshot({
    required Uri scanUri,
    required MemoryState state,
  }) async {
    if (!isDisplayScanLink(scanUri)) {
      throw const WallDisplayException(
        'This is not a LifeThreads display QR code.',
      );
    }

    final snapshot = await _snapshotFor(state);
    final bytes = utf8.encode(jsonEncode(snapshot));
    final uploadUri = _uploadUriFor(scanUri);
    final token = scanUri.queryParameters['token']!;

    final client = HttpClient();
    try {
      final boundary =
          '----lifethreads-display-${DateTime.now().microsecondsSinceEpoch}';
      final request = await client.postUrl(uploadUri).timeout(timeout);
      request.headers.set(
        HttpHeaders.contentTypeHeader,
        'multipart/form-data; boundary=$boundary',
      );
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      request.headers.set('x-display-token', token);

      void writeText(String value) {
        request.add(utf8.encode(value));
      }

      writeText('--$boundary\r\n');
      writeText(
        'Content-Disposition: form-data; name="snapshot"; '
        'filename="lifethreads-display.json"\r\n',
      );
      writeText('Content-Type: application/json\r\n\r\n');
      request.add(bytes);
      writeText('\r\n--$boundary--\r\n');

      final response = await request.close().timeout(timeout);
      final body = await response.transform(utf8.decoder).join();
      final decoded = jsonDecode(body);
      if (response.statusCode < 200 ||
          response.statusCode >= 300 ||
          decoded is! Map ||
          decoded['success'] != true) {
        final message = decoded is Map && decoded['message'] is String
            ? decoded['message'] as String
            : 'Wall display upload failed.';
        throw WallDisplayException(message);
      }

      final display = decoded['display'];
      if (display is! Map || display['displayUrl'] is! String) {
        throw const WallDisplayException(
          'Display service did not return a display URL.',
        );
      }

      final expiresAt = display['expiresAt'];
      return WallDisplayPublishResult(
        displayUrl: display['displayUrl'] as String,
        expiresAt: expiresAt is String ? DateTime.tryParse(expiresAt) : null,
        memoryCount: state.events.length,
      );
    } on WallDisplayException {
      rethrow;
    } on SocketException {
      throw const WallDisplayException(
        'You appear to be offline. Connect to the internet and try again.',
      );
    } catch (error) {
      throw WallDisplayException('Could not display wall: $error');
    } finally {
      client.close(force: true);
    }
  }

  Uri _uploadUriFor(Uri scanUri) {
    final id = Uri.encodeComponent(_displaySessionId(scanUri)!);
    final apiPath = _usesDedicatedDisplayPath(scanUri)
        ? '/api/display/$id/snapshot'
        : '/api/lifethreads/display/$id/snapshot';
    return scanUri.replace(path: apiPath, query: '');
  }

  Future<Map<String, Object?>> _snapshotFor(MemoryState state) async {
    final photosByEventId = <String, List<MemoryPhoto>>{};
    for (final photo in state.photos) {
      photosByEventId.putIfAbsent(photo.eventId, () => []).add(photo);
    }

    final events = <Map<String, Object?>>[];
    for (final event in state.events) {
      final photoDataUrls = await _photoDataUrls([
        event.coverPhotoPath,
        ...?photosByEventId[event.id]?.map((photo) => photo.localPath),
      ]);
      events.add({
        'id': event.id,
        'title': event.title,
        'description': event.description,
        'category': event.category.name,
        'categoryLabel': event.category.label,
        'memoryType': event.memoryType.name,
        'memoryTypeLabel': event.memoryType.label,
        'feeling': event.feeling.name,
        'feelingLabel': event.feeling.label,
        'occurredAt': event.occurredAt.millisecondsSinceEpoch,
        'createdAt': event.createdAt.millisecondsSinceEpoch,
        'locationLabel': event.locationDisplayLabel,
        'wallX': event.wallPosition.dx,
        'wallY': event.wallPosition.dy,
        'rotation': event.rotation,
        'coverColor': _hexColor(event.coverColor.toARGB32()),
        'coverPhotoDataUrl': photoDataUrls.isEmpty ? null : photoDataUrls.first,
        'photoDataUrls': photoDataUrls,
      });
    }

    return {
      'app': 'LifeThreads',
      'type': 'wallDisplaySnapshot',
      'version': 1,
      'createdAt': DateTime.now().toUtc().toIso8601String(),
      'wall': {
        'width': WallAttachmentLayout.canvasSize.width,
        'height': WallAttachmentLayout.canvasSize.height,
      },
      'events': events,
      'wallItems': [
        for (final item in state.wallItems)
          {
            'id': item.id,
            'type': item.type.name,
            'content': item.type == WallItemType.text ? item.content : '',
            'createdAt': item.createdAt.millisecondsSinceEpoch,
            'wallX': item.wallPosition.dx,
            'wallY': item.wallPosition.dy,
            'color': _hexColor(item.color.toARGB32()),
          },
      ],
      'connections': [
        for (final connection in state.connections)
          {
            'id': connection.id,
            'fromEventId': connection.fromEventId,
            'toEventId': connection.toEventId,
            'label': connection.label,
          },
      ],
    };
  }

  Future<String?> _coverPhotoDataUrl(String? path) async {
    if (path == null || path.isEmpty) return null;
    final source = path.startsWith('assets/')
        ? (await rootBundle.load(path)).buffer.asUint8List()
        : await _readFileBytes(path);
    if (source == null) return null;
    final decoded = img.decodeImage(source);
    if (decoded == null) return null;

    final resized = decoded.width > 640
        ? img.copyResize(decoded, width: 640)
        : decoded;
    final encoded = img.encodeJpg(resized, quality: 72);
    return 'data:image/jpeg;base64,${base64Encode(encoded)}';
  }

  Future<Uint8List?> _readFileBytes(String path) async {
    final file = File(path);
    if (!await file.exists()) return null;
    return file.readAsBytes();
  }

  Future<List<String>> _photoDataUrls(Iterable<String?> paths) async {
    final urls = <String>[];
    final seen = <String>{};
    for (final path in paths) {
      if (path == null || path.isEmpty || !seen.add(path)) continue;
      final dataUrl = await _coverPhotoDataUrl(path);
      if (dataUrl != null) urls.add(dataUrl);
    }
    return urls;
  }

  String _hexColor(int value) {
    return '#${value.toRadixString(16).padLeft(8, '0').substring(2)}';
  }
}
