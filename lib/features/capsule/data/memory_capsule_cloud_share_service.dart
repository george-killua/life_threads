import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/memory_capsule_models.dart';
import 'memory_capsule_share_download_service.dart';

final memoryCapsuleCloudShareServiceProvider =
    Provider<MemoryCapsuleCloudShareService>((ref) {
      return const MemoryCapsuleCloudShareService();
    });

class MemoryCapsuleCloudShareResult {
  const MemoryCapsuleCloudShareResult({
    required this.shareUrl,
    required this.expiresAt,
    this.revokeToken,
  });

  final String shareUrl;
  final DateTime? expiresAt;
  final String? revokeToken;
}

class MemoryCapsuleCloudShareException implements Exception {
  const MemoryCapsuleCloudShareException(this.message);

  final String message;

  @override
  String toString() => message;
}

class MemoryCapsuleCloudShareService {
  static const _encryptedShareTitle = 'LifeThreads memory';

  const MemoryCapsuleCloudShareService({
    this.endpoint = defaultEndpoint,
    this.timeout = const Duration(seconds: 30),
  });

  static const defaultEndpoint = String.fromEnvironment(
    'LIFETHREADS_SHARE_API_URL',
    defaultValue: 'https://gkcoding.dev/api/lifethreads/share',
  );

  final String endpoint;
  final Duration timeout;

  Future<MemoryCapsuleCloudShareResult> uploadCapsule({
    required MemoryCapsuleExportResult capsule,
    int expiresInDays = 14,
  }) async {
    if (!capsule.isEncrypted) {
      throw const MemoryCapsuleCloudShareException(
        'Cloud sharing requires an encrypted capsule.',
      );
    }

    final file = File(capsule.path);
    if (!await file.exists()) {
      throw const MemoryCapsuleCloudShareException(
        'Capsule file was not found.',
      );
    }
    // Recipients refuse anything larger, so don't upload it at all.
    if (await file.length() >
        MemoryCapsuleShareDownloadService.maxCapsuleBytes) {
      throw const MemoryCapsuleCloudShareException(
        'This memory is too large to share as a link (over 25 MB). '
        'Remove a few photos and try again.',
      );
    }

    final client = HttpClient();
    try {
      final boundary =
          '----lifethreads-${DateTime.now().microsecondsSinceEpoch}';
      final request = await client
          .postUrl(Uri.parse(endpoint))
          .timeout(timeout);
      request.headers.set(
        HttpHeaders.contentTypeHeader,
        'multipart/form-data; boundary=$boundary',
      );

      void writeText(String value) {
        request.add(utf8.encode(value));
      }

      void writeField(String name, String value) {
        writeText('--$boundary\r\n');
        writeText('Content-Disposition: form-data; name="$name"\r\n\r\n');
        writeText('$value\r\n');
      }

      // The capsule itself is encrypted; don't leak its title alongside it.
      writeField(
        'title',
        capsule.isEncrypted ? _encryptedShareTitle : capsule.title,
      );
      writeField('expiresInDays', '$expiresInDays');
      writeField('_honey', '');

      writeText('--$boundary\r\n');
      writeText(
        'Content-Disposition: form-data; name="capsule"; '
        'filename="capsule.zip"\r\n',
      );
      writeText('Content-Type: application/zip\r\n\r\n');
      request.add(await file.readAsBytes());
      writeText('\r\n--$boundary--\r\n');

      final response = await request.close().timeout(timeout);
      final body = await _readBody(response);
      final decoded = _decodeJson(body);
      if (response.statusCode < 200 ||
          response.statusCode >= 300 ||
          decoded is! Map ||
          decoded['success'] != true) {
        final message = decoded is Map && decoded['message'] is String
            ? decoded['message'] as String
            : _statusMessage(response.statusCode, 'Share upload failed.');
        throw MemoryCapsuleCloudShareException(message);
      }

      final shareUrl = decoded['shareUrl'];
      if (shareUrl is! String || shareUrl.isEmpty) {
        throw const MemoryCapsuleCloudShareException(
          'Share service did not return a link.',
        );
      }

      final expiresAtValue = decoded['expiresAt'];
      return MemoryCapsuleCloudShareResult(
        shareUrl: shareUrl,
        expiresAt: expiresAtValue is String
            ? DateTime.tryParse(expiresAtValue)
            : null,
        revokeToken: decoded['revokeToken'] is String
            ? decoded['revokeToken'] as String
            : null,
      );
    } on MemoryCapsuleCloudShareException {
      rethrow;
    } on TimeoutException {
      throw const MemoryCapsuleCloudShareException(
        'The upload timed out. Check your connection and try again.',
      );
    } catch (error) {
      throw MemoryCapsuleCloudShareException(
        'Could not upload capsule: $error',
      );
    } finally {
      client.close(force: true);
    }
  }

  Future<void> revokeShare(MemoryCapsuleCloudShareResult share) async {
    final token = share.revokeToken?.trim() ?? '';
    if (token.isEmpty) {
      throw const MemoryCapsuleCloudShareException(
        'This share cannot be deleted from this device.',
      );
    }

    final deleteUri = _deleteUriFor(share.shareUrl);
    final client = HttpClient();
    try {
      final request = await client.deleteUrl(deleteUri).timeout(timeout);
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      request.headers.set('x-revoke-token', token);

      final response = await request.close().timeout(timeout);
      final body = await _readBody(response);
      final decoded = _decodeJson(body);
      if (response.statusCode < 200 ||
          response.statusCode >= 300 ||
          decoded is! Map ||
          decoded['success'] != true) {
        final message = decoded is Map && decoded['message'] is String
            ? decoded['message'] as String
            : _statusMessage(response.statusCode, 'Share deletion failed.');
        throw MemoryCapsuleCloudShareException(message);
      }
    } on MemoryCapsuleCloudShareException {
      rethrow;
    } on TimeoutException {
      throw const MemoryCapsuleCloudShareException(
        'Deleting the share timed out. Please try again.',
      );
    } catch (error) {
      throw MemoryCapsuleCloudShareException(
        'Could not delete shared capsule: $error',
      );
    } finally {
      client.close(force: true);
    }
  }

  /// Reads the whole response body within [timeout], not just the headers.
  Future<String> _readBody(HttpClientResponse response) {
    return response.transform(utf8.decoder).join().timeout(timeout);
  }

  /// Error pages from proxies are often HTML; treat them as "no JSON".
  Object? _decodeJson(String body) {
    if (body.trim().isEmpty) return null;
    try {
      return jsonDecode(body);
    } on FormatException {
      return null;
    }
  }

  String _statusMessage(int statusCode, String fallback) {
    return switch (statusCode) {
      429 => 'Too many requests. Please wait and try again.',
      >= 500 => 'The share service is unavailable right now. Try again later.',
      _ => fallback,
    };
  }

  Uri _deleteUriFor(String shareUrl) {
    final uri = Uri.parse(shareUrl);
    if (uri.pathSegments.length != 3 ||
        uri.pathSegments[0] != 'lifethreads' ||
        uri.pathSegments[1] != 'share') {
      throw const MemoryCapsuleCloudShareException('Share link is not valid.');
    }
    final id = Uri.encodeComponent(uri.pathSegments[2]);
    return uri.replace(path: '/api/lifethreads/share/$id', query: '');
  }
}
