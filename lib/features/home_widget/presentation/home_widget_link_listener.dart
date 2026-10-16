import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/router/app_router.dart';
import '../../memories/data/memory_repository.dart';
import '../../wall/data/current_wall.dart';

/// Opens the memory a home screen widget shows when it is tapped
/// (`lifethreads://memory/<id>`). A tap on an empty widget
/// (`lifethreads://wall`) just opens the app. Other links are left to their
/// own listeners.
///
/// The widget shows memories from every wall, so the wall screen behind the
/// memory switches to the wall it hangs on: going back shows it there.
class HomeWidgetLinkListener extends ConsumerStatefulWidget {
  const HomeWidgetLinkListener({super.key, required this.child});

  final Widget child;

  /// The memory a widget link opens, or null for any other link.
  static String? memoryIdFrom(Uri uri) {
    if (uri.scheme != 'lifethreads' || uri.host != 'memory') return null;
    final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
    return segments.length == 1 ? segments.single : null;
  }

  @override
  ConsumerState<HomeWidgetLinkListener> createState() =>
      _HomeWidgetLinkListenerState();
}

class _HomeWidgetLinkListenerState
    extends ConsumerState<HomeWidgetLinkListener> {
  StreamSubscription<Uri>? _subscription;
  String? _lastLink;
  DateTime? _lastOpened;

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> _startListening() async {
    try {
      final appLinks = AppLinks();
      _subscription = appLinks.uriLinkStream.listen(_handleLink);
      final initial = await appLinks.getInitialLink();
      if (initial != null) _handleLink(initial);
    } catch (_) {
      // Deep-link plugins are unavailable in widget tests and some desktop runs.
    }
  }

  void _handleLink(Uri uri) {
    final memoryId = HomeWidgetLinkListener.memoryIdFrom(uri);
    if (memoryId == null) return;
    // The launch link can arrive both as the initial link and on the stream.
    final now = DateTime.now();
    final last = _lastOpened;
    if (_lastLink == uri.toString() &&
        last != null &&
        now.difference(last) < const Duration(seconds: 2)) {
      return;
    }
    _lastLink = uri.toString();
    _lastOpened = now;
    WidgetsBinding.instance.addPostFrameCallback((_) => _open(memoryId));
    WidgetsBinding.instance.scheduleFrame();
  }

  Future<void> _open(String memoryId) async {
    try {
      final state = await ref.read(memoryRepositoryProvider.future);
      final memory = state.findEvent(memoryId);
      if (memory != null && ref.read(currentWallProvider) != memory.wallId) {
        await ref.read(currentWallProvider.notifier).select(memory.wallId);
      }
    } catch (_) {
      // The memory screen shows its own message when it can't load.
    }
    if (mounted) AppRouter.router.push('/memories/$memoryId');
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
