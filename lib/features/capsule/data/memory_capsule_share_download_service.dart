import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final memoryCapsuleShareDownloadServiceProvider =
    Provider<MemoryCapsuleShareDownloadService>((ref) {
      return const MemoryCapsuleShareDownloadService();
    });

class MemoryCapsuleShareDownloadException implements Exception {
  const MemoryCapsuleShareDownloadException(this.message);

  final String message;

  @override
  String toString() => message;
}

class MemoryCapsuleShareDownloadService {
  const MemoryCapsuleShareDownloadService({
    this.timeout = const Duration(seconds: 30),
    this.maxBytes = 25 * 1024 * 1024,
    this.allowedHosts = const {'gkcoding.dev', 'www.gkcoding.dev'},
  });

  final Duration timeout;
  final int maxBytes;
  final Set<String> allowedHosts;

  bool isShareLink(Uri uri) {
    return (uri.scheme == 'https' || uri.scheme == 'http') &&
        allowedHosts.contains(uri.host) &&
        uri.pathSegments.length == 3 &&
        uri.pathSegments[0] == 'lifethreads' &&
        uri.pathSegments[1] == 'share' &&
        uri.pathSegments[2].isNotEmpty;
  }

  Uri downloadUriFor(Uri shareUri) {
    if (!isShareLink(shareUri)) {
      throw const MemoryCapsuleShareDownloadException(
        'This is not a LifeThreads share link.',
      );
    }
    final id = Uri.encodeComponent(shareUri.pathSegments[2]);
    return shareUri.replace(path: '/api/lifethreads/share/$id/download');
  }

  Future<List<int>> downloadCapsule(Uri shareUri) async {
    final downloadUri = downloadUriFor(shareUri);
    final client = HttpClient();
    try {
      final request = await client.getUrl(downloadUri).timeout(timeout);
      request.headers.set(HttpHeaders.acceptHeader, 'application/zip');
      final response = await request.close().timeout(timeout);
      final bytes = await _readBytes(response);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (bytes.isEmpty) {
          throw const MemoryCapsuleShareDownloadException(
            'The shared capsule is empty.',
          );
        }
        return bytes;
      }

      throw MemoryCapsuleShareDownloadException(
        _errorMessage(response.statusCode, bytes),
      );
    } on MemoryCapsuleShareDownloadException {
      rethrow;
    } on SocketException {
      throw const MemoryCapsuleShareDownloadException(
        'You appear to be offline. Try again when internet is available.',
      );
    } catch (error) {
      throw MemoryCapsuleShareDownloadException(
        'Could not download shared memory: $error',
      );
    } finally {
      client.close(force: true);
    }
  }

  Future<List<int>> _readBytes(HttpClientResponse response) async {
    final output = <int>[];
    await for (final chunk in response) {
      output.addAll(chunk);
      if (output.length > maxBytes) {
        throw const MemoryCapsuleShareDownloadException(
          'This shared memory is too large to import.',
        );
      }
    }
    return output;
  }

  String _errorMessage(int statusCode, List<int> bytes) {
    final raw = utf8.decode(bytes, allowMalformed: true);
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map && decoded['message'] is String) {
        return decoded['message'] as String;
      }
    } catch (_) {
      // Fall back to status-aware messages below.
    }

    return switch (statusCode) {
      404 => 'This shared memory link was not found.',
      410 => 'This shared memory link has expired or was deleted.',
      429 => 'Too many requests. Please wait and try again.',
      _ => 'Shared memory download failed. Server returned $statusCode.',
    };
  }
}
