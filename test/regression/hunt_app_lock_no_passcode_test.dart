// Regression tests from the 2026-10-16 whole-codebase bug hunt:
// the lock is on, then the phone's passcode/Face ID is removed. The app must
// not stay locked for good (the switch to turn the lock off is behind it).
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/features/app_lock/app_lock.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _NoPasscodeAuth implements AppLockAuth {
  @override
  Future<bool> isAvailable() async => false; // isDeviceSupported() == false
  @override
  Future<bool> authenticate(String reason) async => false; // throws → false
}

void main() {
  test('a phone without a lock any more can still open the app', () async {
    SharedPreferences.setMockInitialValues({'app_lock_enabled': true});
    final container = ProviderContainer(
      overrides: [appLockAuthProvider.overrideWithValue(_NoPasscodeAuth())],
    );
    container.listen(appLockProvider, (_, _) {});
    for (var i = 0; i < 5 && !container.read(appLockProvider).ready; i++) {
      await Future<void>.delayed(Duration.zero);
    }
    expect(container.read(appLockProvider).locked, isTrue);
    for (var i = 0; i < 3; i++) {
      await container.read(appLockProvider.notifier).unlock('r');
    }
    expect(
      container.read(appLockProvider).locked,
      isFalse,
      reason: 'permanently locked out: no passcode, no recovery path',
    );
  });
}
