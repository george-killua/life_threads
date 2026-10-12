import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/router/app_router.dart';
import '../family_flows.dart';
import '../family_providers.dart';

/// Opens family invite links (from a message, the camera or a QR code):
/// sign-in if needed, a join confirmation, then the family wall. Other links
/// are left to their own listeners.
class FamilyInviteLinkListener extends ConsumerStatefulWidget {
  const FamilyInviteLinkListener({
    super.key,
    required this.child,
    this.navigatorKey,
  });

  final Widget child;

  /// The navigator to show screens on; the app's root navigator by default.
  final GlobalKey<NavigatorState>? navigatorKey;

  @override
  ConsumerState<FamilyInviteLinkListener> createState() =>
      _FamilyInviteLinkListenerState();
}

class _FamilyInviteLinkListenerState
    extends ConsumerState<FamilyInviteLinkListener> {
  StreamSubscription<Uri>? _subscription;
  var _joining = false;
  final _handled = <String>{};

  BuildContext? get _uiContext =>
      (widget.navigatorKey ?? AppRouter.rootNavigatorKey).currentContext;

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
    final service = ref.read(familyServiceOrNullProvider);
    if (service == null || !service.isInviteLink(uri)) return;
    final key = uri.toString();
    if (_joining || !_handled.add(key)) return;
    WidgetsBinding.instance.addPostFrameCallback((_) => _join(uri, key));
    WidgetsBinding.instance.scheduleFrame();
  }

  Future<void> _join(Uri uri, String key) async {
    final context = _uiContext;
    if (!mounted || context == null) {
      _handled.remove(key);
      return;
    }
    _joining = true;
    try {
      await joinFamilyFlow(context, uri);
    } finally {
      _joining = false;
      // The same link may be tapped again after a cancel or a failure; the
      // server rejects a used invite anyway.
      _handled.remove(key);
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
