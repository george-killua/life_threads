import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/backup/presentation/pages/archive_transfer_page.dart';
import '../../features/capsule/domain/memory_capsule_models.dart';
import '../../features/capsule/presentation/pages/capsule_cinema_page.dart';
import '../../features/family/presentation/family_routes.dart';
import '../../features/look_back/presentation/month_look_back_page.dart';
import '../../features/media/data/picked_memory_photo.dart';
import '../../features/memories/presentation/pages/add_memory_page.dart';
import '../../features/memories/presentation/pages/edit_memory_page.dart';
import '../../features/search/presentation/memory_search_page.dart';
import '../../features/memories/presentation/pages/manage_connections_page.dart';
import '../../features/memories/presentation/pages/memory_detail_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_gate.dart';
import '../../features/premium/domain/premium_feature.dart';
import '../../features/premium/presentation/pages/upgrade_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/wall/presentation/pages/themes_page.dart';
import '../../features/stories/presentation/pages/create_story_page.dart';
import '../../features/wall/presentation/pages/memory_wall_page.dart';
import '../../features/year_thread/presentation/pages/year_thread_page.dart';
import 'material_route.dart';
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
      materialRoute(
        path: RouteNames.home,
        builder: (context, state) => const OnboardingGate(),
      ),
      materialRoute(
        path: RouteNames.wall,
        builder: (context, state) => const MemoryWallPage(),
      ),
      materialRoute(
        path: RouteNames.settings,
        builder: (context, state) => const SettingsPage(),
      ),
      materialRoute(
        path: RouteNames.themes,
        builder: (context, state) => const ThemesPage(),
      ),
      materialRoute(
        path: RouteNames.search,
        builder: (context, state) => const MemorySearchPage(),
      ),
      materialRoute(
        path: RouteNames.backupData,
        builder: (context, state) => const BackupDataPage(),
      ),
      materialRoute(
        path: RouteNames.aboutHelp,
        builder: (context, state) => const AboutHelpPage(),
      ),
      materialRoute(
        path: RouteNames.homeWidgetSettings,
        builder: (context, state) => const HomeWidgetSettingsPage(),
      ),
      materialRoute(
        path: RouteNames.upgrade,
        builder: (context, state) => UpgradePage(
          feature: state.extra is PremiumFeature
              ? state.extra! as PremiumFeature
              : null,
        ),
      ),
      materialRoute(
        path: RouteNames.archiveTransfer,
        builder: (context, state) => const ArchiveTransferPage(),
      ),
      materialRoute(
        path: RouteNames.addMemory,
        builder: (context, state) {
          final extra = state.extra;
          final initialPhotos = extra is List<PickedMemoryPhoto>
              ? extra
              : const <PickedMemoryPhoto>[];
          return AddMemoryPage(
            initialPhotos: initialPhotos,
            // From the home screen widget's "Take photo".
            openCamera: state.uri.queryParameters['camera'] == '1',
            // From Thread of the Year: a memory for that year.
            initialDate: DateTime.tryParse(
              state.uri.queryParameters['date'] ?? '',
            ),
            toWall: state.uri.queryParameters['wall'],
          );
        },
      ),
      materialRoute(
        path: RouteNames.memoryDetail,
        builder: (context, state) =>
            MemoryDetailPage(memoryId: state.pathParameters['id']!),
      ),
      materialRoute(
        path: RouteNames.editMemory,
        builder: (context, state) => EditMemoryPage(
          memoryId: state.pathParameters['id']!,
          section: EditMemorySection.values
              .where((s) => s.name == state.uri.queryParameters['section'])
              .firstOrNull,
        ),
      ),
      materialRoute(
        path: RouteNames.manageConnections,
        builder: (context, state) =>
            ManageConnectionsPage(memoryId: state.pathParameters['id']!),
      ),
      materialRoute(
        path: RouteNames.capsuleCinema,
        // The cinema only makes sense for an import in progress.
        redirect: (context, state) =>
            state.extra is MemoryCapsuleImportDraft ? null : RouteNames.home,
        builder: (context, state) =>
            CapsuleCinemaPage(draft: state.extra! as MemoryCapsuleImportDraft),
      ),
      materialRoute(
        path: RouteNames.yearThread,
        builder: (context, state) => YearThreadPage(
          initialYear: int.tryParse(state.uri.queryParameters['year'] ?? ''),
        ),
      ),
      materialRoute(
        path: RouteNames.lookBack,
        builder: (context, state) => MonthLookBackPage(
          year: int.tryParse(state.uri.queryParameters['year'] ?? ''),
          month: int.tryParse(state.uri.queryParameters['month'] ?? ''),
        ),
      ),
      materialRoute(
        path: RouteNames.createStory,
        // extra: the id of the memory the story starts from, if any.
        builder: (context, state) => CreateStoryPage(
          initialMemoryId: state.extra is String
              ? state.extra! as String
              : null,
        ),
      ),
      ...familyRoutes,
    ],
  );
}
