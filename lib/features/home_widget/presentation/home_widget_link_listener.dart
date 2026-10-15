import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';

import '../../../app/router/app_router.dart';

/// Opens the memory a home screen widget shows when it is tapped
/// (`lifethreads://memory/<id>`). A tap on an empty widget
/// (`lifethreads://wall`) just opens the app. Other links are left to their
/// own listeners.
class HomeWidgetLinkListener extends StatefulWidget {
  const HomeWidgetLinkListener({super.key, required this.child});

  final Widget child;

  /// The memory a widget link opens, or null for any other link.
  static String? memoryIdFrom(Uri uri) {
    if (uri.scheme != 'lifethreads' || uri.host != 'memory') return null;
    final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
    return segments.length == 1 ? segments.single : null;
  }

  @override
  State<HomeWidgetLinkListener> createState() => _HomeWidgetLinkListenerState();
}

class _HomeWidgetLinkListenerState extends State<HomeWidgetLinkListener> {
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) AppRouter.router.push('/memories/$memoryId');
    });
    WidgetsBinding.instance.scheduleFrame();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
