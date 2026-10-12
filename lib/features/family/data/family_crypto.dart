import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

/// A family's symmetric key. It is created on the owner's device, stored in
/// secure storage and shared only inside invite links (URL fragment).
class FamilyKey {
  FamilyKey(List<int> bytes) : bytes = Uint8List.fromList(bytes) {
    if (bytes.length != keyLength) {
      throw ArgumentError.value(bytes.length, 'bytes', 'must be 32 bytes');
    }
  }

  static const keyLength = 32;

  /// A new random 256-bit key.
  factory FamilyKey.generate([Random? random]) {
    final source = random ?? Random.secure();
    return FamilyKey(List<int>.generate(keyLength, (_) => source.nextInt(256)));
  }

  /// Parses the base64url form used in invite links (padding optional).
  static FamilyKey? tryParse(String value) {
    try {
      final bytes = base64Url.decode(base64Url.normalize(value.trim()));
      return bytes.length == keyLength ? FamilyKey(bytes) : null;
    } on FormatException {
      return null;
    }
  }

  final Uint8List bytes;

  /// Unpadded base64url, safe in URL fragments.
  String encode() => base64Url.encode(bytes).replaceAll('=', '');

  /// A short id derived from the key, sent as `X-Key-Id` and embedded in
  /// every envelope so a later key rotation can tell keys apart. Derived
  /// (not random) so every member computes the same id from the shared key.
  Future<String> keyId() async {
    final hash = await Sha256().hash([...utf8.encode(_keyIdLabel), ...bytes]);
    return base64Url.encode(hash.bytes.sublist(0, 9));
  }

  static const _keyIdLabel = 'lifethreads-family-key-id:';
}

/// The keys this device holds for one family: the current key (used for
/// new writes) and older keys still needed to read existing items.
class FamilyKeyRing {
  FamilyKeyRing({required this.currentKeyId, required this.keys});

  static Future<FamilyKeyRing> single(FamilyKey key) async {
    final id = await key.keyId();
    return FamilyKeyRing(currentKeyId: id, keys: {id: key});
  }

  final String currentKeyId;
  final Map<String, FamilyKey> keys;

  FamilyKey get currentKey => keys[currentKeyId]!;

  Map<String, Object?> toJson() => {
    'current': currentKeyId,
    'keys': {for (final e in keys.entries) e.key: e.value.encode()},
  };

  static FamilyKeyRing? fromJson(Object? json) {
    if (json is! Map) return null;
    final current = json['current'];
    final raw = json['keys'];
    if (current is! String || raw is! Map) return null;
    final keys = <String, FamilyKey>{};
    for (final entry in raw.entries) {
      final key = entry.value is String
          ? FamilyKey.tryParse(entry.value as String)
          : null;
      if (entry.key is String && key != null) keys[entry.key as String] = key;
    }
    if (!keys.containsKey(current)) return null;
    return FamilyKeyRing(currentKeyId: current, keys: keys);
  }
}

class FamilyDecryptionException implements Exception {
  const FamilyDecryptionException(this.message);

  final String message;

  @override
  String toString() => 'FamilyDecryptionException: $message';
}

/// The encrypted envelope used for every family item and string:
///
/// ```
/// byte 0       format version (1)
/// byte 1       key id length L (1-64)
/// bytes 2..    key id (ASCII, L bytes)
/// next 12      AES-GCM nonce (random)
/// next n       ciphertext
/// last 16      AES-GCM tag
/// ```
///
/// AES-256-GCM, with associated data
/// `lifethreads-family/v1/<familyId>/<kind>/<id>` so the server cannot move
/// a ciphertext to another item, family or field without decryption failing.
class FamilyCipher {
  const FamilyCipher();

  static const formatVersion = 1;
  static const nonceLength = 12;
  static const macLength = 16;

  static List<int> associatedData(String familyId, String kind, String id) =>
      utf8.encode('lifethreads-family/v1/$familyId/$kind/$id');

  Future<Uint8List> encrypt(
    List<int> clear, {
    required FamilyKeyRing ring,
    required String familyId,
    required String kind,
    required String id,
  }) async {
    final keyId = ring.currentKeyId;
    final keyIdBytes = ascii.encode(keyId);
    final box = await AesGcm.with256bits().encrypt(
      clear,
      secretKey: SecretKey(ring.currentKey.bytes),
      nonce: AesGcm.with256bits().newNonce(),
      aad: associatedData(familyId, kind, id),
    );
    final out = BytesBuilder(copy: false)
      ..addByte(formatVersion)
      ..addByte(keyIdBytes.length)
      ..add(keyIdBytes)
      ..add(box.nonce)
      ..add(box.cipherText)
      ..add(box.mac.bytes);
    return out.toBytes();
  }

  /// The key id written in an envelope, or null when it is malformed.
  static String? keyIdOf(List<int> envelope) {
    if (envelope.length < 2 || envelope[0] != formatVersion) return null;
    final length = envelope[1];
    if (length < 1 || envelope.length < 2 + length) return null;
    try {
      return ascii.decode(envelope.sublist(2, 2 + length));
    } on FormatException {
      return null;
    }
  }

  Future<Uint8List> decrypt(
    List<int> envelope, {
    required FamilyKeyRing ring,
    required String familyId,
    required String kind,
    required String id,
  }) async {
    final keyId = keyIdOf(envelope);
    if (keyId == null) {
      throw const FamilyDecryptionException('Unknown envelope format.');
    }
    final key = ring.keys[keyId];
    if (key == null) {
      throw FamilyDecryptionException('Missing key $keyId.');
    }
    final start = 2 + envelope[1];
    if (envelope.length < start + nonceLength + macLength) {
      throw const FamilyDecryptionException('Envelope is truncated.');
    }
    final nonce = envelope.sublist(start, start + nonceLength);
    final cipherText = envelope.sublist(
      start + nonceLength,
      envelope.length - macLength,
    );
    final mac = Mac(envelope.sublist(envelope.length - macLength));
    try {
      final clear = await AesGcm.with256bits().decrypt(
        SecretBox(cipherText, nonce: nonce, mac: mac),
        secretKey: SecretKey(key.bytes),
        aad: associatedData(familyId, kind, id),
      );
      return Uint8List.fromList(clear);
    } on SecretBoxAuthenticationError {
      throw const FamilyDecryptionException('Authentication failed.');
    }
  }

  /// Encrypts a short string (family name, member profile) as base64url.
  Future<String> encryptString(
    String value, {
    required FamilyKeyRing ring,
    required String familyId,
    required String kind,
    required String id,
  }) async {
    final bytes = await encrypt(
      utf8.encode(value),
      ring: ring,
      familyId: familyId,
      kind: kind,
      id: id,
    );
    return base64Url.encode(bytes);
  }

  Future<String> decryptString(
    String value, {
    required FamilyKeyRing ring,
    required String familyId,
    required String kind,
    required String id,
  }) async {
    final List<int> bytes;
    try {
      bytes = base64Url.decode(base64Url.normalize(value));
    } on FormatException {
      throw const FamilyDecryptionException('Not base64.');
    }
    final clear = await decrypt(
      bytes,
      ring: ring,
      familyId: familyId,
      kind: kind,
      id: id,
    );
    return utf8.decode(clear);
  }
}

/// Associated-data kinds. Items use the server's kinds; strings use their
/// own so a name can never be swapped for a profile or a record.
abstract final class FamilyCipherKinds {
  static const memory = 'memory';
  static const photo = 'photo';
  static const familyName = 'family-name';
  static const profile = 'profile';
}
