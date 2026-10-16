import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import '../domain/family_models.dart';

/// One HTTP request to the family API.
class FamilyHttpRequest {
  const FamilyHttpRequest({
    required this.method,
    required this.uri,
    this.headers = const {},
    this.body,
    required this.timeout,
  });

  final String method;
  final Uri uri;
  final Map<String, String> headers;
  final List<int>? body;
  final Duration timeout;
}

class FamilyHttpResponse {
  const FamilyHttpResponse({
    required this.statusCode,
    required this.headers,
    required this.body,
  });

  final int statusCode;

  /// Lower-case header names.
  final Map<String, String> headers;
  final Uint8List body;
}

/// The transport, so tests can swap in a fake. Throws [SocketException],
/// [TimeoutException], [HttpException] or [HandshakeException] on network
/// failures; HTTP error statuses are returned, not thrown.
abstract interface class FamilyHttp {
  Future<FamilyHttpResponse> send(FamilyHttpRequest request);

  void close();
}

/// `dart:io` [HttpClient], like the app's other API clients: no extra
/// dependency, and the byte bodies (encrypted photos) are sent as-is.
class IoFamilyHttp implements FamilyHttp {
  IoFamilyHttp() : _client = HttpClient() {
    _client.connectionTimeout = const Duration(seconds: 15);
    _client.idleTimeout = const Duration(seconds: 30);
  }

  final HttpClient _client;

  @override
  Future<FamilyHttpResponse> send(FamilyHttpRequest request) async {
    Future<FamilyHttpResponse> run() async {
      final req = await _client.openUrl(request.method, request.uri);
      req.followRedirects = false;
      request.headers.forEach(req.headers.set);
      final body = request.body;
      if (body != null) {
        req.contentLength = body.length;
        req.add(body);
      } else if (request.method != 'GET' && request.method != 'DELETE') {
        req.contentLength = 0;
      }
      final response = await req.close();
      final builder = BytesBuilder(copy: false);
      await for (final chunk in response) {
        builder.add(chunk);
      }
      final headers = <String, String>{};
      response.headers.forEach((name, values) {
        headers[name.toLowerCase()] = values.join(', ');
      });
      return FamilyHttpResponse(
        statusCode: response.statusCode,
        headers: headers,
        body: builder.toBytes(),
      );
    }

    return run().timeout(request.timeout);
  }

  @override
  void close() => _client.close(force: true);
}

/// Error codes this client produces itself (the server's own codes pass
/// through unchanged).
abstract final class FamilyErrorCodes {
  /// No connection, DNS failure, TLS failure or timeout.
  static const network = 'network_error';
  static const unauthorized = 'unauthorized';
  static const invalidResponse = 'invalid_response';
  static const server = 'server_error';
  static const versionConflict = 'version_conflict';
  static const cursorReset = 'cursor_reset';
  static const familyNotFound = 'family_not_found';
  static const itemNotFound = 'item_not_found';
  static const itemDeleted = 'item_deleted';
  static const alreadyMember = 'already_member';
  static const signInCanceled = 'sign_in_canceled';
  static const signInUnavailable = 'sign_in_unavailable';
  static const signedOut = 'signed_out';
  static const familyKeyMissing = 'family_key_missing';
  static const inviteInvalid = 'invite_invalid';
  static const inviteKeyInvalid = 'invite_key_invalid';
  static const noPurchaseFound = 'no_purchase_found';
  static const nameTooLong = 'name_too_long';
  static const photoUnreadable = 'photo_unreadable';
  static const memoryNotFound = 'memory_not_found';
}

/// A failed API call with the server's JSON error body.
class FamilyApiException extends FamilyException {
  const FamilyApiException(
    super.code,
    super.message, {
    required this.statusCode,
    this.details = const {},
  });

  final int statusCode;

  /// Extra fields of the error body (e.g. `currentVersion`).
  final Map<String, Object?> details;
}

/// JSON and byte calls to the family API with a bearer session token,
/// timeouts, error mapping to [FamilyException] and safe retries.
class FamilyApiClient {
  FamilyApiClient({
    required this.baseUrl,
    required this.http,
    this.jsonTimeout = const Duration(seconds: 20),
    this.blobTimeout = const Duration(seconds: 120),
    this.retryDelays = const [
      Duration(milliseconds: 400),
      Duration(milliseconds: 1500),
    ],
  });

