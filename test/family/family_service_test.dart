import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:life_threads/features/family/data/api_family_service.dart';
import 'package:life_threads/features/family/data/family_api_client.dart';
import 'package:life_threads/features/family/data/family_local_cache.dart';
import 'package:life_threads/features/family/data/family_platform.dart';
import 'package:life_threads/features/family/data/family_secure_store.dart';
import 'package:life_threads/features/family/domain/family_models.dart';
import 'package:life_threads/features/memories/domain/memory_category.dart';
import 'package:life_threads/features/memories/domain/memory_feeling.dart';
import 'package:path/path.dart' as p;

import 'fake_family_server.dart';

class _Device {
  _Device(this.service, this.storage, this.dir, this.identity);

  final ApiFamilyService service;
  final MemoryFamilySecretStorage storage;
  final Directory dir;
  final FakeIdentity identity;
}

void main() {
  late FakeFamilyServer server;
  late Directory temp;

  setUp(() async {
    server = FakeFamilyServer();
    temp = await Directory.systemTemp.createTemp('family-service-test');
  });

  tearDown(() async {
    // Background syncs may still be writing; let them settle first.
    await Future<void>.delayed(const Duration(milliseconds: 200));
    try {
      await temp.delete(recursive: true);
    } on FileSystemException {
      // Left for the OS to clean up.
    }
  });

  _Device device(String subject, {MemoryFamilySecretStorage? storage}) {
    final secrets = storage ?? MemoryFamilySecretStorage();
    final dir = Directory(
      p.join(temp.path, 'device-$subject-${server.requests.length}'),
    );
    final identity = FakeIdentity(subject);
    final service = ApiFamilyService(
      api: FamilyApiClient(
        baseUrl: FakeFamilyServer.base,
        http: server,
        retryDelays: const [Duration.zero, Duration.zero],
      ),
      secrets: FamilySecrets(secrets),
      cache: FamilyLocalCache(Future.value(dir)),
      identity: identity,
      purchases: FakePurchases(const FamilyStorePurchase.google('play-token')),
    );
    return _Device(service, secrets, dir, identity);
  }

  Future<_Device> premiumOwner([String subject = 'owner']) async {
    final owner = device(subject);
    final account = await owner.service.signInWithApple();
    expect(account.termsAccepted, isFalse);
    await owner.service.acceptTerms(account.requiredTermsVersion);
    final linked = await owner.service.linkSubscription();
    expect(linked.hasActiveSubscription, isTrue);
    return owner;
  }

  Future<String> photoFile(String name, int width, int height) async {
    final image = img.Image(width: width, height: height);
    img.fill(image, color: img.ColorRgb8(200, 120, 40));
    final file = File(p.join(temp.path, name));
    await file.writeAsBytes(img.encodePng(image));
    return file.path;
  }

  FamilyMemoryDraft draft(String title, {List<String> photos = const []}) =>
      FamilyMemoryDraft(
        title: title,
        description: 'Secret description of $title',
        category: MemoryCategory.family,
        feeling: MemoryFeeling.warm,
        occurredAt: DateTime.utc(2024, 7, 1),
        locationLabel: 'Vienna',
        latitude: 48.2,
        longitude: 16.37,
        newPhotoPaths: photos,
      );

  bool containsBytes(List<int> haystack, List<int> needle) {
    outer:
    for (var i = 0; i + needle.length <= haystack.length; i++) {
      for (var j = 0; j < needle.length; j++) {
        if (haystack[i + j] != needle[j]) continue outer;
      }
      return true;
    }
    return false;
  }

  test('create, invite, join, post with photo, sync on the other phone '
      'with only ciphertext on the wire', () async {
    final owner = await premiumOwner();
    final family = await owner.service.createFamily('The Kassihs');
    expect(family.name, 'The Kassihs');
    expect(family.role, FamilyRole.owner);
    await owner.service.setMyDisplayName(family.id, 'George');

    final invite = await owner.service.createInvite(family.id);
    expect(owner.service.isInviteLink(invite), isTrue);

    final member = device('member');
    await member.service.signInWithGoogle();
    await member.service.acceptTerms('2026-10');
    final joined = await member.service.acceptInvite(invite);
    expect(joined.id, family.id);
    expect(joined.name, 'The Kassihs');
    expect(joined.role, FamilyRole.member);

    final photo = await photoFile('big.png', 3000, 1500);
    final memory = await member.service.addMemory(
      family.id,
      draft('Summer picnic', photos: [photo]),
    );
    expect(memory.photoIds, hasLength(1));
    expect(memory.coverPhotoId, memory.photoIds.single);
    expect(memory.version, 1);

    await owner.service.sync(family.id);
    final memories = await owner.service.watchMemories(family.id).first;
    expect(memories.single.title, 'Summer picnic');
    expect(memories.single.description, 'Secret description of Summer picnic');
    expect(memories.single.latitude, 48.2);
    expect(memories.single.authorId, memory.authorId);

    final file = await owner.service.photoFile(
      family.id,
      memory.photoIds.single,
    );
    final decoded = img.decodeJpg(await file.readAsBytes())!;
    expect(decoded.width, 2048);
    expect(decoded.height, 1024);

    final members = await owner.service.members(family.id);
    expect(members.map((m) => m.displayName), containsAll(['George', '']));

    // Nothing readable left the device: no names, titles, JPEGs or keys.
    final key = invite.fragment.split('k=').last;
    for (final request in server.requests) {
      final body = request.body ?? const <int>[];
      final text = utf8.decode(body, allowMalformed: true);
      expect(text, isNot(contains('Kassihs')));
      expect(text, isNot(contains('Summer picnic')));
      expect(text, isNot(contains('Secret description')));
      expect(text, isNot(contains('George')));
      expect(text, isNot(contains(key)));
      expect(request.uri.toString(), isNot(contains(key)));
      expect(containsBytes(body, const [0xFF, 0xD8, 0xFF]), isFalse);
      if (request.method == 'PUT' &&
          (request.uri.path.contains('/memories/') ||
              request.uri.path.contains('/photos/'))) {
        expect(request.headers['x-key-id'], isNotNull);
        expect(body.first, 1); // envelope version
      }
    }
    final accept = server.requests.singleWhere(
      (r) => r.uri.path.endsWith('/invites/accept'),
    );
    expect(jsonDecode(utf8.decode(accept.body!)), {
      'token': invite.fragment.split('&').first.substring(2),
    });
  });

  test('sync pages through changes, applies tombstones and members', () async {
    final owner = await premiumOwner();
    final family = await owner.service.createFamily('Fam');
    final member = device('member');
    await member.service.signInWithGoogle();
    await member.service.acceptTerms('2026-10');
    await member.service.acceptInvite(
      await owner.service.createInvite(family.id),
    );

    final added = <FamilyMemory>[];
    for (var i = 0; i < 5; i++) {
      added.add(await owner.service.addMemory(family.id, draft('Memory $i')));
    }

    server.maxPageSize = 2;
    server.requests.clear();
    await member.service.sync(family.id);
    expect(
      server.requests.where((r) => r.uri.path.endsWith('/changes')),
      hasLength(3),
    );
    var list = await member.service.watchMemories(family.id).first;
    expect(list.map((m) => m.title), [for (var i = 0; i < 5; i++) 'Memory $i']);

    // Owner deletes one, edits another; a third member joins.
    await owner.service.deleteMemory(added[1]);
    await owner.service.updateMemory(added[2], draft('Edited'));
    final third = device('third');
    await third.service.signInWithGoogle();
    await third.service.acceptInvite(
      await owner.service.createInvite(family.id),
    );

    server.requests.clear();
    await member.service.sync(family.id);
    list = await member.service.watchMemories(family.id).first;
    expect(list.map((m) => m.title), [
      'Memory 0',
      'Edited',
      'Memory 3',
      'Memory 4',
    ]);
    expect(list[1].version, 2);
    // membersVersion changed: the family and its members were refetched.
    expect(
      server.requests.where(
        (r) => r.method == 'GET' && r.uri.path.endsWith(family.id),
      ),
      isNotEmpty,
    );
    expect(await member.service.members(family.id), hasLength(3));
  });

  test('cursor_reset resyncs from 0 and drops what the server lost', () async {
    final owner = await premiumOwner();
    final family = await owner.service.createFamily('Fam');
    final a = await owner.service.addMemory(family.id, draft('Kept'));
    final b = await owner.service.addMemory(family.id, draft('Lost'));
    final viewer = device('viewer');
    await viewer.service.signInWithGoogle();
    await viewer.service.acceptInvite(
      await owner.service.createInvite(family.id),
    );
    await viewer.service.sync(family.id);
    expect(await viewer.service.watchMemories(family.id).first, hasLength(2));

    // The server was restored from an older backup: b never existed.
    server.families[family.id]!.items.remove('memory/${b.id}');
    server.resetNextChanges = true;
    server.requests.clear();
    await viewer.service.sync(family.id);

    final sinces = server.requests
        .where((r) => r.uri.path.endsWith('/changes'))
        .map((r) => r.uri.queryParameters['since'])
        .toList();
    // The stored cursor was refused, then the sync started over from 0.
    expect(sinces.first, isNot('0'));
    expect(sinces, contains('0'));
    final list = await viewer.service.watchMemories(family.id).first;
    expect(list.map((m) => m.id), [a.id]);
  });

  test(
    'a stale edit is a version_conflict; a lost PUT answer recovers',
    () async {
      final storage = MemoryFamilySecretStorage();
      final phone = device('owner', storage: storage);
      await phone.service.signInWithApple();
      await phone.service.acceptTerms('2026-10');
      await phone.service.linkSubscription();
      final family = await phone.service.createFamily('Fam');
      final memory = await phone.service.addMemory(family.id, draft('One'));

      // The same account on a tablet with the same key edits first.
      final tablet = device('owner', storage: storage);
      await tablet.service.signInWithApple();
      await tablet.service.sync(family.id);
      final onTablet =
          (await tablet.service.watchMemories(family.id).first).single;
      await tablet.service.updateMemory(onTablet, draft('Tablet edit'));

      await expectLater(
        phone.service.updateMemory(memory, draft('Phone edit')),
        throwsA(
          isA<FamilyException>().having(
            (e) => e.code,
            'code',
            'version_conflict',
          ),
        ),
      );

      // The PUT reaches the server but the answer is lost; the retry sees
      // version + 1 and reports success.
      server.loseNextPutResponse = true;
      final moved = await tablet.service.addMemory(family.id, draft('Two'));
      expect(moved.version, 1);
      expect(
        server.families[family.id]!.items['memory/${moved.id}']!.version,
        1,
      );
    },
  );

  test('server error codes surface as FamilyException codes', () async {
    final user = device('user');
    await user.service.signInWithApple();
    await expectLater(
      user.service.createFamily('Fam'),
      throwsA(
        isA<FamilyException>().having(
          (e) => e.code,
          'code',
          'terms_not_accepted',
        ),
      ),
    );
    await user.service.acceptTerms('2026-10');
    await expectLater(
      user.service.createFamily('Fam'),
      throwsA(
        isA<FamilyException>().having(
          (e) => e.code,
          'code',
          'subscription_required',
        ),
      ),
    );
    await expectLater(
      user.service.createFamily('x' * 800),
      throwsA(
        isA<FamilyException>().having((e) => e.code, 'code', 'name_too_long'),
      ),
    );
    await expectLater(
      user.service.acceptInvite(
        Uri.parse('https://lifethreads.gkcoding.dev/family/join#t=x'),
      ),
      throwsA(
        isA<FamilyException>().having((e) => e.code, 'code', 'invite_invalid'),
      ),
    );

    final noPurchase = device('other');
    (noPurchase.service.purchases as FakePurchases).purchase = null;
    await noPurchase.service.signInWithApple();
    await expectLater(
      noPurchase.service.linkSubscription(),
      throwsA(
        isA<FamilyException>().having(
          (e) => e.code,
          'code',
          'no_purchase_found',
        ),
      ),
    );
  });

  test('offline: reads come from the cache, writes fail clearly', () async {
    final owner = await premiumOwner();
    final family = await owner.service.createFamily('Fam');
    await owner.service.addMemory(family.id, draft('Cached'));

    server.offline = true;
    final restarted = device('owner', storage: owner.storage);
    // Same cache directory as before the "restart".
    final service = ApiFamilyService(
      api: FamilyApiClient(
        baseUrl: FakeFamilyServer.base,
        http: server,
        retryDelays: const [],
      ),
      secrets: FamilySecrets(owner.storage),
      cache: FamilyLocalCache(Future.value(owner.dir)),
      identity: restarted.identity,
      purchases: FakePurchases(),
    );
    final account = await service.watchAccount().first;
    expect(account?.id, isNotNull);
    expect((await service.watchFamilies().first).single.name, 'Fam');
    final memories = await service.watchMemories(family.id).first;
    expect(memories.single.title, 'Cached');

    await expectLater(
      service.sync(family.id),
      throwsA(
        isA<FamilyException>().having((e) => e.code, 'code', 'network_error'),
      ),
    );
    expect(
      await service.watchSyncStatus(family.id).first,
      FamilySyncStatus.offline,
    );
    await expectLater(
      service.addMemory(family.id, draft('Offline')),
      throwsA(
        isA<FamilyException>().having((e) => e.code, 'code', 'network_error'),
      ),
    );
  });

  test('blocking hides a member; unblocking resyncs them back', () async {
    final owner = await premiumOwner();
    final family = await owner.service.createFamily('Fam');
    final member = device('member');
    final memberAccount = await member.service.signInWithGoogle();
    await member.service.acceptTerms('2026-10');
    await member.service.acceptInvite(
      await owner.service.createInvite(family.id),
    );
    await member.service.addMemory(family.id, draft('From member'));
    await owner.service.addMemory(family.id, draft('From owner'));
    await owner.service.sync(family.id);
    expect(await owner.service.watchMemories(family.id).first, hasLength(2));

    await owner.service.block(memberAccount.id);
    var list = await owner.service.watchMemories(family.id).first;
    expect(list.map((m) => m.title), ['From owner']);
    await owner.service.sync(family.id);
    list = await owner.service.watchMemories(family.id).first;
    expect(list.map((m) => m.title), ['From owner']);
    expect(
      (await owner.service.members(
        family.id,
      )).singleWhere((m) => m.accountId == memberAccount.id).isBlockedByMe,
      isTrue,
    );

    await owner.service.unblock(memberAccount.id);
    await owner.service.sync(family.id);
    list = await owner.service.watchMemories(family.id).first;
    expect(list.map((m) => m.title), ['From member', 'From owner']);

    await owner.service.report(
      familyId: family.id,
      target: FamilyReportTarget.memory,
      targetId: list.first.id,
      reason: FamilyReportReason.selfHarm,
    );
    final report = jsonDecode(utf8.decode(server.requests.last.body!)) as Map;
    expect(report['reason'], 'self_harm');
    expect(report['targetType'], 'memory');
  });

  test('a removed member loses the family on the next sync', () async {
    final owner = await premiumOwner();
    final family = await owner.service.createFamily('Fam');
    final member = device('member');
    final memberAccount = await member.service.signInWithGoogle();
    await member.service.acceptInvite(
      await owner.service.createInvite(family.id),
    );
    await member.service.sync(family.id);

    await owner.service.removeMember(family.id, memberAccount.id);
    await expectLater(
      member.service.sync(family.id),
      throwsA(
        isA<FamilyException>().having(
          (e) => e.code,
          'code',
          'family_not_found',
        ),
      ),
    );
    expect(await member.service.watchFamilies().first, isEmpty);
    expect(await member.service.secrets.keyRing(family.id), isNull);
  });

  test('deleting the account clears server account, cache, photos, keys '
      'and session', () async {
    final owner = await premiumOwner();
    final family = await owner.service.createFamily('Fam');
    final photo = await photoFile('p.png', 100, 80);
    final memory = await owner.service.addMemory(
      family.id,
      draft('Mine', photos: [photo]),
    );
    final cachedPhoto = await owner.service.photoFile(
      family.id,
      memory.photoIds.single,
    );
    expect(await cachedPhoto.exists(), isTrue);
    expect(owner.storage.values, isNotEmpty);

    final accounts = <FamilyAccount?>[];
    final sub = owner.service.watchAccount().listen(accounts.add);
    await pumpEventQueue();

    await owner.service.deleteAccount();
    await pumpEventQueue();

    expect(server.accounts, isEmpty);
    expect(server.families, isEmpty);
    expect(owner.storage.values, isEmpty);
    expect(await owner.dir.exists(), isFalse);
    expect(await cachedPhoto.exists(), isFalse);
    expect(accounts.last, isNull);
    expect(owner.identity.signOuts, 1);
    expect(await owner.service.watchFamilies().first, isEmpty);
    await sub.cancel();
  });

  test(
    'a new phone of an existing member gets the key from an invite',
    () async {
      final owner = await premiumOwner();
      final family = await owner.service.createFamily('Fam');
      final member = device('member');
      await member.service.signInWithGoogle();
      await member.service.acceptInvite(
        await owner.service.createInvite(family.id),
      );

      final newPhone = device('member');
      await newPhone.service.signInWithGoogle();
      expect(
        (await newPhone.service.refreshFamilies()).single.name,
        isEmpty, // no key yet
      );
      final again = await newPhone.service.acceptInvite(
        await owner.service.createInvite(family.id),
      );
      expect(again.name, 'Fam');
    },
  );

  test('an invite whose key does not open the family is refused', () async {
    final owner = await premiumOwner();
    final family = await owner.service.createFamily('Fam');
    final invite = await owner.service.createInvite(family.id);
    final forged = invite.replace(
      fragment: invite.fragment.replaceFirst(
        RegExp(r'k=[^&]+'),
        'k=${base64Url.encode(List.filled(32, 7)).replaceAll('=', '')}',
      ),
    );
    final member = device('member');
    await member.service.signInWithGoogle();
    await expectLater(
      member.service.acceptInvite(forged),
      throwsA(
        isA<FamilyException>().having(
          (e) => e.code,
          'code',
          'invite_key_invalid',
        ),
      ),
    );
    expect(await member.service.secrets.keyRing(family.id), isNull);
  });
}
