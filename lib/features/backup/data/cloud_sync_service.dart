import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../memories/data/memory_repository.dart';
import '../domain/backup_models.dart';
import 'backup_service.dart';

final cloudSyncServiceProvider = Provider<CloudSyncService>((ref) {
  return CloudSyncService(backupService: ref.watch(backupServiceProvider));
});

class CloudSyncMetadata {
  const CloudSyncMetadata({
    required this.id,
    required this.size,
    required this.updatedAt,
    required this.memoryCount,
    required this.photoCount,
    required this.wallItemCount,
    required this.deviceName,
  });

  final String id;
  final int size;
  final DateTime? updatedAt;
  final int? memoryCount;
  final int? photoCount;
  final int? wallItemCount;
  final String? deviceName;

  factory CloudSyncMetadata.fromJson(Map<String, Object?> json) {
    return CloudSyncMetadata(
      id: json['id'] as String? ?? '',
      size: (json['size'] as num?)?.toInt() ?? 0,
      updatedAt: json['updatedAt'] is String
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
      memoryCount: (json['memoryCount'] as num?)?.toInt(),
      photoCount: (json['photoCount'] as num?)?.toInt(),
      wallItemCount: (json['wallItemCount'] as num?)?.toInt(),
      deviceName: json['deviceName'] as String?,
    );
  }
}

class CloudSyncException implements Exception {
  const CloudSyncException(this.message);

  final String message;

  @override
  String toString() => message;
}

class CloudSyncService {
  const CloudSyncService({
    required this.backupService,
    this.timeout = const Duration(minutes: 2),
  });

  static const _baseUrl = String.fromEnvironment(
    'LIFETHREADS_SYNC_BASE_URL',
    defaultValue: 'https://lifethreads.gkcoding.dev',
  );
  static const _syncKeyPreference = 'lifethreads.cloud_sync_key';
  static final _syncKeyPattern = RegExp(
    r'^lt_[A-Za-z0-9-]{18,64}_[A-Za-z0-9-]{24,96}$',
  );

  final BackupService backupService;
  final Duration timeout;

  Future<String> ensureSyncKey() async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString(_syncKeyPreference)?.trim();
    if (existing != null && _syncKeyPattern.hasMatch(existing)) {
      return existing;
    }

