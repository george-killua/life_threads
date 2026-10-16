import 'package:go_router/go_router.dart';

import '../../../app/router/material_route.dart';
import '../../../app/router/route_names.dart';
import 'pages/family_account_page.dart';
import 'pages/family_memory_detail_page.dart';
import 'pages/family_memory_editor_page.dart';
import 'pages/family_settings_page.dart';
import 'pages/family_wall_page.dart';
import 'pages/family_walls_page.dart';

/// The family wall screens. "new" comes before ":memoryId" so it is not
/// read as a memory id.
final familyRoutes = <RouteBase>[
  materialRoute(
    path: RouteNames.familyWalls,
    builder: (context, state) => const FamilyWallsPage(),
  ),
  materialRoute(
    path: RouteNames.familyAccount,
    builder: (context, state) => const FamilyAccountPage(),
  ),
  materialRoute(
    path: RouteNames.familyWall,
    builder: (context, state) =>
        FamilyWallPage(familyId: state.pathParameters['familyId']!),
  ),
  materialRoute(
    path: RouteNames.familySettings,
    builder: (context, state) =>
        FamilySettingsPage(familyId: state.pathParameters['familyId']!),
  ),
  materialRoute(
    path: RouteNames.familyAddMemory,
    builder: (context, state) =>
        FamilyMemoryEditorPage(familyId: state.pathParameters['familyId']!),
  ),
  materialRoute(
    path: RouteNames.familyMemoryDetail,
    builder: (context, state) => FamilyMemoryDetailPage(
      familyId: state.pathParameters['familyId']!,
      memoryId: state.pathParameters['memoryId']!,
    ),
  ),
  materialRoute(
    path: RouteNames.familyEditMemory,
    builder: (context, state) => FamilyMemoryEditorPage(
      familyId: state.pathParameters['familyId']!,
      memoryId: state.pathParameters['memoryId']!,
    ),
  ),
];
