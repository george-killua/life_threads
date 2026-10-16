// End-to-end test against the real family API (Node, from the server repo).
//
// Skipped unless LIFETHREADS_FAMILY_SERVER_DIR points at the server's
// `backend` directory (with node_modules installed) and `node` is on PATH:
//
//   LIFETHREADS_FAMILY_SERVER_DIR=/path/to/gk_coding_website/backend \
//     flutter test test/family/integration
//
// It binds a local port, so it needs a sandbox that allows that.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cryptography/cryptography.dart';
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

final _serverDir = Platform.environment['LIFETHREADS_FAMILY_SERVER_DIR'];

class _Launcher {
  _Launcher._(this.process, this.baseUrl, this.dataDir, this._lines);

  final Process process;
  final String baseUrl;
  final String dataDir;
  final StreamIterator<String> _lines;

  static Future<_Launcher> start(String backend) async {
    final script = p.join(
      Directory.current.path,
      'test',
      'family',
      'integration',
      'family_server_launcher.js',
    );
    final process = await Process.start('node', [script, backend]);
    process.stderr.transform(utf8.decoder).listen(stderr.write);
    final lines = StreamIterator(
      process.stdout.transform(utf8.decoder).transform(const LineSplitter()),
    );
    if (!await lines.moveNext().timeout(const Duration(seconds: 30))) {
      throw StateError('The family server did not start.');
    }
    final hello = jsonDecode(lines.current) as Map<String, Object?>;
    return _Launcher._(
      process,
      hello['baseUrl'] as String,
      hello['dataDir'] as String,
      lines,
    );
  }

  Future<Map<String, Object?>> command(String line) async {
    process.stdin.writeln(line);
    await _lines.moveNext();
    return jsonDecode(_lines.current) as Map<String, Object?>;
  }

  Future<void> stop() async {
    process.stdin.writeln('quit');
    await process.exitCode.timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        process.kill();
        return -1;
      },
    );
  }
}

/// Sign-in with ID tokens signed by the launcher's test issuer.
class _TestIdentity implements FamilyIdentityProvider {
  _TestIdentity(this.launcher, this.subject);

  final _Launcher launcher;
  final String subject;

  @override
  Future<FamilyIdentityToken> signInWithApple() async {
    // Like the real flow: Apple's token carries SHA-256(nonce).
    const nonce = 'integration-nonce-0123456789';
    final hash = await Sha256().hash(utf8.encode(nonce));
    final hex = hash.bytes
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join();
    final reply = await launcher.command('token apple $subject $hex');
    return FamilyIdentityToken(
      idToken: reply['idToken'] as String,
      nonce: nonce,
    );
  }

  @override
  Future<FamilyIdentityToken> signInWithGoogle() async {
    final reply = await launcher.command('token google $subject');
    return FamilyIdentityToken(idToken: reply['idToken'] as String);
  }

  @override
  Future<void> signOut() async {}
}

class _Purchases implements FamilyPurchaseSource {
  _Purchases(this.token);

  final String token;

  @override
  Future<FamilyStorePurchase?> premiumPurchase() async =>
      FamilyStorePurchase.google(token);
}