    const uuid = Uuid();
    final id = uuid.v4().replaceAll('-', '');
    final secret = uuid.v4().replaceAll('-', '');
    final key = 'lt_${id}_$secret';
    await prefs.setString(_syncKeyPreference, key);
    return key;
  }

  Future<void> setSyncKey(String value) async {
    final key = value.trim();
    if (!_syncKeyPattern.hasMatch(key)) {
      throw const CloudSyncException('This sync key is not valid.');
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_syncKeyPreference, key);
  }

  Future<CloudSyncMetadata> uploadBackup({
    required MemoryState state,
    required String password,
  }) async {
    final trimmedPassword = password.trim();
    if (trimmedPassword.isEmpty) {
      throw const CloudSyncException('Cloud backup needs a password.');
    }

    final export = await backupService.exportBackup(
      state,
      password: trimmedPassword,
    );
    final file = File(export.path);
    final syncKey = await ensureSyncKey();
    final response = await _multipartPost(
      _apiUri('/api/sync/snapshot'),
      syncKey: syncKey,
      file: file,
      fields: {
        'memoryCount': '${export.memoryCount}',
        'photoCount': '${export.photoCount}',
        'wallItemCount': '${export.wallItemCount}',
        'deviceName': _deviceName(),
      },
    );
    return _metadataFromResponse(response);
  }

  Future<CloudSyncMetadata?> latest() async {
    final response = await _jsonRequest('GET', _apiUri('/api/sync/latest'));
    if (response == null) return null;
    return _metadataFromResponse(response);
  }

  Future<BackupImportData> downloadAndPrepareImport({
    required String password,
  }) async {
    final syncKey = await ensureSyncKey();
    final client = HttpClient();
    try {
      final request = await client
          .getUrl(_apiUri('/api/sync/latest/download'))
          .timeout(timeout);
      request.headers.set(HttpHeaders.acceptHeader, 'application/zip');
      request.headers.set('x-sync-key', syncKey);

      final response = await request.close().timeout(timeout);
      final bytes = await response.fold<List<int>>(
        <int>[],
        (buffer, chunk) => buffer..addAll(chunk),
      );
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw CloudSyncException(_messageFromBytes(bytes));
      }
      return backupService.prepareImportBytes(bytes, password: password);
    } on CloudSyncException {
      rethrow;
    } on SocketException {
      throw const CloudSyncException(
        'You appear to be offline. Connect to the internet and try again.',
      );
    } catch (error) {
      throw CloudSyncException('Cloud restore failed: $error');
    } finally {
      client.close(force: true);
    }
  }

  Future<void> deleteRemoteBackup() async {
    await _jsonRequest('DELETE', _apiUri('/api/sync'));
  }

  Uri _apiUri(String path) {
    final base = Uri.parse(_baseUrl);
    return base.replace(path: path, query: '');
  }

  Future<Map<String, Object?>?> _jsonRequest(String method, Uri uri) async {
    final syncKey = await ensureSyncKey();
    final client = HttpClient();
    try {
      final request = await client.openUrl(method, uri).timeout(timeout);
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      request.headers.set('x-sync-key', syncKey);
      final response = await request.close().timeout(timeout);
      final body = await response.transform(utf8.decoder).join();
      if (response.statusCode == 404 && method == 'GET') return null;

      final decoded = body.isEmpty ? null : jsonDecode(body);
      if (response.statusCode < 200 ||
          response.statusCode >= 300 ||
          decoded is! Map ||
          decoded['success'] != true) {
        final message = decoded is Map && decoded['message'] is String
            ? decoded['message'] as String
            : 'Cloud sync request failed.';
        throw CloudSyncException(message);
      }
      return decoded.map((key, value) => MapEntry('$key', value));
    } on CloudSyncException {
      rethrow;
    } on SocketException {
      throw const CloudSyncException(
        'You appear to be offline. Connect to the internet and try again.',
      );
    } catch (error) {
      throw CloudSyncException('Cloud sync failed: $error');
    } finally {
      client.close(force: true);
    }
  }

  Future<Map<String, Object?>> _multipartPost(
    Uri uri, {
    required String syncKey,
    required File file,
    required Map<String, String> fields,
  }) async {
    final client = HttpClient();
    try {
      final boundary =
          '----lifethreads-sync-${DateTime.now().microsecondsSinceEpoch}';
      final request = await client.postUrl(uri).timeout(timeout);
      request.headers.set(
        HttpHeaders.contentTypeHeader,
        'multipart/form-data; boundary=$boundary',
      );
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      request.headers.set('x-sync-key', syncKey);

      void writeText(String value) {
        request.add(utf8.encode(value));
      }

      for (final entry in fields.entries) {
        writeText('--$boundary\r\n');
        writeText(
          'Content-Disposition: form-data; name="${entry.key}"\r\n\r\n',
        );
        writeText('${entry.value}\r\n');
      }

      writeText('--$boundary\r\n');
      writeText(
        'Content-Disposition: form-data; name="archive"; '
        'filename="lifethreads-cloud-backup.zip"\r\n',
      );
      writeText('Content-Type: application/zip\r\n\r\n');
      await request.addStream(file.openRead());
      writeText('\r\n--$boundary--\r\n');

      final response = await request.close().timeout(timeout);
      final body = await response.transform(utf8.decoder).join();
      final decoded = body.isEmpty ? null : jsonDecode(body);
      if (response.statusCode < 200 ||
          response.statusCode >= 300 ||
          decoded is! Map ||
          decoded['success'] != true) {
        final message = decoded is Map && decoded['message'] is String
            ? decoded['message'] as String
            : 'Cloud backup upload failed.';
        throw CloudSyncException(message);
      }
      return decoded.map((key, value) => MapEntry('$key', value));
    } on CloudSyncException {
      rethrow;
    } on SocketException {
      throw const CloudSyncException(
        'You appear to be offline. Connect to the internet and try again.',
      );
    } catch (error) {
      throw CloudSyncException('Cloud backup upload failed: $error');
    } finally {
      client.close(force: true);
    }
  }

  CloudSyncMetadata _metadataFromResponse(Map<String, Object?> response) {
    final sync = response['sync'];
    if (sync is! Map) {
      throw const CloudSyncException('Cloud sync response is invalid.');
    }
    return CloudSyncMetadata.fromJson(
      sync.map((key, value) => MapEntry('$key', value)),
    );
  }

  String _messageFromBytes(List<int> bytes) {
    try {
      final decoded = jsonDecode(utf8.decode(bytes));
      if (decoded is Map && decoded['message'] is String) {
        return decoded['message'] as String;
      }
    } catch (_) {}
    return 'Cloud backup download failed.';
  }

  String _deviceName() {
    return 'LifeThreads ${Platform.operatingSystem}';
  }
}
