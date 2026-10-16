// Regression tests from the 2026-10-16 whole-codebase bug hunt:
// family data layer, against the fake server.
import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/features/family/data/api_family_service.dart';
import 'package:life_threads/features/family/data/family_api_client.dart';
import 'package:life_threads/features/family/data/family_local_cache.dart';
import 'package:life_threads/features/family/data/family_platform.dart';
import 'package:life_threads/features/family/data/family_secure_store.dart';
import 'package:life_threads/features/family/domain/family_models.dart';
import 'package:life_threads/features/memories/domain/memory_category.dart';
import 'package:life_threads/features/memories/domain/memory_feeling.dart';
import 'package:path/path.dart' as p;

import '../family/fake_family_server.dart';

/// Wraps the fake server; a hook can intercept a request before it is sent.
class _HookHttp implements FamilyHttp {
  _HookHttp(this.inner);
  final FakeFamilyServer inner;
  Future<FamilyHttpResponse?> Function(FamilyHttpRequest r)? hook;

  @override
  Future<FamilyHttpResponse> send(FamilyHttpRequest request) async {
    final h = hook;
    if (h != null) {
      final res = await h(request);
      if (res != null) return res;
    }
    return inner.send(request);
  }

  @override
  void close() {}
}

class _Dev {
  _Dev(this.service, this.http, this.dir);
  final ApiFamilyService service;
  final _HookHttp http;
  final Directory dir;
}