void main() {
  late _Launcher launcher;
  late Directory temp;

  setUpAll(() async {
    if (_serverDir == null) return;
    launcher = await _Launcher.start(_serverDir!);
    temp = await Directory.systemTemp.createTemp('family-it');
  });

  tearDownAll(() async {
    if (_serverDir == null) return;
    await launcher.stop();
    await temp.delete(recursive: true);
  });

  ApiFamilyService device(String name, {String purchase = 'none'}) {
    return ApiFamilyService(
      api: FamilyApiClient(baseUrl: launcher.baseUrl, http: IoFamilyHttp()),
      secrets: FamilySecrets(MemoryFamilySecretStorage()),
      cache: FamilyLocalCache(Future.value(Directory(p.join(temp.path, name)))),
      identity: _TestIdentity(launcher, 'subject-$name'),
      purchases: _Purchases(purchase),
    );
  }

  test(
    'create, invite, join, post a photo, sync, delete accounts',
    () async {
      await launcher.command('purchase it-play-token');

      // Owner: Apple sign-in with nonce, terms, Premium, a family.
      final owner = device('owner', purchase: 'it-play-token');
      var ownerAccount = await owner.signInWithApple();
      expect(ownerAccount.hasActiveSubscription, isFalse);
      ownerAccount = await owner.acceptTerms(ownerAccount.requiredTermsVersion);
      ownerAccount = await owner.linkSubscription();
      expect(ownerAccount.hasActiveSubscription, isTrue);
      final family = await owner.createFamily('Integration family');
      await owner.setMyDisplayName(family.id, 'Owner');
      final invite = await owner.createInvite(family.id);
      expect(owner.isInviteLink(invite), isTrue);

      // Member: Google sign-in, joins with the link.
      final member = device('member');
      final memberAccount = await member.signInWithGoogle();
      await member.acceptTerms(memberAccount.requiredTermsVersion);
      final joined = await member.acceptInvite(invite);
      expect(joined.name, 'Integration family');
      await expectLater(
        member.acceptInvite(invite),
        throwsA(isA<FamilyException>()),
      );

      // Member posts a memory with a photo.
      final image = img.Image(width: 2600, height: 1300);
      img.fill(image, color: img.ColorRgb8(30, 90, 160));
      final photoPath = p.join(temp.path, 'photo.png');
      await File(photoPath).writeAsBytes(img.encodePng(image));
      final memory = await member.addMemory(
        family.id,
        FamilyMemoryDraft(
          title: 'Integration picnic',
          description: 'Plaintext that must not reach the server',
          category: MemoryCategory.family,
          feeling: MemoryFeeling.proud,
          occurredAt: DateTime.utc(2025, 5, 4),
          locationLabel: 'Prater',
          newPhotoPaths: [photoPath],
        ),
      );

      // Owner syncs and sees it, decrypted.
      await owner.sync(family.id);
      final seen = await owner.watchMemories(family.id).first;
      expect(seen.single.title, 'Integration picnic');
      expect(seen.single.authorId, memberAccount.id);
      final photo = await owner.photoFile(family.id, memory.photoIds.single);
      final decoded = img.decodeJpg(await photo.readAsBytes())!;
      expect(decoded.width, 2048);
      final members = await owner.members(family.id);
      expect(members, hasLength(2));
      expect(
        members.firstWhere((m) => m.accountId == ownerAccount.id).displayName,
        'Owner',
      );

      // The server only stores ciphertext.
      final stored = await Directory(
        launcher.dataDir,
      ).list(recursive: true).where((e) => e is File).cast<File>().toList();
      expect(stored.where((f) => f.path.endsWith('.bin')), hasLength(2));
      for (final file in stored) {
        final text = latin1.decode(await file.readAsBytes());
        expect(text, isNot(contains('Integration picnic')));
        expect(text, isNot(contains('Plaintext that must not')));
        expect(text, isNot(contains('Integration family')));
      }

      // The member deletes their account: their content goes for everyone.
      await member.deleteAccount();
      expect(await member.watchAccount().first, isNull);
      await owner.sync(family.id);
      expect(await owner.watchMemories(family.id).first, isEmpty);
      expect(await owner.members(family.id), hasLength(1));

      // The owner deletes theirs: the family is gone from the server.
      await owner.deleteAccount();
      final ownerAgain = device('owner-again');
      await ownerAgain.signInWithApple();
      expect(await ownerAgain.refreshFamilies(), isEmpty);
    },
    skip: _serverDir == null
        ? 'Set LIFETHREADS_FAMILY_SERVER_DIR to the server backend directory.'
        : false,
    timeout: const Timeout(Duration(minutes: 2)),
  );

  test(
    'removing a member rotates the key; the others keep reading',
    () async {
      await launcher.command('purchase it-play-token-rotation');
      final owner = device('rot-owner', purchase: 'it-play-token-rotation');
      final account = await owner.signInWithApple();
      await owner.acceptTerms(account.requiredTermsVersion);
      await owner.linkSubscription();
      final family = await owner.createFamily('Rotation family');

      Future<ApiFamilyService> join(String name) async {
        final member = device(name);
        final a = await member.signInWithGoogle();
        await member.acceptTerms(a.requiredTermsVersion);
        await member.acceptInvite(await owner.createInvite(family.id));
        return member;
      }

      final stay = await join('rot-stay');
      final gone = await join('rot-gone');
      final goneId = (await gone.watchAccount().first)!.id;
      FamilyMemoryDraft draft(String title) => FamilyMemoryDraft(
        title: title,
        description: '',
        category: MemoryCategory.family,
        feeling: MemoryFeeling.warm,
        occurredAt: DateTime.utc(2025, 1, 1),
        locationLabel: '',
        newPhotoPaths: const [],
      );
      await owner.addMemory(family.id, draft('Before removal'));
      final oldKey = (await owner.secrets.keyRing(family.id))!.currentKeyId;

      await owner.removeMember(family.id, goneId);
      final newKey = (await owner.secrets.keyRing(family.id))!.currentKeyId;
      expect(newKey, isNot(oldKey));

      await owner.addMemory(family.id, draft('After removal'));
      await stay.sync(family.id);
      final titles = [
        for (final m in await stay.watchMemories(family.id).first) m.title,
      ]..sort();
      expect(titles, ['After removal', 'Before removal']);
      expect((await stay.secrets.keyRing(family.id))!.currentKeyId, newKey);
      expect((await stay.refreshFamilies()).single.name, 'Rotation family');

      // A late joiner reads both, through the key chain.
      final late = await join('rot-late');
      await late.sync(family.id);
      expect(await late.watchMemories(family.id).first, hasLength(2));

      await owner.deleteAccount();
    },
    skip: _serverDir == null
        ? 'Set LIFETHREADS_FAMILY_SERVER_DIR to the server backend directory.'
        : false,
    timeout: const Timeout(Duration(minutes: 2)),
  );
}
