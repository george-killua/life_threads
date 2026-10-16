import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/localization/app_localizations_x.dart';
import 'app_lock.dart';

/// Covers the app while it is locked, and blurs it in the app switcher when
/// the lock is on.
class AppLockGate extends ConsumerStatefulWidget {
  const AppLockGate({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<AppLockGate> createState() => _AppLockGateState();
}

class _AppLockGateState extends ConsumerState<AppLockGate>
    with WidgetsBindingObserver {
  var _inBackground = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final lock = ref.read(appLockProvider.notifier);
    switch (state) {
      case AppLifecycleState.inactive || AppLifecycleState.hidden:
        setState(() => _inBackground = true);
      case AppLifecycleState.paused:
        lock.appPaused();
      case AppLifecycleState.resumed:
        lock.appResumed();
        setState(() => _inBackground = false);
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final lock = ref.watch(appLockProvider);
    // While locked (or not yet known) the app underneath must not be read
    // or activated by VoiceOver/TalkBack or a keyboard either.
    final covered = !lock.ready || lock.locked;
    return Stack(
      children: [
        ExcludeSemantics(
          excluding: covered,
          child: ExcludeFocus(excluding: covered, child: widget.child),
        ),
        if (!lock.ready)
          // The setting is being read: show nothing yet, not the memories.
          Positioned.fill(child: ColoredBox(color: AppColors.wallInk))
        else if (lock.locked)
          const Positioned.fill(child: _LockScreen())
        else if (lock.enabled && _inBackground)
          // What the app switcher shows.
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
              child: ColoredBox(
                color: AppColors.wallInk.withValues(alpha: 0.55),
              ),
            ),
          ),
      ],
    );
  }
}

class _LockScreen extends ConsumerStatefulWidget {
  const _LockScreen();

  @override
  ConsumerState<_LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<_LockScreen> {
  @override
  void initState() {
    super.initState();
    // Ask right away, as other locked apps do.
    WidgetsBinding.instance.addPostFrameCallback((_) => _unlock());
  }

  void _unlock() {
    if (!mounted) return;
    ref.read(appLockProvider.notifier).unlock(context.l10n.appLockReason);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Material(
      color: AppColors.wallInk,
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock_rounded, color: AppColors.gold, size: 54),
                const SizedBox(height: 18),
                Semantics(
                  header: true,
                  child: Text(
                    l10n.appLockLockedTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(height: 26),
                FilledButton.icon(
                  key: const ValueKey('app-lock-unlock'),
                  onPressed: _unlock,
                  icon: const Icon(Icons.face_rounded),
                  label: Text(l10n.appLockUnlock),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