  /// e.g. `https://lifethreads.gkcoding.dev/api/lifethreads/family`.
  final String baseUrl;
  final FamilyHttp http;
  final Duration jsonTimeout;
  final Duration blobTimeout;

  /// Back-off before each retry of an idempotent request.
  final List<Duration> retryDelays;

  /// Returns the session token, or null when signed out.
  Future<String?> Function()? tokenProvider;

  /// Called when the server rejects the session (401).
  Future<void> Function()? onUnauthorized;

  Uri _uri(String path, [Map<String, String>? query]) {
    final base = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    final uri = Uri.parse('$base$path');
    return query == null ? uri : uri.replace(queryParameters: query);
  }

  Future<Map<String, Object?>> getJson(
    String path, {
    Map<String, String>? query,
    bool authenticated = true,
  }) async {
    final response = await _send(
      'GET',
      path,
      query: query,
      authenticated: authenticated,
      idempotent: true,
    );
    return _decodeJson(response);
  }

  Future<Map<String, Object?>> sendJson(
    String method,
    String path, {
    Object? json,
    Map<String, String>? query,
    bool authenticated = true,
    bool idempotent = false,
  }) async {
    final response = await _send(
      method,
      path,
      query: query,
      body: json == null ? null : utf8.encode(jsonEncode(json)),
      headers: json == null
          ? const {}
          : const {'content-type': 'application/json'},
      authenticated: authenticated,
      idempotent: idempotent,
    );
    return _decodeJson(response);
  }

  /// Uploads encrypted bytes. [baseVersion] 0 creates (`If-None-Match: *`),
  /// otherwise `If-Match: <version>`. Returns the server's item JSON.
  ///
  /// A conditional PUT is safe to retry: if the first attempt reached the
  /// server but the answer was lost, the retry fails with a version
  /// conflict whose `currentVersion` is exactly ours + 1 and the server
  /// holds our bytes; that is reported as success.
  Future<Map<String, Object?>> putBlob(
    String path, {
    required List<int> bytes,
    required int baseVersion,
    String? keyId,
  }) async {
    final headers = <String, String>{
      'content-type': 'application/octet-stream',
      if (baseVersion == 0)
        'if-none-match': '*'
      else
        'if-match': '$baseVersion',
      'x-key-id': ?keyId,
    };
    var networkFailures = 0;
    while (true) {
      try {
        final response = await _sendOnce(
          'PUT',
          _uri(path),
          headers: headers,
          body: bytes,
          timeout: blobTimeout,
          authenticated: true,
        );
        final json = _decodeJson(_check(response));
        final item = json['item'];
        if (item is! Map) {
          throw const FamilyException(FamilyErrorCodes.invalidResponse);
        }
        return item.cast<String, Object?>();
      } on FamilyApiException catch (error) {
        if (networkFailures > 0 &&
            error.code == FamilyErrorCodes.versionConflict &&
            error.details['currentVersion'] == baseVersion + 1 &&
            await _storedBytesAre(path, bytes)) {
          return {'version': baseVersion + 1, 'recovered': true};
        }
        rethrow;
      } on _NetworkFailure catch (failure) {
        if (networkFailures >= retryDelays.length) throw failure.exception;
        await Future<void>.delayed(retryDelays[networkFailures]);
        networkFailures++;
      }
    }
  }

  /// Whether the server holds exactly [bytes] at [path]: a lost answer to
  /// our own PUT, not another device's write of the same next version.
  /// (Every encryption uses a fresh nonce, so equal bytes are ours.)
  Future<bool> _storedBytesAre(String path, List<int> bytes) async {
    try {
      final stored = (await getBlob(path)).body;
      if (stored.length != bytes.length) return false;
      for (var i = 0; i < bytes.length; i++) {
        if (stored[i] != bytes[i]) return false;
      }
      return true;
    } on Object {
      return false;
    }
  }

  /// Downloads an item's encrypted bytes.
  Future<FamilyHttpResponse> getBlob(String path) {
    return _send(
      'GET',
      path,
      authenticated: true,
      idempotent: true,
      timeout: blobTimeout,
    );
  }

