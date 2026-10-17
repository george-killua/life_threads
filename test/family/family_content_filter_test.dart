import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/core/localization/legal_links.dart';
import 'package:life_threads/features/family/data/api_family_service.dart';
import 'package:life_threads/features/family/data/family_api_client.dart';
import 'package:life_threads/features/family/data/family_content_filter.dart';
import 'package:life_threads/features/family/data/family_local_cache.dart';
import 'package:life_threads/features/family/data/family_platform.dart';
import 'package:life_threads/features/family/data/family_secure_store.dart';
import 'package:life_threads/features/family/domain/family_models.dart';
import 'package:life_threads/features/memories/domain/memory_category.dart';
import 'package:life_threads/features/memories/domain/memory_feeling.dart';
import 'package:path/path.dart' as p;

import 'fake_family_server.dart';

/// App Review 1.2: objectionable words are filtered on the device before a
/// family wall post is encrypted and uploaded.
void main() {
  bool allows(String text) => FamilyContentFilter.allows([text]);

  group('filter', () {
    test('blocks slurs, sexual insults and threats in English, German and '
        'Arabic', () {
      for (final text in [
        'what a bitch',
        'You WHORE',
        'f u c k this',
        'fuuuuck',
        'f*ck you',
        'motherfuckers',
        'sh1t b1tch',
        'kill yourself',
        'I will kill you',
        'Du Hurensohn',
        'fick dich',
        'so eine Schlampe',
        'Missgeburt!',
        'heil hitler',
        'يا شرموطة',
        'والشرموطة',
        'ابن الكلب',
        'كسمك',
        'سأقتلك',
        'يا قَحْبَة',
      ]) {
        expect(allows(text), isFalse, reason: text);
      }
    });

    test('lets ordinary family memories through', () {
      for (final text in [
        'Picnic by the lake',
        'Grape harvest in Scunthorpe',
        'Our trip to Niger and Nigeria',
        'Shopping in Kassel, the cash desk (Kasse) was slow',
        'Grandpa killed it at karaoke',
        'The kids were dying of laughter',
        'Mama hat Pfannkuchen gemacht',
        'Wir waren im Schwarzwald',
        'Spicy food night',
        'Our cat Pussy-Willow',
        'Room 101, born 2023',
        'كسرة خبز مع جدتي',
        'بكس جدي القديم',
        'نيك صديقي من المدرسة',
        'عيد ميلاد سعيد يا أمي',
        'رحلة إلى البحر',
        '',
      ]) {
        expect(allows(text), isTrue, reason: text);
      }
    });

    test('null and empty fields are fine', () {
      expect(FamilyContentFilter.allows([null, '', 'Hello']), isTrue);
      expect(FamilyContentFilter.allows(['Hello', 'you slut']), isFalse);
    });
  });

  group('service', () {
    late FakeFamilyServer server;
    late Directory temp;

    setUp(() async {
      server = FakeFamilyServer();
      temp = await Directory.systemTemp.createTemp('family-filter-test');
    });

    tearDown(() async {
      await Future<void>.delayed(const Duration(milliseconds: 200));
      try {
        await temp.delete(recursive: true);
      } on FileSystemException {
        // Left for the OS to clean up.
      }
    });

    Future<ApiFamilyService> owner() async {
      final service = ApiFamilyService(
        api: FamilyApiClient(
          baseUrl: FakeFamilyServer.base,
          http: server,
          retryDelays: const [Duration.zero, Duration.zero],
        ),
        secrets: FamilySecrets(MemoryFamilySecretStorage()),
        cache: FamilyLocalCache(
          Future.value(Directory(p.join(temp.path, 'd'))),
        ),
        identity: FakeIdentity('owner'),
        purchases: FakePurchases(const FamilyStorePurchase.google('token')),
      );
      final account = await service.signInWithApple();
      await service.acceptTerms(account.requiredTermsVersion);
      await service.linkSubscription();
      return service;
    }

    FamilyMemoryDraft draft(String title, {String story = ''}) =>
        FamilyMemoryDraft(
          title: title,
          description: story,
          category: MemoryCategory.family,
          feeling: MemoryFeeling.warm,
          occurredAt: DateTime.utc(2024, 7, 1),
          locationLabel: '',
          newPhotoPaths: const [],
        );

    Matcher refused() => throwsA(
      isA<FamilyException>().having(
        (e) => e.code,
        'code',
        FamilyErrorCodes.contentNotAllowed,
      ),
    );

    test('a memory, wall name or display name with blocked words is never '
        'sent', () async {
      final own = await owner();
      await expectLater(own.createFamily('Hurensohn club'), refused());
      expect(server.families, isEmpty);

      final family = await own.createFamily('Sunday Table');
      await expectLater(
        own.addMemory(family.id, draft('Picnic', story: 'you bitch')),
        refused(),
      );
      await expectLater(own.renameFamily(family.id, 'fuck'), refused());
      await expectLater(own.setMyDisplayName(family.id, 'slut'), refused());
      expect(
        server.families[family.id]!.items.values.where(
          (i) => i.kind == 'memory',
        ),
        isEmpty,
      );

      final saved = await own.addMemory(family.id, draft('Picnic'));
      await expectLater(
        own.updateMemory(saved, draft('Picnic, kill yourself')),
        refused(),
      );
    });
  });

  test('legal pages open in the app language', () {
    expect(
      LegalLinks.termsFor(const Locale('de')).toString(),
      'https://gkcoding.dev/lifethreads/terms/de/',
    );
    expect(
      LegalLinks.privacyFor(const Locale('ar')).toString(),
      'https://gkcoding.dev/lifethreads/privacy/ar/',
    );
    expect(
      LegalLinks.termsFor(const Locale('en')).toString(),
      'https://gkcoding.dev/lifethreads/terms/',
    );
    expect(
      LegalLinks.privacyFor(const Locale('fr')).toString(),
      'https://gkcoding.dev/lifethreads/privacy/',
    );
  });
}
