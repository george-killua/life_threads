// The app lock: on only after the phone confirms the owner; locked on
// start and after a minute in the background.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/features/app_lock/app_lock.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeAuth implements AppLockAuth {
  bool available = true;
  bool answer = true;
  int asked = 0;

  @override
  Future<bool> isAvailable() async => available;

  @override
  Future<bool> authenticate(String reason) async {
    asked++;
    return answer;
  }
}

Future<ProviderContainer> _container(_FakeAuth auth) async {
  final container = ProviderContainer(
    overrides: [appLockAuthProvider.overrideWithValue(auth)],
  );
  container.listen(appLockProvider, (_, _) {});
  for (var i = 0; i < 5 && !container.read(appLockProvider).ready; i++) {
    await Future<void>.delayed(Duration.zero);
  }
  return container;
}

void main() {
  test('turning the lock on asks the phone first', () async {
    SharedPreferences.setMockInitialValues({});
    final auth = _FakeAuth()..answer = false;
    final container = await _container(auth);
    final lock = container.read(appLockProvider.notifier);

    expect(await lock.setEnabled(true, reason: 'r'), isFalse);
    expect(container.read(appLockProvider).enabled, isFalse);

    auth.answer = true;
    expect(await lock.setEnabled(true, reason: 'r'), isTrue);
    expect(container.read(appLockProvider).enabled, isTrue);
    expect(container.read(appLockProvider).locked, isFalse);
    container.dispose();
  });

  test('a phone without Face ID or passcode cannot turn it on', () async {
    SharedPreferences.setMockInitialValues({});
    final auth = _FakeAuth()..available = false;
    final container = await _container(auth);
    expect(
      await container
          .read(appLockProvider.notifier)
          .setEnabled(true, reason: 'r'),
      isFalse,
    );
    expect(auth.asked, 0);
    container.dispose();
  });

  test('locked on start, and unlocked by the owner', () async {
    SharedPreferences.setMockInitialValues({'app_lock_enabled': true});
    final auth = _FakeAuth()..answer = false;
    final container = await _container(auth);
    expect(container.read(appLockProvider).locked, isTrue);

    await container.read(appLockProvider.notifier).unlock('r');
    expect(container.read(appLockProvider).locked, isTrue);
    auth.answer = true;
    await container.read(appLockProvider.notifier).unlock('r');
    expect(container.read(appLockProvider).locked, isFalse);
    container.dispose();
  });

  test('a quick switch away stays open; a long one locks again', () async {
    SharedPreferences.setMockInitialValues({'app_lock_enabled': true});
    final container = await _container(_FakeAuth());
    final lock = container.read(appLockProvider.notifier);
    await lock.unlock('r');

    lock
      ..appPaused()
      ..appResumed();
    expect(container.read(appLockProvider).locked, isFalse);

    // Back after longer than relockAfter.
    lock.appPaused();
    await Future<void>.delayed(Duration.zero);
    lock.debugBackgroundedAt = DateTime.now().subtract(
      AppLockController.relockAfter,
    );
    lock.appResumed();
    expect(container.read(appLockProvider).locked, isTrue);
    container.dispose();
  });
}
