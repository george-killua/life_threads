// Creating a wall through its name dialog: the dialog's text field must
// outlive the closing animation (it crashed with "_dependents.isEmpty").
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/features/family/presentation/widgets/wall_switcher.dart';
import 'package:life_threads/features/memories/data/memory_repository.dart';
import 'package:life_threads/features/premium/data/premium_entitlement_controller.dart';
import 'package:life_threads/features/premium/domain/premium_entitlement.dart';
import 'package:life_threads/l10n/generated/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _Premium extends PremiumEntitlementController {
  @override
  Future<PremiumEntitlement> build() async =>
      const PremiumEntitlement(isPremium: true, isMockUnlocked: true);
}

class _Walls extends MemoryRepository {
  final created = <String>[];

  @override
  Future<MemoryState> build() async => const MemoryState(
    events: [],
    connections: [],
    photos: [],
    people: [],
    wallItems: [],
  );

  @override
  Future<String> createWall(String name) async {
    created.add(name);
    return 'w1';
  }
}

void main() {
  testWidgets('a new wall is named in a dialog that closes cleanly', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final repo = _Walls();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          memoryRepositoryProvider.overrideWith(() => repo),
          premiumEntitlementProvider.overrideWith(_Premium.new),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => createNewWall(context),
                child: const Text('go'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('go'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Travel 2025');
    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(repo.created, ['Travel 2025']);
    expect(find.byType(AlertDialog), findsNothing);
  });
}
