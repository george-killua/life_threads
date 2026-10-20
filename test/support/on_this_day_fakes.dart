import 'package:flutter/material.dart';
import 'package:life_threads/features/memories/domain/memory_photo.dart';
import 'package:life_threads/features/memories/data/memory_repository.dart';
import 'package:life_threads/features/memories/domain/memory_category.dart';
import 'package:life_threads/features/memories/domain/memory_event.dart';
import 'package:life_threads/features/memories/domain/memory_feeling.dart';
import 'package:life_threads/features/memories/domain/memory_type.dart';
import 'package:life_threads/features/on_this_day/data/on_this_day_notifications.dart';
import 'package:life_threads/features/premium/data/premium_entitlement_controller.dart';
import 'package:life_threads/features/premium/domain/premium_entitlement.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/timezone.dart' as tz;

MemoryEvent memory(String id, DateTime occurredAt) => MemoryEvent(
  id: id,
  title: 'Memory $id',
  description: '',
  category: MemoryCategory.personal,
  memoryType: MemoryType.moment,
  feeling: MemoryFeeling.warm,
  occurredAt: occurredAt,
  createdAt: occurredAt,
  coverColor: Colors.amber,
  wallPosition: Offset.zero,
  rotation: 0,
  locationLabel: '',
);

MemoryState stateWith(
  List<MemoryEvent> events, {
  List<MemoryPhoto> photos = const [],
}) => MemoryState(
  events: events,
  connections: const [],
  photos: photos,
  people: const [],
  wallItems: const [],
);

class FakeMemoryRepository extends MemoryRepository {
  FakeMemoryRepository(this.initial, {this.photos = const []});

  final List<MemoryEvent> initial;
  final List<MemoryPhoto> photos;

  @override
  Future<MemoryState> build() async => stateWith(initial, photos: photos);

  void replaceEvents(List<MemoryEvent> events) {
    state = AsyncData(stateWith(events));
  }
}

class FakePremium extends PremiumEntitlementController {
  FakePremium({required this.isPremium});

  final bool isPremium;

  @override
  Future<PremiumEntitlement> build() async =>
      PremiumEntitlement(isPremium: isPremium, isMockUnlocked: false);
}

class FakeOnThisDayNotifications implements OnThisDayNotifications {
  FakeOnThisDayNotifications({this.grantPermission = true});

  final bool grantPermission;
  final scheduled = <List<OnThisDayNotification>>[];
  var cancelCount = 0;
  var permissionRequests = 0;

  @override
  Future<tz.Location> localLocation() async => tz.getLocation('Europe/Berlin');

  @override
  Future<bool> requestPermission() async {
    permissionRequests++;
    return grantPermission;
  }

  @override
  Future<void> replaceScheduled(
    List<OnThisDayNotification> notifications, {
    required String channelName,
    required String channelDescription,
  }) async {
    scheduled.add(notifications);
  }

  @override
  Future<void> cancelAll() async {
    cancelCount++;
  }
}
