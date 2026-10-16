import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'family_crypto.dart';

/// Key-value secrets (Keychain on iOS, Keystore-backed on Android).
abstract interface class FamilySecretStorage {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
  Future<Map<String, String>> readAll();
}

class FlutterFamilySecretStorage implements FamilySecretStorage {
  FlutterFamilySecretStorage()
    : _storage = const FlutterSecureStorage(
        // Background syncs may run while the device is locked; never
        // migrate to another device (keys travel only in invite links).
        iOptions: IOSOptions(
          accessibility: KeychainAccessibility.first_unlock_this_device,
        ),
        aOptions: AndroidOptions(),
      );

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);

  @override
  Future<Map<String, String>> readAll() => _storage.readAll();
}

/// In-memory secrets, for tests.
class MemoryFamilySecretStorage implements FamilySecretStorage {
  final Map<String, String> values = {};

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async => values[key] = value;

  @override
  Future<void> delete(String key) async => values.remove(key);

  @override
  Future<Map<String, String>> readAll() async => Map.of(values);
}

/// The family wall's secrets: the session token and one key ring per
/// family. Nothing here is ever sent to the server except the session token.
class FamilySecrets {
  FamilySecrets(this.storage);

  final FamilySecretStorage storage;

  static const _sessionKey = 'lifethreads.family.session';
  static const _familyKeyPrefix = 'lifethreads.family.key.';
  static const _deviceKey = 'lifethreads.family.device';

  final Map<String, FamilyKeyRing> _rings = {};
  Future<FamilyDeviceKey>? _device;

  /// This device's key pair for receiving rotated family keys, created on
  /// first use. Kept on sign-out (like the family keys), removed with them.
  Future<FamilyDeviceKey> deviceKey() => _device ??= () async {
    final raw = await storage.read(_deviceKey);
    if (raw != null) {
      try {
        final existing = await FamilyDeviceKey.fromJson(jsonDecode(raw));
        if (existing != null) return existing;
      } on FormatException {
        // Unreadable: replaced below.
      }
    }
    final created = await FamilyDeviceKey.generate();
    await storage.write(_deviceKey, jsonEncode(created.toJson()));
    return created;
  }();
  String? _session;
  bool _sessionLoaded = false;

  Future<String?> sessionToken() async {
    if (!_sessionLoaded) {
      _session = await storage.read(_sessionKey);
      _sessionLoaded = true;
    }
    return _session;
  }

  Future<void> saveSessionToken(String token) async {
    await storage.write(_sessionKey, token);
    _session = token;
    _sessionLoaded = true;
  }

  Future<void> clearSessionToken() async {
    _session = null;
    _sessionLoaded = true;
    await storage.delete(_sessionKey);
  }

  Future<FamilyKeyRing?> keyRing(String familyId) async {
    final cached = _rings[familyId];
    if (cached != null) return cached;
    final raw = await storage.read('$_familyKeyPrefix$familyId');
    if (raw == null) return null;
    try {
      final ring = FamilyKeyRing.fromJson(jsonDecode(raw));
      if (ring != null) _rings[familyId] = ring;
      return ring;
    } on FormatException {
      return null;
    }
  }

  /// Stores [key] for [familyId]. An existing ring keeps its older keys and
  /// gains this one; [makeCurrent] chooses it for new writes.
  Future<FamilyKeyRing> addKey(
    String familyId,
    FamilyKey key, {
    bool makeCurrent = true,
  }) async {
    final id = await key.keyId();
    final existing = await keyRing(familyId);
    final ring = FamilyKeyRing(
      currentKeyId: makeCurrent || existing == null
          ? id
          : existing.currentKeyId,
      keys: {...?existing?.keys, id: key},
    );
    await storage.write(
      '$_familyKeyPrefix$familyId',
      jsonEncode(ring.toJson()),
    );
    _rings[familyId] = ring;
    return ring;
  }

  /// Adds older keys (from a key chain) without changing the current one.
  Future<FamilyKeyRing?> addOlderKeys(
    String familyId,
    Map<String, FamilyKey> keys,
  ) async {
    final existing = await keyRing(familyId);
    if (existing == null || keys.isEmpty) return existing;
    final ring = FamilyKeyRing(
      currentKeyId: existing.currentKeyId,
      keys: {...keys, ...existing.keys},
    );
    await storage.write(
      '$_familyKeyPrefix$familyId',
      jsonEncode(ring.toJson()),
    );
    _rings[familyId] = ring;
    return ring;
  }

  Future<void> deleteKey(String familyId) async {
    _rings.remove(familyId);
    await storage.delete('$_familyKeyPrefix$familyId');
  }

  /// Removes the session and every family key.
  Future<void> deleteAll() async {
    final all = await storage.readAll();
    for (final key in all.keys) {
      if (key == _sessionKey ||
          key == _deviceKey ||
          key.startsWith(_familyKeyPrefix)) {
        await storage.delete(key);
      }
    }
    _rings.clear();
    _device = null;
    _session = null;
    _sessionLoaded = true;
  }
}
