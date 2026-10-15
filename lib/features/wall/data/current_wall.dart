import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../memories/data/memory_repository.dart';

/// Which of one's own walls is on screen: null for "My wall", or the id of
/// a named wall. Remembered across launches.
final currentWallProvider = NotifierProvider<CurrentWallController, String?>(
  CurrentWallController.new,
);

class CurrentWallController extends Notifier<String?> {
  static const _key = 'current_wall_id';

  @override
  String? build() {
    unawaited(_load());
    return null;
  }

  Future<void> _load() async {
    final saved = (await SharedPreferences.getInstance()).getString(_key);
    if (saved != null) state = saved;
  }

  Future<void> select(String? wallId) async {
    state = wallId;
    final preferences = await SharedPreferences.getInstance();
    if (wallId == null) {
      await preferences.remove(_key);
    } else {
      await preferences.setString(_key, wallId);
    }
  }
}

/// The wall new memories, notes and nails go to: the current one if it
/// still exists, else "My wall" (null).
String? activeWallId(WidgetRef ref) {
  final id = ref.read(currentWallProvider);
  final walls = ref.read(memoryRepositoryProvider).asData?.value.walls;
  return walls != null && walls.any((wall) => wall.id == id) ? id : null;
}
