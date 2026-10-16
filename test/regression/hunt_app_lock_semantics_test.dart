// Regression tests from the 2026-10-16 whole-codebase bug hunt:
// the memories under the lock screen must not be readable or activatable by
// VoiceOver/TalkBack.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/features/app_lock/app_lock.dart';
import 'package:life_threads/features/app_lock/app_lock_gate.dart';
import 'package:life_threads/l10n/generated/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _PendingAuth implements AppLockAuth {
  @override
  Future<bool> isAvailable() async => true;
  @override
  Future<bool> authenticate(String reason) => Completer<bool>().future;
}

void main() {
  testWidgets('locked app hides memories from accessibility', (tester) async {
    final handle = tester.ensureSemantics();
    SharedPreferences.setMockInitialValues({'app_lock_enabled': true});
    var opened = 0;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appLockAuthProvider.overrideWithValue(_PendingAuth())],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => AppLockGate(child: child!),
          home: Scaffold(
            body: TextButton(
              onPressed: () => opened++,
              child: const Text('Secret diary memory'),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.byKey(const ValueKey('app-lock-unlock')), findsOneWidget);

    // Nothing under the lock is in the accessibility tree, so a screen
    // reader can neither read nor tap it.
    expect(find.bySemanticsLabel(RegExp('Secret diary memory')), findsNothing);
    expect(opened, 0);
    handle.dispose();
  });
}
