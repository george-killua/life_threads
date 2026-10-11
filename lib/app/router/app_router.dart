import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/backup/presentation/pages/archive_transfer_page.dart';
import '../../features/capsule/domain/memory_capsule_models.dart';
import '../../features/capsule/presentation/pages/capsule_cinema_page.dart';
import '../../features/media/data/picked_memory_photo.dart';
import '../../features/memories/presentation/pages/add_memory_page.dart';
import '../../features/memories/presentation/pages/edit_memory_page.dart';
import '../../features/memories/presentation/pages/manage_connections_page.dart';
import '../../features/memories/presentation/pages/memory_detail_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_gate.dart';
import '../../features/premium/presentation/pages/upgrade_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/wall/presentation/pages/memory_wall_page.dart';
import 'route_names.dart';

class AppRouter {
  const AppRouter._();

  static final rootNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: RouteNames.home,
    // Unknown locations (e.g. a share link the OS also hands to the router)
    // fall back to the wall instead of a dead-end error page. Share links
    // themselves are handled by MemoryCapsuleDeepLinkListener.
    onException: (context, state, router) => router.go(RouteNames.home),
    routes: [
      GoRoute(
        path: RouteNames.home,
        builder: (context, state) => const OnboardingGate(),
      ),
      GoRoute(
        path: RouteNames.wall,
        builder: (context, state) => const MemoryWallPage(),
      ),
      GoRoute(
        path: RouteNames.settings,
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: RouteNames.upgrade,
        builder: (context, state) => const UpgradePage(),
      ),
      GoRoute(
        path: RouteNames.archiveTransfer,
        builder: (context, state) => const ArchiveTransferPage(),
      ),
      GoRoute(
        path: RouteNames.addMemory,
        builder: (context, state) {
          final extra = state.extra;
          final initialPhotos = extra is List<PickedMemoryPhoto>
              ? extra
              : const <PickedMemoryPhoto>[];
          return AddMemoryPage(initialPhotos: initialPhotos);
        },
      ),
      GoRoute(
        path: RouteNames.memoryDetail,
        builder: (context, state) =>
            MemoryDetailPage(memoryId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: RouteNames.editMemory,
        builder: (context, state) =>
            EditMemoryPage(memoryId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: RouteNames.manageConnections,
        builder: (context, state) =>
            ManageConnectionsPage(memoryId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: RouteNames.capsuleCinema,
        // The cinema only makes sense for an import in progress.
        redirect: (context, state) =>
            state.extra is MemoryCapsuleImportDraft ? null : RouteNames.home,
        builder: (context, state) =>
            CapsuleCinemaPage(draft: state.extra! as MemoryCapsuleImportDraft),
      ),
    ],
  );
}