  Future<FamilyHttpResponse> _send(
    String method,
    String path, {
    Map<String, String>? query,
    List<int>? body,
    Map<String, String> headers = const {},
    required bool authenticated,
    required bool idempotent,
    Duration? timeout,
  }) async {
    final uri = _uri(path, query);
    var attempt = 0;
    while (true) {
      try {
        final response = await _sendOnce(
          method,
          uri,
          headers: headers,
          body: body,
          timeout: timeout ?? jsonTimeout,
          authenticated: authenticated,
        );
        if (idempotent &&
            _retryableStatus(response.statusCode) &&
            attempt < retryDelays.length) {
          await Future<void>.delayed(retryDelays[attempt++]);
          continue;
        }
        return _check(response);
      } on _NetworkFailure catch (failure) {
        if (!idempotent || attempt >= retryDelays.length) {
          throw failure.exception;
        }
        await Future<void>.delayed(retryDelays[attempt++]);
      }
    }
  }

  static bool _retryableStatus(int status) =>
      status == 502 || status == 503 || status == 504;

  Future<FamilyHttpResponse> _sendOnce(
    String method,
    Uri uri, {
    required Map<String, String> headers,
    List<int>? body,
    required Duration timeout,
    required bool authenticated,
  }) async {
    final allHeaders = <String, String>{
      'accept': 'application/json',
      ...headers,
    };
    String? token;
    if (authenticated) {
      token = await tokenProvider?.call();
      if (token == null) {
        throw const FamilyException(FamilyErrorCodes.signedOut);
      }
      allHeaders['authorization'] = 'Bearer $token';
    }
    final FamilyHttpResponse response;
    try {
      response = await http.send(
        FamilyHttpRequest(
          method: method,
          uri: uri,
          headers: allHeaders,
          body: body,
          timeout: timeout,
        ),
      );
    } on SocketException catch (error) {
      throw _NetworkFailure(error);
    } on TimeoutException catch (error) {
      throw _NetworkFailure(error);
    } on HandshakeException catch (error) {
      throw _NetworkFailure(error);
    } on HttpException catch (error) {
      throw _NetworkFailure(error);
    }
    // The server rejected this session. A request sent with an older token
    // (signed out and in again meanwhile) says nothing about the new one.
    if (token != null &&
        response.statusCode == 401 &&
        await tokenProvider?.call() == token) {
      await onUnauthorized?.call();
    }
    return response;
  }

  /// Returns a 2xx response or throws the mapped [FamilyApiException].
  FamilyHttpResponse _check(FamilyHttpResponse response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    }
    throw _errorFrom(response);
  }

  FamilyApiException _errorFrom(FamilyHttpResponse response) {
    Object? decoded;
    try {
      decoded = jsonDecode(utf8.decode(response.body));
    } on FormatException {
      decoded = null;
    }
    if (decoded is Map && decoded['code'] is String) {
      final details = Map<String, Object?>.from(decoded)
        ..remove('success')
        ..remove('code')
        ..remove('message');
      return FamilyApiException(
        decoded['code'] as String,
        decoded['message'] is String ? decoded['message'] as String : null,
        statusCode: response.statusCode,
        details: details,
      );
    }
    final code = switch (response.statusCode) {
      401 => FamilyErrorCodes.unauthorized,
      404 => 'not_found',
      413 => 'too_large',
      429 => 'rate_limited',
      >= 500 => FamilyErrorCodes.server,
      _ => FamilyErrorCodes.invalidResponse,
    };
    return FamilyApiException(code, null, statusCode: response.statusCode);
  }

  Map<String, Object?> _decodeJson(FamilyHttpResponse response) {
    try {
      final decoded = jsonDecode(utf8.decode(response.body));
      if (decoded is Map) return decoded.cast<String, Object?>();
    } on FormatException {
      // Falls through.
    }
    throw const FamilyException(FamilyErrorCodes.invalidResponse);
  }
}

class _NetworkFailure implements Exception {
  _NetworkFailure(Object cause)
    : exception = FamilyException(
        FamilyErrorCodes.network,
        cause is TimeoutException
            ? 'The connection timed out.'
            : 'Could not reach LifeThreads. Check your connection.',
      );

  final FamilyException exception;
}
