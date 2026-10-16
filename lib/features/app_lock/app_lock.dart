import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Face ID, Touch ID, fingerprint or the phone's passcode.
abstract class AppLockAuth {
  /// Whether the phone can check who is holding it at all.
  Future<bool> isAvailable();

  /// Asks the phone to check; true when it is the owner.
  Future<bool> authenticate(String reason);
}

final appLockAuthProvider = Provider<AppLockAuth>(
  (ref) => PlatformAppLockAuth(),
);

class PlatformAppLockAuth implements AppLockAuth {
  final _auth = LocalAuthentication();

  @override
  Future<bool> isAvailable() async {
    try {
      return await _auth.isDeviceSupported();
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> authenticate(String reason) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        // Face ID first, the passcode when it fails or isn't set up.
        persistAcrossBackgrounding: true,
      );
    } catch (_) {
      return false;
    }
  }
}

@immutable
class AppLockState {
  const AppLockState({
    required this.ready,
    required this.enabled,
    required this.locked,
  });

  /// False until the setting is read; the app stays covered until then.
  final bool ready;
  final bool enabled;
  final bool locked;

  AppLockState copyWith({bool? ready, bool? enabled, bool? locked}) =>
      AppLockState(
        ready: ready ?? this.ready,
        enabled: enabled ?? this.enabled,
        locked: locked ?? this.locked,
      );
}

final appLockProvider = NotifierProvider<AppLockController, AppLockState>(
  AppLockController.new,
);

/// The app lock: on start, and after LifeThreads was in the background for
/// [relockAfter], the memories stay hidden until the phone confirms it is
/// the owner.
class AppLockController extends Notifier<AppLockState> {
  static const _enabledKey = 'app_lock_enabled';

  /// Back within this time, the app opens without asking again.
  static const relockAfter = Duration(minutes: 1);

  DateTime? _backgroundedAt;

  /// When the app went to the background; for tests.
  @visibleForTesting
  set debugBackgroundedAt(DateTime value) => _backgroundedAt = value;
  bool _authenticating = false;

  @override
  AppLockState build() {
    unawaited(_load());
    return const AppLockState(ready: false, enabled: false, locked: false);
  }

  Future<void> _load() async {
    final preferences = await SharedPreferences.getInstance();
    final enabled = preferences.getBool(_enabledKey) ?? false;
    state = AppLockState(ready: true, enabled: enabled, locked: enabled);
  }

  /// Turns the lock on (after the phone confirms the owner) or off.
  /// Returns false when turning it on failed or the phone has no lock.
  Future<bool> setEnabled(bool enabled, {required String reason}) async {
    final auth = ref.read(appLockAuthProvider);
    if (enabled) {
      if (!await auth.isAvailable()) return false;
      if (!await _check(reason)) return false;
    }
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_enabledKey, enabled);
    state = state.copyWith(enabled: enabled, locked: false);
    return true;
  }

  /// Asks the phone to unlock the app.
  Future<void> unlock(String reason) async {
    if (!state.locked) return;
    if (!await ref.read(appLockAuthProvider).isAvailable()) {
      // The phone's passcode and Face ID were removed: nothing can unlock the
      // app any more, and the switch to turn the lock off is behind it. The
      // lock only ever borrowed the phone's lock, so it turns itself off.
      final preferences = await SharedPreferences.getInstance();
      await preferences.setBool(_enabledKey, false);
      state = state.copyWith(enabled: false, locked: false);
      return;
    }
    if (await _check(reason)) state = state.copyWith(locked: false);
  }

  Future<bool> _check(String reason) async {
    if (_authenticating) return false;
    _authenticating = true;
    try {
      return await ref.read(appLockAuthProvider).authenticate(reason);
    } finally {
      _authenticating = false;
    }
  }

  void appPaused() {
    // The Face ID prompt itself pauses the app; that doesn't count.
    if (_authenticating) return;
    _backgroundedAt = DateTime.now();
  }

  void appResumed() {
    final since = _backgroundedAt;
    _backgroundedAt = null;
    if (!state.enabled || since == null) return;
    if (DateTime.now().difference(since) >= relockAfter) {
      state = state.copyWith(locked: true);
    }
  }
}
