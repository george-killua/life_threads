import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A [GoRoute] whose screen is a [MaterialPage]: the platform's transition
/// and, on iOS, swipe from the left edge to go back.
///
/// go_router 18 looks for the `MaterialApp` of the separate material_ui
/// package, which isn't the app's `MaterialApp` on this Flutter version.
/// Without this it falls back to pages with no transition and no back
/// gesture.
GoRoute materialRoute({
  required String path,
  required Widget Function(BuildContext context, GoRouterState state) builder,
  GoRouterRedirect? redirect,
}) {
  return GoRoute(
    path: path,
    redirect: redirect,
    pageBuilder: (context, state) => MaterialPage<void>(
      key: state.pageKey,
      name: state.name ?? state.path,
      arguments: <String, String>{
        ...state.pathParameters,
        ...state.uri.queryParameters,
      },
      restorationId: state.pageKey.value,
      child: builder(context, state),
    ),
  );
}
