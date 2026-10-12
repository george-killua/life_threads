import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/features/family/data/family_crypto.dart';
import 'package:life_threads/features/family/data/family_invite_link.dart';

void main() {
  const cipher = FamilyCipher();

  group('FamilyCipher', () {
    test('round-trips and writes the documented envelope', () async {
      final ring = await FamilyKeyRing.single(FamilyKey.generate());
      final clear = utf8.encode('{"title":"Grandma\'s garden"}');
      final envelope = await cipher.encrypt(
        clear,
        ring: ring,
        familyId: 'fam1',
        kind: 'memory',
        id: 'm1',
      );

      expect(envelope[0], FamilyCipher.formatVersion);
      expect(FamilyCipher.keyIdOf(envelope), ring.currentKeyId);
      expect(
        envelope.length,
        2 + ring.currentKeyId.length + 12 + clear.length + 16,
      );
      expect(
        utf8.decode(envelope, allowMalformed: true),
        isNot(contains('Grandma')),
      );

      final decrypted = await cipher.decrypt(
        envelope,
        ring: ring,
        familyId: 'fam1',
        kind: 'memory',
        id: 'm1',
      );
      expect(decrypted, clear);
    });

    test('refuses tampering, other items, other keys', () async {
      final ring = await FamilyKeyRing.single(FamilyKey.generate());
      final envelope = await cipher.encrypt(
        [1, 2, 3],
        ring: ring,
        familyId: 'fam1',
        kind: 'photo',
        id: 'p1',
      );

      Future<void> expectFails(
        List<int> bytes, {
        FamilyKeyRing? withRing,
        String id = 'p1',
        String kind = 'photo',
      }) => expectLater(
        cipher.decrypt(
          bytes,
          ring: withRing ?? ring,
          familyId: 'fam1',
          kind: kind,
          id: id,
        ),
        throwsA(isA<FamilyDecryptionException>()),
      );

      final flipped = [...envelope]..[envelope.length - 20] ^= 1;
      await expectFails(flipped);
      await expectFails(envelope, id: 'p2');
      await expectFails(envelope, kind: 'memory');
      await expectFails(
        envelope,
        withRing: await FamilyKeyRing.single(FamilyKey.generate()),
      );
      await expectFails(envelope.sublist(0, 10));
    });

    test('key ids are derived from the key and survive JSON', () async {
      final key = FamilyKey.generate();
      final again = FamilyKey.tryParse(key.encode())!;
      expect(await again.keyId(), await key.keyId());
      expect(await FamilyKey.generate().keyId(), isNot(await key.keyId()));
      expect(await key.keyId(), matches(RegExp(r'^[A-Za-z0-9_-]{12}$')));

      final ring = await FamilyKeyRing.single(key);
      final restored = FamilyKeyRing.fromJson(
        jsonDecode(jsonEncode(ring.toJson())),
      )!;
      expect(restored.currentKeyId, ring.currentKeyId);
      expect(restored.currentKey.bytes, key.bytes);
    });

    test('strings round-trip as base64url', () async {
      final ring = await FamilyKeyRing.single(FamilyKey.generate());
      final encrypted = await cipher.encryptString(
        'Die Müllers',
        ring: ring,
        familyId: '',
        kind: FamilyCipherKinds.familyName,
        id: '',
      );
      expect(encrypted, matches(RegExp(r'^[A-Za-z0-9_=-]+$')));
      expect(
        await cipher.decryptString(
          encrypted,
          ring: ring,
          familyId: '',
          kind: FamilyCipherKinds.familyName,
          id: '',
        ),
        'Die Müllers',
      );
    });
  });

  group('FamilyInviteLink', () {
    const token = 'lti_abcdefghijklmnopqrstuvwxyz012345';
    const familyId = 'fam00000000000000000001';

    test('adds the key to the server URL fragment and parses back', () {
      final key = FamilyKey.generate();
      final link = FamilyInviteLink.withKey(
        'https://lifethreads.gkcoding.dev/family/join#t=$token&f=$familyId',
        key,
      );

      expect(link.scheme, 'https');
      expect(link.host, 'lifethreads.gkcoding.dev');
      expect(link.path, '/family/join');
      expect(link.query, isEmpty);
      // The key is only in the fragment, which is never sent to a server.
      expect(link.removeFragment().toString(), isNot(contains(key.encode())));
      expect(link.fragment, contains('k=${key.encode()}'));

      final parsed = FamilyInviteLink.tryParse(link)!;
      expect(parsed.token, token);
      expect(parsed.familyId, familyId);
      expect(parsed.key.bytes, key.bytes);
      expect(FamilyInviteLink.tryParse(Uri.parse(link.toString())), isNotNull);
    });

    test('rejects links that are not complete invites', () {
      final key = FamilyKey.generate().encode();
      Uri link(String fragment, {String host = 'lifethreads.gkcoding.dev'}) =>
          Uri.parse('https://$host/family/join#$fragment');

      expect(FamilyInviteLink.tryParse(link('t=$token&f=$familyId')), isNull);
      expect(
        FamilyInviteLink.tryParse(link('t=$token&f=$familyId&k=short')),
        isNull,
      );
      expect(
        FamilyInviteLink.tryParse(link('t=bad&f=$familyId&k=$key')),
        isNull,
      );
      expect(
        FamilyInviteLink.tryParse(
          link('t=$token&f=$familyId&k=$key', host: 'evil.example'),
        ),
        isNull,
      );
      expect(
        FamilyInviteLink.tryParse(
          Uri.parse(
            'https://lifethreads.gkcoding.dev/share/x#t=$token&f=$familyId&k=$key',
          ),
        ),
        isNull,
      );
      expect(
        FamilyInviteLink.tryParse(link('t=$token&f=$familyId&k=$key')),
        isNotNull,
      );
    });
  });
}
