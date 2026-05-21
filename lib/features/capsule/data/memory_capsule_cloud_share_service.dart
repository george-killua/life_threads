import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;

import '../domain/memory_capsule_models.dart';

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

      writeField('title', capsule.title);
      writeField('expiresInDays', '$expiresInDays');
      writeField('_honey', '');

      writeText('--$boundary\r\n');
      writeText(
        'Content-Disposition: form-data; name="capsule"; '
        'filename="${p.basename(file.path)}"\r\n',
      );
      writeText('Content-Type: application/zip\r\n\r\n');
      request.add(await file.readAsBytes());
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
            : 'Share upload failed.';
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
      final body = await response.transform(utf8.decoder).join();
      final decoded = body.trim().isEmpty ? null : jsonDecode(body);
      if (response.statusCode < 200 ||
          response.statusCode >= 300 ||
          decoded is! Map ||
          decoded['success'] != true) {
        final message = decoded is Map && decoded['message'] is String
            ? decoded['message'] as String
            : 'Share deletion failed.';
        throw MemoryCapsuleCloudShareException(message);
      }
    } on MemoryCapsuleCloudShareException {
      rethrow;
    } catch (error) {
      throw MemoryCapsuleCloudShareException(
        'Could not delete shared capsule: $error',
      );
    } finally {
      client.close(force: true);
    }
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
