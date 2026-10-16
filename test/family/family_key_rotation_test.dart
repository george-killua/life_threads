import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/features/family/data/api_family_service.dart';
import 'package:life_threads/features/family/data/family_api_client.dart';
import 'package:life_threads/features/family/data/family_crypto.dart';
import 'package:life_threads/features/family/data/family_local_cache.dart';
import 'package:life_threads/features/family/data/family_platform.dart';
import 'package:life_threads/features/family/data/family_secure_store.dart';
import 'package:life_threads/features/family/domain/family_models.dart';
import 'package:life_threads/features/memories/domain/memory_category.dart';
import 'package:life_threads/features/memories/domain/memory_feeling.dart';
import 'package:path/path.dart' as p;

import 'fake_family_server.dart';

/// Key rotation after the member list shrinks: the owner's app switches the
/// family to a new key sealed only for the remaining members' devices.
void main() {
  group('crypto', () {
    test('a key sealed for one device opens only there', () async {
      final key = FamilyKey.generate();
      final keyId = await key.keyId();
      final phone = await FamilyDeviceKey.generate();
      final other = await FamilyDeviceKey.generate();
      const sealer = FamilyKeySealer();
      final sealed = await sealer.seal(
        key,
        recipientPublicKey: phone.publicKey,
        familyId: 'fam',
        keyId: keyId,
        accountId: 'acct',
        deviceId: phone.id,
      );
      final opened = await sealer.unseal(
        sealed,
        device: phone,
        familyId: 'fam',
        keyId: keyId,
        accountId: 'acct',
      );
      expect(opened.bytes, key.bytes);
      // Another device, another account or another family: no.
      for (final attempt in [
        () => sealer.unseal(
          sealed,
          device: other,
          familyId: 'fam',
          keyId: keyId,
          accountId: 'acct',
        ),
        () => sealer.unseal(
          sealed,
          device: phone,
          familyId: 'fam',
          keyId: keyId,
          accountId: 'someone-else',
        ),
        () => sealer.unseal(
          sealed,
          device: phone,
          familyId: 'other-fam',
          keyId: keyId,
          accountId: 'acct',
        ),
      ]) {
        await expectLater(attempt(), throwsA(isA<FamilyDecryptionException>()));
      }
    });

    test('a device key survives storage', () async {
      final device = await FamilyDeviceKey.generate();
      final restored = await FamilyDeviceKey.fromJson(
        jsonDecode(jsonEncode(device.toJson())),
      );
      expect(restored!.id, device.id);
      expect(restored.publicKey, device.publicKey);
    });

    test('the key chain brings back older keys; a newer ring still reads '
        'what the old key wrote', () async {
      final oldRing = await FamilyKeyRing.single(FamilyKey.generate());
      const cipher = FamilyCipher();
      final oldItem = await cipher.encrypt(
        utf8.encode('before'),
        ring: oldRing,
        familyId: 'fam',
        kind: FamilyCipherKinds.memory,
        id: 'm1',
      );
      final newRing = await FamilyKeyRing.single(FamilyKey.generate());
      final chain = await FamilyKeyChain.encrypt(
        oldRing,
        current: newRing,
        familyId: 'fam',
      );
      final older = await FamilyKeyChain.decrypt(
        chain,
        current: newRing,
        familyId: 'fam',
      );
      final merged = FamilyKeyRing(
        currentKeyId: newRing.currentKeyId,
        keys: {...older, ...newRing.keys},
      );
      final clear = await cipher.decrypt(
        oldItem,
        ring: merged,
        familyId: 'fam',
        kind: FamilyCipherKinds.memory,
        id: 'm1',
      );
      expect(utf8.decode(clear), 'before');
      // Without the new key the chain stays closed.
      await expectLater(
        FamilyKeyChain.decrypt(chain, current: oldRing, familyId: 'fam'),
        throwsA(isA<FamilyDecryptionException>()),
      );
    });
  });

  group('service', () {
    late FakeFamilyServer server;
    late Directory temp;

    setUp(() async {
      server = FakeFamilyServer();
      temp = await Directory.systemTemp.createTemp('family-rotation-test');
    });

    tearDown(() async {
      await Future<void>.delayed(const Duration(milliseconds: 200));
      try {
        await temp.delete(recursive: true);
      } on FileSystemException {
        // Left for the OS to clean up.
      }
    });

    var devices = 0;
    ApiFamilyService device(
      String subject, {
      MemoryFamilySecretStorage? storage,
    }) => ApiFamilyService(
      api: FamilyApiClient(
        baseUrl: FakeFamilyServer.base,
        http: server,
        retryDelays: const [Duration.zero, Duration.zero],
      ),
      secrets: FamilySecrets(storage ?? MemoryFamilySecretStorage()),
      cache: FamilyLocalCache(
        Future.value(Directory(p.join(temp.path, 'd${devices++}'))),
      ),
      identity: FakeIdentity(subject),
      purchases: FakePurchases(const FamilyStorePurchase.google('play-token')),
    );

    Future<ApiFamilyService> owner() async {
      final service = device('owner');
      final account = await service.signInWithApple();
      await service.acceptTerms(account.requiredTermsVersion);
      await service.linkSubscription();
      return service;
    }

    Future<ApiFamilyService> joined(
      String subject,
      ApiFamilyService inviter,
      String familyId,
    ) async {
      final service = device(subject);
      await service.signInWithGoogle();
      await service.acceptTerms(FakeFamilyServer.termsVersion);
      await service.acceptInvite(await inviter.createInvite(familyId));
      await service.sync(familyId);
      return service;
    }

    FamilyMemoryDraft draft(String title) => FamilyMemoryDraft(
      title: title,
      description: '',
      category: MemoryCategory.family,
      feeling: MemoryFeeling.warm,
      occurredAt: DateTime.utc(2024, 7, 1),
      locationLabel: '',
      newPhotoPaths: const [],
    );

    Future<List<String>> titles(ApiFamilyService s, String familyId) async {
      await s.sync(familyId);
      final list = await s.watchMemories(familyId).first;
      return [for (final m in list) m.title]..sort();
    }

    test('removing a member switches the family to a key only the others '
        'get', () async {
      final own = await owner();
      final family = await own.createFamily('Sunday Table');
      final stay = await joined('stay', own, family.id);
      final gone = await joined('gone', own, family.id);
      final goneAccount = (await gone.watchAccount().first)!.id;
      await own.addMemory(family.id, draft('Before'));
      final goneRing = (await gone.secrets.keyRing(family.id))!;

      await own.removeMember(family.id, goneAccount);

      final ownRing = (await own.secrets.keyRing(family.id))!;
      expect(ownRing.currentKeyId, isNot(goneRing.currentKeyId));
      expect(server.families[family.id]!.keyId, ownRing.currentKeyId);
      expect(server.families[family.id]!.rotationRequired, isFalse);

      await own.addMemory(family.id, draft('After'));
      // The member who stayed picks up the new key and reads old and new.
      expect(await titles(stay, family.id), ['After', 'Before']);
      expect(
        (await stay.secrets.keyRing(family.id))!.currentKeyId,
        ownRing.currentKeyId,
      );
      // The removed member's key can't open what was posted after.
      final after = server.families[family.id]!.items.values.firstWhere(
        (i) => i.kind == 'memory' && i.keyId == ownRing.currentKeyId,
      );
      await expectLater(
        const FamilyCipher().decrypt(
          after.bytes,
          ring: goneRing,
          familyId: family.id,
          kind: FamilyCipherKinds.memory,
          id: after.id,
        ),
        throwsA(isA<FamilyDecryptionException>()),
      );
      // The family name stays readable for those who stayed.
      final families = await stay.refreshFamilies();
      expect(families.single.name, 'Sunday Table');
    });

    test('a device that missed the rotation is asked for an invite; a new '
        'invite brings the current key and the older ones', () async {
      final own = await owner();
      final family = await own.createFamily('Fam');
      final phone = await joined('member', own, family.id);
      final gone = await joined('gone', own, family.id);
      await own.addMemory(family.id, draft('Old'));
      // The member's tablet: same account, never registered for this wall.
      final tabletStorage = MemoryFamilySecretStorage();
      final tablet = device('member', storage: tabletStorage);
      await tablet.signInWithGoogle();
      await tablet.secrets.addKey(
        family.id,
        (await phone.secrets.keyRing(family.id))!.currentKey,
      );
      await own.removeMember(family.id, (await gone.watchAccount().first)!.id);
      await own.addMemory(family.id, draft('New'));

      await expectLater(
        tablet.sync(family.id),
        throwsA(
          isA<FamilyException>().having(
            (e) => e.code,
            'code',
            FamilyErrorCodes.familyKeyMissing,
          ),
        ),
      );
      // Nothing was dropped while waiting for the key.
      expect(server.families[family.id]!.items.length, 2);

      await tablet.acceptInvite(await own.createInvite(family.id));
      expect(await titles(tablet, family.id), ['New', 'Old']);
      // A brand-new member also reads the old memory (key chain).
      final late = await joined('late', own, family.id);
      expect(await titles(late, family.id), ['New', 'Old']);
    });

    test('a device still writing with the old key picks up the new one and '
        'retries', () async {
      final own = await owner();
      final family = await own.createFamily('Fam');
      final member = await joined('member', own, family.id);
      final gone = await joined('gone', own, family.id);
      await own.removeMember(family.id, (await gone.watchAccount().first)!.id);
      // The member hasn't synced since: its cached family has no new key.
      final saved = await member.addMemory(family.id, draft('Written late'));
      final item = server.families[family.id]!.items['memory/${saved.id}']!;
      expect(item.keyId, server.families[family.id]!.keyId);
    });

    test('a device whose proof is not made with the family key gets no '
        'copy', () async {
      final own = await owner();
      final family = await own.createFamily('Fam');
      final member = await joined('member', own, family.id);
      final gone = await joined('gone', own, family.id);
      final memberId = (await member.watchAccount().first)!.id;
      // The server (or someone with its database) adds a device for the
      // member that it controls; it can't make the proof.
      final forged = await FamilyDeviceKey.generate();
      server.families[family.id]!.devices['$memberId/${forged.id}'] = (
        publicKey: forged.encodedPublicKey,
        proof: base64Url.encode(utf8.encode('not encrypted')),
      );
      await own.removeMember(family.id, (await gone.watchAccount().first)!.id);
      final fam = server.families[family.id]!;
      expect(fam.rotationRequired, isFalse);
      expect(fam.seals.keys.any((k) => k.endsWith('/${forged.id}')), isFalse);
      expect(fam.devices.containsKey('$memberId/${forged.id}'), isFalse);
      // The real device still got its copy.
      expect(await titles(member, family.id), isEmpty);
      expect(
        (await member.secrets.keyRing(family.id))!.currentKeyId,
        fam.keyId,
      );
    });

    test('works with a server that has no key rotation yet', () async {
      server.supportsKeys = false;
      final own = await owner();
      final family = await own.createFamily('Fam');
      final member = await joined('member', own, family.id);
      await own.addMemory(family.id, draft('Posted'));
      expect(await titles(member, family.id), ['Posted']);
    });

    test('offline at removal: the owner rotates on the next sync', () async {
      final own = await owner();
      final family = await own.createFamily('Fam');
      final gone = await joined('gone', own, family.id);
      final goneId = (await gone.watchAccount().first)!.id;
      // Removed from another of the owner's devices that can't rotate.
      server.families[family.id]!
        ..members.remove(goneId)
        ..memberGone(goneId)
        ..membersVersion += 1;
      expect(server.families[family.id]!.rotationRequired, isTrue);
      await own.sync(family.id);
      expect(server.families[family.id]!.rotationRequired, isFalse);
      expect(server.families[family.id]!.keyEpoch, 2);
    });
  });
}