void main() {
  late FakeFamilyServer server;
  late Directory temp;
  var n = 0;

  setUp(() async {
    server = FakeFamilyServer();
    temp = await Directory.systemTemp.createTemp('f1-family');
  });
  tearDown(() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    try {
      await temp.delete(recursive: true);
    } on FileSystemException {
      // ignore
    }
  });

  _Dev device(String subject) {
    final http = _HookHttp(server);
    final dir = Directory(p.join(temp.path, 'root', 'family_wall-${n++}'));
    final service = ApiFamilyService(
      api: FamilyApiClient(
        baseUrl: FakeFamilyServer.base,
        http: http,
        retryDelays: const [Duration.zero, Duration.zero],
      ),
      secrets: FamilySecrets(MemoryFamilySecretStorage()),
      cache: FamilyLocalCache(Future.value(dir)),
      identity: FakeIdentity(subject),
      purchases: FakePurchases(const FamilyStorePurchase.google('t')),
    );
    return _Dev(service, http, dir);
  }

  Future<_Dev> owner() async {
    final d = device('owner');
    final a = await d.service.signInWithApple();
    await d.service.acceptTerms(a.requiredTermsVersion);
    await d.service.linkSubscription();
    return d;
  }

  FamilyMemoryDraft draft(String title) => FamilyMemoryDraft(
    title: title,
    description: 'd',
    category: MemoryCategory.family,
    feeling: MemoryFeeling.warm,
    occurredAt: DateTime.utc(2024, 7, 1),
    locationLabel: '',
    latitude: null,
    longitude: null,
    newPhotoPaths: const [],
  );

  test('F1-01 a PUT retry after a network failure reports another '
      "device's write as a conflict, not as our success", () async {
    final phone = await owner();
    final family = await phone.service.createFamily('Fam');
    final memory = await phone.service.addMemory(family.id, draft('Original'));

    // Same account on a tablet (keys copied via invite of own family).
    final tablet = device('owner');
    await tablet.service.signInWithApple();
    await tablet.service.acceptInvite(
      await phone.service.createInvite(family.id),
    );
    await tablet.service.sync(family.id);
    final tabletCopy =
        (await tablet.service.watchMemories(family.id).first).single;

    // The phone's first PUT never reaches the server (connection refused);
    // meanwhile the tablet saves its own edit.
    var failed = false;
    phone.http.hook = (r) async {
      if (r.method == 'PUT' && !failed && r.uri.path.contains('/memories/')) {
        failed = true;
        await tablet.service.updateMemory(tabletCopy, draft('Tablet edit'));
        throw const SocketException('connection refused');
      }
      return null;
    };
    // The retry finds the tablet's version 2, not ours: a conflict, not a
    // save (the editor offers to reload and edit again).
    await expectLater(
      phone.service.updateMemory(memory, draft('Phone')),
      throwsA(
        isA<FamilyException>().having(
          (e) => e.code,
          'code',
          FamilyErrorCodes.versionConflict,
        ),
      ),
    );
    phone.http.hook = null;

    // After a sync the phone shows what the server holds.
    await phone.service.sync(family.id);
    final onPhone = (await phone.service.watchMemories(family.id).first).single;
    expect(
      onPhone.title,
      'Tablet edit',
      reason:
          'phone believes its edit "Phone" was saved, server kept the '
          'tablet edit; versions equal so sync never refetches',
    );
  });

  test('F1-02 photo ids from another member never reach outside the '
      'family cache', () async {
    final own = await owner();
    final family = await own.service.createFamily('Fam');
    final member = device('member');
    await member.service.signInWithGoogle();
    await member.service.acceptTerms('2026-10');
    await member.service.acceptInvite(
      await own.service.createInvite(family.id),
    );
    final m = await member.service.addMemory(family.id, draft('Bait'));
    // A modified client writes a record whose photo id walks out of the
    // owner's cache: <cache>/families/<id>/photos/../../../../victim.jpg
    final crafted = FamilyMemory(
      id: m.id,
      familyId: m.familyId,
      authorId: m.authorId,
      version: m.version,
      title: m.title,
      description: m.description,
      category: m.category,
      feeling: m.feeling,
      occurredAt: m.occurredAt,
      createdAt: m.createdAt,
      updatedAt: m.updatedAt,
      locationLabel: '',
      latitude: null,
      longitude: null,
      coverPhotoId: null,
      photoIds: const ['../../../../victim'],
      wallX: 0,
      wallY: 0,
      rotation: 0,
    );
    await member.service.moveMemory(crafted, 1, 1);

    // A file outside the family cache on the owner's device.
    final victim = File(p.join(temp.path, 'root', 'victim.jpg'));
    await victim.create(recursive: true);
    // The owner's photo cache exists once any family photo was viewed.
    await (await own.service.cache.photosDir(
      family.id,
    )).create(recursive: true);

    await own.service.sync(family.id);
    final onOwner = (await own.service.watchMemories(family.id).first).single;
    // The crafted id never becomes a file name.
    expect(onOwner.photoIds, isEmpty);
    // The owner moderates: deletes the member's memory.
    await own.service.deleteMemory(onOwner);
    expect(
      await victim.exists(),
      isTrue,
      reason: 'deleteMemory deleted a file outside the family cache',
    );
  });

  test('F1-03 leaving a family while a sync is in flight must not leave its '
      'decrypted memories on disk', () async {
    final own = await owner();
    final family = await own.service.createFamily('Fam');
    final member = device('member');
    await member.service.signInWithGoogle();
    await member.service.acceptTerms('2026-10');
    await member.service.acceptInvite(
      await own.service.createInvite(family.id),
    );
    await own.service.addMemory(family.id, draft('Private'));
    await Future<void>.delayed(const Duration(milliseconds: 100));

    // Hold the member's next /changes response until after leaving.
    final gate = Completer<void>();
    var held = false;
    member.http.hook = (r) async {
      if (!held && r.method == 'GET' && r.uri.path.endsWith('/changes')) {
        held = true;
        final res = await server.send(r);
        await gate.future;
        return res;
      }
      return null;
    };
    // Reset to cursor 0 so the page carries the memory.
    final syncing = member.service.sync(family.id).catchError((_) {});
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(held, isTrue);
    await member.service.leaveFamily(family.id);
    gate.complete();
    await syncing;
    await Future<void>.delayed(const Duration(milliseconds: 100));

    final file = File(
      p.join(member.dir.path, 'families', family.id, 'memories.json'),
    );
    expect(
      await file.exists(),
      isFalse,
      reason: 'left family, but its decrypted memories were written back',
    );
  });
}
