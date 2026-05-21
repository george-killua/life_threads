import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:photo_manager/photo_manager.dart' hide LatLng;

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../backup/data/backup_service.dart';
import '../../../backup/domain/backup_models.dart';
import '../../../backup/presentation/widgets/archive_feedback.dart';
import '../../../backup/presentation/widgets/archive_password_dialog.dart';
import '../../../map/presentation/widgets/lifethreads_map_provider.dart';
import '../../../media/data/photo_library_service.dart';
import '../../../memories/data/memory_repository.dart';
import '../../../memories/domain/memory_category.dart';
import '../../../memories/domain/memory_event.dart';
import '../../../memories/domain/memory_feeling.dart';
import '../../../memories/domain/memory_type.dart';
import '../../../premium/data/premium_entitlement_controller.dart';
import '../../../premium/domain/premium_entitlement.dart';
import '../../domain/wall_attachment_layout.dart';
import '../../domain/wall_item.dart';
import '../../domain/wall_layout.dart';
import '../widgets/expandable_add_button.dart';
import '../widgets/memory_card.dart';
import '../widgets/rope_painter.dart';
import '../widgets/wall_background.dart';
import '../widgets/wall_empty_state.dart';
import '../widgets/wall_filter.dart';
import '../widgets/wall_nail.dart';
import '../widgets/wall_text_note.dart';

class MemoryWallPage extends ConsumerStatefulWidget {
  const MemoryWallPage({super.key});

  @override
  ConsumerState<MemoryWallPage> createState() => _MemoryWallPageState();
}

class _MemoryWallPageState extends ConsumerState<MemoryWallPage>
    with SingleTickerProviderStateMixin {
  static const _canvasSize = Size(1280, 1180);

  late final AnimationController _windController;
  final TransformationController _wallController = TransformationController();
  bool _didSetInitialViewport = false;
  bool _isRouteTransitioning = false;
  bool _controlsExpanded = false;
  WallFilter _filter = WallFilter.all;
  _WallViewMode _mode = _WallViewMode.wall;
  WallLayoutMode _layoutMode = WallLayoutMode.freeform;
  final Map<String, Offset> _manualLayoutOverrides = {};
  String? _draggingNodeId;
  _DragTargetKind? _draggingKind;
  Offset? _pendingDragPosition;
  var _nodePointerIsDown = false;

  @override
  void initState() {
    super.initState();
    _windController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat();
  }

  @override
  void dispose() {
    _windController.dispose();
    _wallController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final memoryState = ref.watch(memoryRepositoryProvider);
    final entitlement = ref.watch(premiumEntitlementProvider).asData?.value;
    final repository = ref.read(memoryRepositoryProvider.notifier);

    return Scaffold(
      body: WallBackground(
        child: SafeArea(
          child: memoryState.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => _WallError(message: error.toString()),
            data: (state) {
              final filteredEvents = WallLayoutEngine.apply(
                events: state.events
                    .where((event) => _filter.matches(event.category))
                    .toList(),
                mode: _layoutMode,
                manualOverrides: _manualLayoutOverrides,
              ).map(_withPendingMemory).toList();
              final displayWallItems = _displayWallItems(state, filteredEvents);
              final anchors = _buildAnchors(filteredEvents, displayWallItems);
              final visibleConnections = state.connections
                  .where(
                    (connection) =>
                        anchors.containsKey(connection.fromEventId) &&
                        anchors.containsKey(connection.toEventId),
                  )
                  .toList();
              final hasWallContent =
                  state.events.isNotEmpty || state.wallItems.isNotEmpty;
              final canCreateMemory =
                  entitlement?.canCreateMemory(state.events.length) ??
                  state.events.length < PremiumEntitlement.freeMemoryLimit;

              if (_mode == _WallViewMode.wall) {
                _setInitialViewport(
                  context,
                  filteredEvents,
                  displayWallItems,
                  controlsExpanded: _controlsExpanded,
                );
              }

              return PopScope(
                canPop: _draggingNodeId == null,
                onPopInvokedWithResult: (didPop, _) {
                  if (!didPop) _cancelDrag();
                },
                child: Stack(
                  children: [
                    if (!hasWallContent)
                      WallEmptyState(
                        onAdd: () => _pushRoute(RouteNames.addMemory),
                      )
                    else if (_mode == _WallViewMode.wall)
                      Positioned.fill(
                        child: InteractiveViewer(
                          transformationController: _wallController,
                          constrained: false,
                          clipBehavior: Clip.none,
                          minScale: 0.5,
                          maxScale: 2.1,
                          panEnabled:
                              _draggingNodeId == null && !_nodePointerIsDown,
                          scaleEnabled:
                              _draggingNodeId == null && !_nodePointerIsDown,
                          boundaryMargin: const EdgeInsets.all(1400),
                          child: SizedBox(
                            width: _canvasSize.width,
                            height: _canvasSize.height,
                            child: AnimatedBuilder(
                              animation: _windController,
                              builder: (context, _) {
                                return Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Positioned.fill(
                                      child: CustomPaint(
                                        painter: RopePainter(
                                          anchors: anchors,
                                          connections: visibleConnections,
                                          windValue: _windController.value,
                                          activeNodeId: _draggingNodeId,
                                          paintAnchors: false,
                                        ),
                                      ),
                                    ),
                                    for (final item in displayWallItems)
                                      switch (item.type) {
                                        WallItemType.text => WallTextNoteWidget(
                                          item: item,
                                          windValue: _windController.value,
                                          isDragging:
                                              _draggingNodeId == item.id,
                                          isAttached:
                                              _attachedMemoryId(item, state) !=
                                              null,
                                          onLongPress: () => _showTextMenu(
                                            context,
                                            state,
                                            item,
                                          ),
                                          onEdit: () => _editTextNote(
                                            context,
                                            repository,
                                            item,
                                          ),
                                          onAttach: () => _showTextAttachments(
                                            context,
                                            state,
                                            item,
                                          ),
                                          onPointerDown: _lockWallGestures,
                                          onPointerUp: _unlockWallGestures,
                                          onDragStart: () => _startDrag(
                                            item.id,
                                            item.wallPosition,
                                            _DragTargetKind.wallItem,
                                          ),
                                          onDragUpdate: _updateDrag,
                                          onDragEnd: () =>
                                              _endDrag(repository, state),
                                        ),
                                        WallItemType.nail => WallNailWidget(
                                          item: item,
                                          isDragging:
                                              _draggingNodeId == item.id,
                                          onLongPress: () => _showNailMenu(
                                            context,
                                            state,
                                            item,
                                          ),
                                          onPointerDown: _lockWallGestures,
                                          onPointerUp: _unlockWallGestures,
                                          onDragStart: () => _startDrag(
                                            item.id,
                                            item.wallPosition,
                                            _DragTargetKind.wallItem,
                                          ),
                                          onDragUpdate: _updateDrag,
                                          onDragEnd: () =>
                                              _endDrag(repository, state),
                                        ),
                                      },
                                    for (final event in filteredEvents)
                                      MemoryCard(
                                        event: event,
                                        windValue: _windController.value,
                                        isDragging: _draggingNodeId == event.id,
                                        onTap: () =>
                                            _pushRoute('/memories/${event.id}'),
                                        onLongPress: () =>
                                            _showMemoryMenu(context, event.id),
                                        onEdit: () => _pushRoute(
                                          '/memories/${event.id}/edit',
                                        ),
                                        onConnect: () => _pushRoute(
                                          '/memories/${event.id}/connections',
                                        ),
                                        onPointerDown: _lockWallGestures,
                                        onPointerUp: _unlockWallGestures,
                                        onDragStart: () => _startDrag(
                                          event.id,
                                          event.wallPosition,
                                          _DragTargetKind.memory,
                                        ),
                                        onDragUpdate: _updateDrag,
                                        onDragEnd: () =>
                                            _endDrag(repository, state),
                                      ),
                                    if (filteredEvents.isEmpty &&
                                        state.events.isNotEmpty)
                                      Center(
                                        child: Text(
                                          'No ${_filter.label.toLowerCase()} memories yet.',
                                          style: const TextStyle(
                                            color: AppColors.muted,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    Positioned.fill(
                                      child: IgnorePointer(
                                        child: CustomPaint(
                                          painter: RopePainter(
                                            anchors: anchors,
                                            connections: visibleConnections,
                                            windValue: _windController.value,
                                            activeNodeId: _draggingNodeId,
                                            paintAnchors: true,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      )
                    else if (_mode == _WallViewMode.timeline)
                      Positioned.fill(
                        child: _TimelineView(
                          events: filteredEvents,
                          topPadding: _controlsExpanded ? 206 : 92,
                        ),
                      )
                    else
                      Positioned.fill(
                        child: _MapView(
                          events: filteredEvents,
                          topPadding: _controlsExpanded ? 206 : 92,
                        ),
                      ),
                    Positioned(
                      left: 20,
                      right: 20,
                      top: 18,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 260),
                        switchInCurve: Curves.easeOutCubic,
                        switchOutCurve: Curves.easeInCubic,
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SizeTransition(
                              sizeFactor: animation,
                              axisAlignment: -1,
                              child: child,
                            ),
                          );
                        },
                        child: _controlsExpanded
                            ? _WallHeader(
                                key: const ValueKey('expanded-wall-controls'),
                                selectedFilter: _filter,
                                selectedMode: _mode,
                                selectedLayout: _layoutMode,
                                onFilterChanged: (filter) =>
                                    setState(() => _filter = filter),
                                onModeChanged: (mode) =>
                                    setState(() => _mode = mode),
                                onLayoutChanged: (layout) =>
                                    setState(() => _layoutMode = layout),
                                onExportBackup: () =>
                                    _exportBackup(context, state),
                                onImportBackup: () =>
                                    _importBackup(context, repository),
                                onOpenSettings: () =>
                                    _pushRoute(RouteNames.settings),
                                onCollapse: () =>
                                    setState(() => _controlsExpanded = false),
                              )
                            : Align(
                                alignment: Alignment.centerLeft,
                                child: _CollapsedWallControlsButton(
                                  key: const ValueKey(
                                    'collapsed-wall-controls',
                                  ),
                                  selectedMode: _mode,
                                  onTap: () =>
                                      setState(() => _controlsExpanded = true),
                                ),
                              ),
                      ),
                    ),
                    if (hasWallContent &&
                        _mode == _WallViewMode.wall &&
                        !_controlsExpanded)
                      const Positioned(
                        left: 20,
                        right: 20,
                        top: 78,
                        child: _WallInteractionHint(),
                      ),
                    if (state.isDemoOnly)
                      Positioned(
                        left: 20,
                        right: 20,
                        top: _controlsExpanded
                            ? (_mode == _WallViewMode.wall ? 226 : 190)
                            : 120,
                        child: _DemoWallBanner(
                          onClear: () => _clearDemoWall(context, repository),
                        ),
                      ),
                    Positioned(
                      right: 20,
                      bottom: 24,
                      child: ExpandableAddButton(
                        onAddEvent: () => _guardMemoryCreation(
                          canCreateMemory,
                          () => _pushRoute(RouteNames.addMemory),
                        ),
                        onAddQuickPhoto: () => _guardMemoryCreation(
                          canCreateMemory,
                          () => _createQuickPhotoMemory(context, repository),
                        ),
                        onAddText: () => _createTextNote(context, repository),
                        onAddNail: () => _createNail(context, repository),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  MemoryEvent _withPendingMemory(MemoryEvent event) {
    if (_draggingKind == _DragTargetKind.memory &&
        _draggingNodeId == event.id &&
        _pendingDragPosition != null) {
      return event.copyWith(wallPosition: _pendingDragPosition);
    }
    return event;
  }

  List<WallItem> _displayWallItems(
    MemoryState state,
    List<MemoryEvent> visibleEvents,
  ) {
    return WallAttachmentLayout.displayWallItems(
      wallItems: state.wallItems,
      visibleEvents: visibleEvents,
      allEvents: state.events,
      connections: state.connections,
      draggingWallItemId: _draggingKind == _DragTargetKind.wallItem
          ? _draggingNodeId
          : null,
      pendingDragPosition: _pendingDragPosition,
    );
  }

  Offset _absoluteTextPosition(WallItem item, MemoryState state) {
    return WallAttachmentLayout.absoluteTextPosition(
      item: item,
      wallItems: state.wallItems,
      events: state.events,
      connections: state.connections,
    );
  }

  Offset _nextAttachmentOffset({
    required MemoryState state,
    required MemoryEvent event,
    required WallItem item,
  }) {
    return WallAttachmentLayout.nextAttachmentOffset(
      wallItems: state.wallItems,
      events: state.events,
      connections: state.connections,
      event: event,
      item: item,
    );
  }

  String? _attachedMemoryId(WallItem item, MemoryState state) {
    return WallAttachmentLayout.attachedMemoryIdFor(
      item: item,
      events: state.events,
      connections: state.connections,
    );
  }

  WallItem _sourceWallItem(WallItem item, MemoryState state) {
    for (final source in state.wallItems) {
      if (source.id == item.id) return source;
    }
    return item;
  }

  Map<String, RopeAnchor> _buildAnchors(
    List<MemoryEvent> events,
    List<WallItem> wallItems,
  ) {
    return {
      for (final event in events)
        event.id: RopeAnchor(
          point: event.wallPosition + MemoryCard.pinHeadOffset,
          kind: RopeAnchorKind.memory,
          direction: const Offset(0, -1),
        ),
      for (final item in wallItems)
        item.id: switch (item.type) {
          WallItemType.nail => RopeAnchor(
            point: item.wallPosition + const Offset(24, 13),
            kind: RopeAnchorKind.nail,
            direction: const Offset(0, -1),
          ),
          WallItemType.text => RopeAnchor(
            point: item.wallPosition + const Offset(88, -41),
            kind: RopeAnchorKind.note,
            direction: const Offset(0, -1),
          ),
        },
    };
  }

  void _startDrag(String nodeId, Offset startPosition, _DragTargetKind kind) {
    if (!mounted || _isRouteTransitioning) return;
    setState(() {
      _draggingNodeId = nodeId;
      _draggingKind = kind;
      _pendingDragPosition = startPosition;
    });
  }

  void _lockWallGestures() {
    if (!mounted || _nodePointerIsDown) return;
    setState(() => _nodePointerIsDown = true);
  }

  void _unlockWallGestures() {
    if (!mounted || !_nodePointerIsDown) return;
    setState(() => _nodePointerIsDown = false);
  }

  void _updateDrag(Offset delta) {
    final current = _pendingDragPosition;
    if (!mounted || current == null) return;
    final scale = _wallController.value.getMaxScaleOnAxis();
    setState(() => _pendingDragPosition = current + delta / scale);
  }

  Future<void> _endDrag(MemoryRepository repository, MemoryState state) async {
    final nodeId = _draggingNodeId;
    final position = _pendingDragPosition;
    final kind = _draggingKind;
    setState(() {
      _draggingNodeId = null;
      _draggingKind = null;
      _pendingDragPosition = null;
    });

    if (nodeId == null || position == null || kind == null) return;
    switch (kind) {
      case _DragTargetKind.memory:
        _manualLayoutOverrides[nodeId] = position;
        await repository.moveMemory(nodeId, position);
      case _DragTargetKind.wallItem:
        final item = state.wallItems
            .where((item) => item.id == nodeId)
            .firstOrNull;
        final attachedMemoryId = item == null
            ? null
            : _attachedMemoryId(item, state);
        final attachedMemory = attachedMemoryId == null
            ? null
            : state.findEvent(attachedMemoryId);
        await repository.moveWallItem(
          nodeId,
          attachedMemory == null
              ? position
              : _clampAttachmentOffset(position - attachedMemory.wallPosition),
        );
    }
  }

  Offset _clampAttachmentOffset(Offset offset) {
    return WallAttachmentLayout.clampAttachmentOffset(offset);
  }

  Offset _defaultDropPosition(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final scene = _wallController.toScene(
      Offset(size.width * 0.58, size.height * 0.58),
    );
    return Offset(
      _clampDouble(scene.dx - 90, 70, _canvasSize.width - 230),
      _clampDouble(scene.dy - 70, 120, _canvasSize.height - 180),
    );
  }

  Future<void> _pushRoute(String location) async {
    if (!mounted || _isRouteTransitioning || !_isCurrentRoute(context)) return;
    _cancelDrag();
    _isRouteTransitioning = true;
    try {
      await context.push(location);
    } finally {
      if (mounted) _isRouteTransitioning = false;
    }
  }

  void _guardMemoryCreation(bool canCreateMemory, VoidCallback action) {
    if (canCreateMemory) {
      action();
      return;
    }
    _pushRoute(RouteNames.upgrade);
  }

  void _cancelDrag() {
    if (_draggingNodeId == null &&
        _draggingKind == null &&
        _pendingDragPosition == null) {
      return;
    }
    if (mounted) {
      setState(() {
        _draggingNodeId = null;
        _draggingKind = null;
        _pendingDragPosition = null;
        _nodePointerIsDown = false;
      });
    } else {
      _draggingNodeId = null;
      _draggingKind = null;
      _pendingDragPosition = null;
      _nodePointerIsDown = false;
    }
  }

  bool _isCurrentRoute(BuildContext context) {
    return ModalRoute.of(context)?.isCurrent ?? true;
  }

  double _clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  Future<void> _createTextNote(
    BuildContext context,
    MemoryRepository repository,
  ) async {
    final text = await showDialog<String>(
      context: context,
      builder: (_) => const _TextNoteDialog(
        title: 'Add text to wall',
        actionLabel: 'Add Text',
        hintText: 'Write a small memory, quote, or note...',
      ),
    );

    final trimmed = text?.trim();
    if (!context.mounted || trimmed == null || trimmed.isEmpty) return;
    final position = await _previewPlacement(
      context,
      title: 'Place text note',
      subtitle: trimmed,
      icon: Icons.sticky_note_2_rounded,
      color: AppColors.cardDark,
      initialPosition: _defaultDropPosition(context),
    );
    if (!context.mounted || position == null) return;
    await repository.addTextNote(text: trimmed, position: position);
  }

  Future<void> _createNail(
    BuildContext context,
    MemoryRepository repository,
  ) async {
    final position = await _previewPlacement(
      context,
      title: 'Place rope anchor',
      subtitle: 'A nail can connect ropes manually between memories.',
      icon: Icons.push_pin_rounded,
      color: AppColors.gold,
      initialPosition: _defaultDropPosition(context),
    );
    if (!context.mounted || position == null) return;
    await repository.addNail(position: position);
  }

  Future<void> _createQuickPhotoMemory(
    BuildContext context,
    MemoryRepository repository,
  ) async {
    final service = ref.read(photoLibraryServiceProvider);
    var permission = await service.currentPermission();
    if (!permission.hasAccess) permission = await service.requestPermission();
    if (!context.mounted) return;

    if (!permission.hasAccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Photo access is needed first.')),
      );
      await service.openSettings();
      return;
    }

    final assets = await service.recentPhotos(limit: 90);
    if (!context.mounted) return;
    final asset = await showModalBottomSheet<AssetEntity>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _QuickPhotoPickerSheet(assets: assets),
    );
    if (!context.mounted || asset == null) return;

    final picked = await service.copyAssetToAppStorage(asset);
    if (!context.mounted || picked == null) return;

    final title = _cleanPhotoTitle(picked.title) ?? 'Quick photo memory';
    final locationLabel = picked.hasLocation
        ? '${picked.latitude!.toStringAsFixed(5)}, ${picked.longitude!.toStringAsFixed(5)}'
        : 'Unknown place';
    final position = await _previewPlacement(
      context,
      title: 'Hang quick photo',
      subtitle: title,
      icon: Icons.add_photo_alternate_rounded,
      color: AppColors.gold,
      initialPosition: _defaultDropPosition(context),
    );
    if (!context.mounted || position == null) return;

    await repository.addMemory(
      NewMemoryDraft(
        title: title,
        description:
            'A quick photo memory added from the wall. Edit it later to add the full story.',
        category: MemoryCategory.personal,
        memoryType: MemoryType.moment,
        feeling: MemoryFeeling.warm,
        occurredAt: picked.capturedAt,
        locationLabel: locationLabel,
        latitude: picked.latitude,
        longitude: picked.longitude,
        coverPhotoPath: picked.localPath,
        wallPosition: position,
        photos: [
          MemoryPhotoDraft(
            localPath: picked.localPath,
            originalAssetId: picked.originalAssetId,
            capturedAt: picked.capturedAt,
            latitude: picked.latitude,
            longitude: picked.longitude,
            width: picked.width,
            height: picked.height,
          ),
        ],
      ),
    );
  }

  Future<void> _clearDemoWall(
    BuildContext context,
    MemoryRepository repository,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Clear demo wall?'),
        content: const Text(
          'This removes the sample memories so you can start with an empty private wall.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Start fresh'),
          ),
        ],
      ),
    );
    if (!context.mounted || confirmed != true) return;
    await repository.clearDemoWall();
  }

  Future<void> _exportBackup(BuildContext context, MemoryState state) async {
    final isPremium =
        ref.read(premiumEntitlementProvider).asData?.value.isPremium ?? false;
    if (!isPremium) {
      await context.push(RouteNames.upgrade);
      return;
    }

    final password = await showArchivePasswordDialog(
      context,
      purpose: ArchivePasswordPurpose.export,
    );
    if (!context.mounted || password == null) return;

    try {
      final result = await ref
          .read(backupServiceProvider)
          .exportBackup(state, password: password);
      if (!context.mounted) return;
      await shareExportedArchive(context, result);
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Export failed: $error')));
    }
  }

  Future<void> _importBackup(
    BuildContext context,
    MemoryRepository repository,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Import backup?'),
        content: const Text(
          'This restores memories from a LifeThreads archive and keeps your current wall.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Choose Backup'),
          ),
        ],
      ),
    );
    if (!context.mounted || confirmed != true) return;

    final password = await showArchivePasswordDialog(
      context,
      purpose: ArchivePasswordPurpose.import,
    );
    if (!context.mounted || password == null) return;

    try {
      final backup = await ref
          .read(backupServiceProvider)
          .pickAndPrepareImport(password: password);
      if (!context.mounted || backup == null) return;
      final result = await repository.importBackup(backup);
      if (!context.mounted) return;
      await showArchiveImportSummary(context, result);
    } on BackupValidationException catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Import rejected: ${error.message}')),
      );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Import failed: $error')));
    }
  }

  Future<Offset?> _previewPlacement(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Offset initialPosition,
  }) {
    return showModalBottomSheet<Offset>(
      context: context,
      showDragHandle: true,
      builder: (_) => _PlacementPreviewSheet(
        title: title,
        subtitle: subtitle,
        icon: icon,
        color: color,
        canvasSize: _canvasSize,
        initialPosition: initialPosition,
      ),
    );
  }

  void _setInitialViewport(
    BuildContext context,
    List<MemoryEvent> events,
    List<WallItem> wallItems, {
    required bool controlsExpanded,
  }) {
    if (_didSetInitialViewport || (events.isEmpty && wallItems.isEmpty)) return;
    _didSetInitialViewport = true;

    final positions = [
      for (final event in events) event.wallPosition,
      for (final item in wallItems) item.wallPosition,
    ];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final size = MediaQuery.sizeOf(context);
      final minX = positions
          .map((position) => position.dx)
          .reduce((a, b) => a < b ? a : b);
      final maxX =
          positions
              .map((position) => position.dx)
              .reduce((a, b) => a > b ? a : b) +
          MemoryCard.visualSize.width +
          40;
      final minY = positions
          .map((position) => position.dy)
          .reduce((a, b) => a < b ? a : b);
      final contentWidth = maxX - minX;
      final fitScale = size.width / (contentWidth + 120);
      final mobile = size.width < 520;
      final scale = mobile
          ? fitScale.clamp(0.62, 0.9)
          : fitScale.clamp(0.5, 0.9);
      final headerSpace = controlsExpanded
          ? (mobile ? 218.0 : 244.0)
          : (mobile ? 116.0 : 132.0);
      final translateX =
          ((size.width - contentWidth * scale) / 2) - minX * scale;
      final translateY = headerSpace - minY * scale;

      _wallController.value = Matrix4.identity()
        ..translateByDouble(translateX, translateY, 0, 1)
        ..scaleByDouble(scale, scale, 1, 1);
    });
  }

  Future<void> _showMemoryMenu(BuildContext context, String memoryId) async {
    final repository = ref.read(memoryRepositoryProvider.notifier);
    final action = await showModalBottomSheet<_MemoryAction>(
      context: context,
      showDragHandle: true,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.open_in_new_rounded),
              title: const Text('Open'),
              onTap: () => Navigator.of(context).pop(_MemoryAction.open),
            ),
            ListTile(
              leading: const Icon(Icons.edit_rounded),
              title: const Text('Edit'),
              onTap: () => Navigator.of(context).pop(_MemoryAction.edit),
            ),
            ListTile(
              leading: const Icon(Icons.hub_rounded),
              title: const Text('Connect'),
              onTap: () => Navigator.of(context).pop(_MemoryAction.connect),
            ),
            ListTile(
              leading: const Icon(
                Icons.delete_outline_rounded,
                color: Colors.redAccent,
              ),
              title: const Text(
                'Delete',
                style: TextStyle(color: Colors.redAccent),
              ),
              onTap: () => Navigator.of(context).pop(_MemoryAction.delete),
            ),
          ],
        ),
      ),
    );

    if (!context.mounted || action == null || !_isCurrentRoute(context)) return;

    switch (action) {
      case _MemoryAction.open:
        await _pushRoute('/memories/$memoryId');
      case _MemoryAction.edit:
        await _pushRoute('/memories/$memoryId/edit');
      case _MemoryAction.connect:
        await _pushRoute('/memories/$memoryId/connections');
      case _MemoryAction.delete:
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Delete memory?'),
            content: const Text(
              'This removes the memory and all its wall links.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Delete'),
              ),
            ],
          ),
        );
        if (!context.mounted || !_isCurrentRoute(context)) return;
        if (confirmed == true) await repository.deleteMemory(memoryId);
    }
  }

  Future<void> _showTextMenu(
    BuildContext context,
    MemoryState state,
    WallItem item,
  ) async {
    final repository = ref.read(memoryRepositoryProvider.notifier);
    final sourceItem = _sourceWallItem(item, state);
    final attachedMemoryId = _attachedMemoryId(sourceItem, state);
    final attachedMemory = attachedMemoryId == null
        ? null
        : state.findEvent(attachedMemoryId);
    final action = await showModalBottomSheet<_TextAction>(
      context: context,
      showDragHandle: true,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_note_rounded),
              title: const Text('Edit Text'),
              onTap: () => Navigator.of(context).pop(_TextAction.edit),
            ),
            ListTile(
              leading: const Icon(Icons.link_rounded),
              title: Text(
                attachedMemory == null
                    ? 'Attach to memory'
                    : 'Change attachment',
              ),
              subtitle: Text(
                attachedMemory == null
                    ? 'Keep this note stuck to one memory card.'
                    : 'Currently attached to ${attachedMemory.title}.',
              ),
              onTap: () => Navigator.of(context).pop(_TextAction.attach),
            ),
            ListTile(
              leading: const Icon(
                Icons.delete_outline_rounded,
                color: Colors.redAccent,
              ),
              title: const Text(
                'Delete',
                style: TextStyle(color: Colors.redAccent),
              ),
              onTap: () => Navigator.of(context).pop(_TextAction.delete),
            ),
          ],
        ),
      ),
    );

    if (!context.mounted || action == null || !_isCurrentRoute(context)) return;

    switch (action) {
      case _TextAction.edit:
        await _editTextNote(context, repository, sourceItem);
      case _TextAction.attach:
        await _showTextAttachments(context, state, sourceItem);
      case _TextAction.delete:
        await repository.deleteWallItem(sourceItem.id);
    }
  }

  Future<void> _showTextAttachments(
    BuildContext context,
    MemoryState state,
    WallItem item,
  ) async {
    final repository = ref.read(memoryRepositoryProvider.notifier);
    final sourceItem = _sourceWallItem(item, state);
    var selectedId = _attachedMemoryId(sourceItem, state);

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => StatefulBuilder(
        builder: (context, setModalState) => SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              const ListTile(
                title: Text('Attach text to a memory'),
                subtitle: Text(
                  'The note will stay pinned to that memory and move with it.',
                ),
              ),
              ListTile(
                selected: selectedId == null,
                leading: Icon(
                  selectedId == null
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_unchecked_rounded,
                ),
                title: const Text('Free note'),
                subtitle: const Text('Keep it independent on the wall.'),
                onTap: () {
                  setModalState(() => selectedId = null);
                  final position = _absoluteTextPosition(sourceItem, state);
                  repository.attachTextNoteToMemory(
                    textNoteId: sourceItem.id,
                    memoryId: null,
                    position: position,
                  );
                },
              ),
              for (final event in state.events)
                ListTile(
                  selected: selectedId == event.id,
                  leading: Icon(
                    selectedId == event.id
                        ? Icons.radio_button_checked_rounded
                        : Icons.radio_button_unchecked_rounded,
                  ),
                  title: Text(event.title),
                  subtitle: Text(
                    '${event.category.label} • ${event.locationLabel}',
                  ),
                  onTap: () {
                    setModalState(() => selectedId = event.id);
                    final offset = _nextAttachmentOffset(
                      state: state,
                      event: event,
                      item: sourceItem,
                    );
                    repository.attachTextNoteToMemory(
                      textNoteId: sourceItem.id,
                      memoryId: event.id,
                      position: offset,
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _editTextNote(
    BuildContext context,
    MemoryRepository repository,
    WallItem item,
  ) async {
    final text = await showDialog<String>(
      context: context,
      builder: (_) => _TextNoteDialog(
        title: 'Edit text',
        actionLabel: 'Save',
        initialText: item.content,
      ),
    );

    final trimmed = text?.trim();
    if (!context.mounted || trimmed == null || trimmed.isEmpty) return;
    await repository.updateTextNote(id: item.id, text: trimmed);
  }

  Future<void> _showNailMenu(
    BuildContext context,
    MemoryState state,
    WallItem nail,
  ) async {
    final repository = ref.read(memoryRepositoryProvider.notifier);
    final action = await showModalBottomSheet<_NailAction>(
      context: context,
      showDragHandle: true,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.cable_rounded),
              title: const Text('Connect rope'),
              subtitle: const Text('Attach this nail to memories.'),
              onTap: () => Navigator.of(context).pop(_NailAction.connect),
            ),
            ListTile(
              leading: const Icon(
                Icons.delete_outline_rounded,
                color: Colors.redAccent,
              ),
              title: const Text(
                'Delete nail',
                style: TextStyle(color: Colors.redAccent),
              ),
              onTap: () => Navigator.of(context).pop(_NailAction.delete),
            ),
          ],
        ),
      ),
    );

    if (!context.mounted || action == null || !_isCurrentRoute(context)) return;

    switch (action) {
      case _NailAction.connect:
        await _showNailConnections(context, state, nail);
      case _NailAction.delete:
        await repository.deleteWallItem(nail.id);
    }
  }

  Future<void> _showNailConnections(
    BuildContext context,
    MemoryState state,
    WallItem nail,
  ) async {
    final repository = ref.read(memoryRepositoryProvider.notifier);
    final selectedIds = {
      for (final event in state.events)
        if (state.hasConnection(nail.id, event.id)) event.id,
    };

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => StatefulBuilder(
        builder: (context, setModalState) => SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              const ListTile(
                title: Text('Connect nail to memories'),
                subtitle: Text('Selected memories will hang from this anchor.'),
              ),
              for (final event in state.events)
                SwitchListTile(
                  value: selectedIds.contains(event.id),
                  title: Text(event.title),
                  subtitle: Text(event.locationLabel),
                  onChanged: (value) {
                    setModalState(() {
                      if (value) {
                        selectedIds.add(event.id);
                      } else {
                        selectedIds.remove(event.id);
                      }
                    });
                    repository.setConnection(
                      fromId: nail.id,
                      toId: event.id,
                      isConnected: value,
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimelineView extends StatelessWidget {
  const _TimelineView({required this.events, required this.topPadding});

  final List<MemoryEvent> events;
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    final sorted = [...events]
      ..sort((a, b) => b.occurredAt.compareTo(a.occurredAt));

    return ListView(
      padding: EdgeInsets.fromLTRB(20, topPadding, 20, 120),
      children: [
        const _ViewTitle(
          icon: Icons.timeline_rounded,
          title: 'Timeline',
          subtitle: 'Your memories ordered by time.',
        ),
        const SizedBox(height: 18),
        if (sorted.isEmpty)
          const _EmptyModePanel(
            icon: Icons.timeline_rounded,
            title: 'No memories in this filter',
            subtitle: 'Switch filter or add a memory to build the timeline.',
          )
        else
          for (var index = 0; index < sorted.length; index++)
            _TimelineMemoryTile(
              event: sorted[index],
              isLast: index == sorted.length - 1,
            ),
      ],
    );
  }
}

class _TimelineMemoryTile extends StatelessWidget {
  const _TimelineMemoryTile({required this.event, required this.isLast});

  final MemoryEvent event;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _pushIfCurrent(context, '/memories/${event.id}'),
      borderRadius: BorderRadius.circular(26),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 36,
              child: Column(
                children: [
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: event.feeling.color,
                      boxShadow: [
                        BoxShadow(
                          color: event.feeling.color.withValues(alpha: 0.3),
                          blurRadius: 16,
                        ),
                      ],
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        margin: const EdgeInsets.symmetric(vertical: 7),
                        color: AppColors.rope.withValues(alpha: 0.48),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.panelWarm.withValues(alpha: 0.9),
                        AppColors.panel.withValues(alpha: 0.84),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(color: AppColors.line),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.22),
                        blurRadius: 22,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: event.coverColor,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.18),
                          ),
                        ),
                        child: Icon(event.feeling.icon, color: AppColors.text),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _formatTimelineDate(event.occurredAt),
                              style: const TextStyle(
                                color: AppColors.gold,
                                fontWeight: FontWeight.w900,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              event.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${event.memoryType.label} • ${event.feeling.label} • ${event.locationLabel}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.muted,
                                height: 1.25,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapView extends StatelessWidget {
  const _MapView({required this.events, required this.topPadding});

  final List<MemoryEvent> events;
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    final located = events
        .where((event) => event.latitude != null && event.longitude != null)
        .toList();

    return Padding(
      padding: EdgeInsets.fromLTRB(20, topPadding, 20, 120),
      child: Column(
        children: [
          const _ViewTitle(
            icon: Icons.map_rounded,
            title: 'Memory Map',
            subtitle: 'Your memories grouped by place.',
          ),
          const SizedBox(height: 18),
          if (located.isEmpty)
            const Expanded(
              child: _EmptyModePanel(
                icon: Icons.location_off_rounded,
                title: 'No mapped memories yet',
                subtitle:
                    'Add photos with location data or enter coordinates to see memories here.',
              ),
            )
          else
            Expanded(child: _MemoryMap(events: located)),
        ],
      ),
    );
  }
}

class _MemoryMap extends StatelessWidget {
  const _MemoryMap({required this.events});

  final List<MemoryEvent> events;

  @override
  Widget build(BuildContext context) {
    final first = events.first;
    final center = LatLng(first.latitude!, first.longitude!);

    if (!LifeThreadsMapProvider.current.hasTiles) {
      return const LifeThreadsMapUnavailablePanel();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Stack(
        children: [
          FlutterMap(
            options: MapOptions(initialCenter: center, initialZoom: 5),
            children: [
              const LifeThreadsMapTileLayer(),
              MarkerLayer(
                markers: [
                  for (final event in events)
                    Marker(
                      point: LatLng(event.latitude!, event.longitude!),
                      width: 58,
                      height: 58,
                      child: GestureDetector(
                        onTap: () =>
                            _pushIfCurrent(context, '/memories/${event.id}'),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.wallInk.withValues(alpha: 0.78),
                            border: Border.all(
                              color: event.feeling.color,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.34),
                                blurRadius: 14,
                                offset: const Offset(0, 7),
                              ),
                            ],
                          ),
                          child: Icon(
                            event.feeling.icon,
                            color: event.feeling.color,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const LifeThreadsMapAttribution(),
            ],
          ),
          Positioned(
            left: 14,
            right: 14,
            bottom: 14,
            child: SizedBox(
              height: 86,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: events.length,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final event = events[index];
                  return _MapMemoryChip(event: event);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapMemoryChip extends StatelessWidget {
  const _MapMemoryChip({required this.event});

  final MemoryEvent event;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _pushIfCurrent(context, '/memories/${event.id}'),
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: 210,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.wallInk.withValues(alpha: 0.84),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.gold.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: event.coverColor,
              child: Icon(event.feeling.icon, color: AppColors.text, size: 19),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    event.locationLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppColors.muted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ViewTitle extends StatelessWidget {
  const _ViewTitle({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.panelWarm.withValues(alpha: 0.9),
            AppColors.panel.withValues(alpha: 0.84),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.16)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.amber, size: 28),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 3),
                Text(subtitle, style: const TextStyle(color: AppColors.muted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyModePanel extends StatelessWidget {
  const _EmptyModePanel({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.panel.withValues(alpha: 0.88),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.line),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.gold, size: 42),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.muted, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}

class _WallHeader extends StatelessWidget {
  const _WallHeader({
    super.key,
    required this.selectedFilter,
    required this.selectedMode,
    required this.selectedLayout,
    required this.onFilterChanged,
    required this.onModeChanged,
    required this.onLayoutChanged,
    required this.onExportBackup,
    required this.onImportBackup,
    required this.onOpenSettings,
    required this.onCollapse,
  });

  final WallFilter selectedFilter;
  final _WallViewMode selectedMode;
  final WallLayoutMode selectedLayout;
  final ValueChanged<WallFilter> onFilterChanged;
  final ValueChanged<_WallViewMode> onModeChanged;
  final ValueChanged<WallLayoutMode> onLayoutChanged;
  final VoidCallback onExportBackup;
  final VoidCallback onImportBackup;
  final VoidCallback onOpenSettings;
  final VoidCallback onCollapse;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 390;
        return ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 12 : 14,
              vertical: compact ? 11 : 12,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.panelWarm.withValues(alpha: 0.82),
                  AppColors.wallInk.withValues(alpha: 0.76),
                ],
              ),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: AppColors.gold.withValues(alpha: 0.16)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.34),
                  blurRadius: 28,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.auto_awesome_rounded,
                      color: AppColors.amber,
                      size: compact ? 22 : 24,
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'LifeThreads',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: compact ? 21 : 22,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            'Your memories, hanging together.',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.muted,
                              fontSize: compact ? 12 : 12.5,
                              height: 1.25,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _HeaderIconButton(
                      tooltip: 'Import backup',
                      onPressed: onImportBackup,
                      icon: Icons.restore_rounded,
                      color: AppColors.muted,
                    ),
                    _HeaderIconButton(
                      tooltip: 'Export backup',
                      onPressed: onExportBackup,
                      icon: Icons.ios_share_rounded,
                      color: AppColors.gold,
                    ),
                    _HeaderIconButton(
                      tooltip: 'Settings',
                      onPressed: onOpenSettings,
                      icon: Icons.settings_rounded,
                      color: AppColors.muted,
                    ),
                    _HeaderIconButton(
                      tooltip: 'Hide controls',
                      onPressed: onCollapse,
                      icon: Icons.keyboard_arrow_up_rounded,
                      color: AppColors.amber,
                    ),
                  ],
                ),
                const SizedBox(height: 9),
                _HeaderScrollRow(
                  children: [
                    for (final mode in _WallViewMode.values)
                      _WallHeaderPill(
                        selected: selectedMode == mode,
                        icon: mode.icon,
                        label: mode.label,
                        onTap: () => onModeChanged(mode),
                      ),
                  ],
                ),
                if (selectedMode == _WallViewMode.wall) ...[
                  const SizedBox(height: 8),
                  _HeaderScrollRow(
                    children: [
                      for (final layout in WallLayoutMode.values)
                        _WallHeaderPill(
                          selected: selectedLayout == layout,
                          icon: layout.icon,
                          label: _layoutPillLabel(layout),
                          onTap: () => onLayoutChanged(layout),
                        ),
                    ],
                  ),
                ],
                const SizedBox(height: 8),
                _HeaderScrollRow(
                  children: [
                    for (final filter in WallFilter.values)
                      _WallHeaderPill(
                        selected: selectedFilter == filter,
                        icon: selectedFilter == filter
                            ? Icons.check_rounded
                            : null,
                        label: filter.label,
                        onTap: () => onFilterChanged(filter),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _layoutPillLabel(WallLayoutMode layout) {
    return switch (layout) {
      WallLayoutMode.freeform => 'Freeform',
      WallLayoutMode.timeline => 'Timeline',
      WallLayoutMode.categoryCluster => 'Category',
      WallLayoutMode.locationCluster => 'Location',
    };
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.tooltip,
    required this.onPressed,
    required this.icon,
    required this.color,
  });

  final String tooltip;
  final VoidCallback onPressed;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      icon: Icon(icon),
      color: color,
      iconSize: 23,
      visualDensity: VisualDensity.compact,
      constraints: const BoxConstraints.tightFor(width: 36, height: 36),
      padding: EdgeInsets.zero,
    );
  }
}

class _CollapsedWallControlsButton extends StatelessWidget {
  const _CollapsedWallControlsButton({
    super.key,
    required this.selectedMode,
    required this.onTap,
  });

  final _WallViewMode selectedMode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.panelWarm.withValues(alpha: 0.9),
              AppColors.wallInk.withValues(alpha: 0.82),
            ],
          ),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.gold.withValues(alpha: 0.22)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.34),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
            BoxShadow(
              color: AppColors.gold.withValues(alpha: 0.1),
              blurRadius: 22,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(13, 10, 11, 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(selectedMode.icon, color: AppColors.amber, size: 18),
              const SizedBox(width: 8),
              const Text(
                'Wall Controls',
                style: TextStyle(
                  color: AppColors.card,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.1,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.muted,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WallInteractionHint extends StatelessWidget {
  const _WallInteractionHint();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Align(
        alignment: Alignment.centerLeft,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.wallInk.withValues(alpha: 0.52),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.12)),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              'Tap to open • drag to move',
              style: TextStyle(
                color: AppColors.muted,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderScrollRow extends StatelessWidget {
  const _HeaderScrollRow({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.hardEdge,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            for (var index = 0; index < children.length; index++) ...[
              if (index > 0) const SizedBox(width: 8),
              children[index],
            ],
          ],
        ),
      ),
    );
  }
}

class _WallHeaderPill extends StatelessWidget {
  const _WallHeaderPill({
    required this.selected,
    required this.label,
    required this.onTap,
    this.icon,
  });

  final bool selected;
  final String label;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? AppColors.card : AppColors.muted;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.gold.withValues(alpha: 0.92)
              : AppColors.panelWarm.withValues(alpha: 0.56),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected
                ? AppColors.amber.withValues(alpha: 0.72)
                : AppColors.gold.withValues(alpha: 0.13),
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.gold.withValues(alpha: 0.16),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 17, color: foreground),
              const SizedBox(width: 7),
            ],
            Text(
              label,
              style: TextStyle(
                color: foreground,
                fontSize: 13.5,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DemoWallBanner extends StatelessWidget {
  const _DemoWallBanner({required this.onClear});

  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
      decoration: BoxDecoration(
        color: AppColors.wallInk.withValues(alpha: 0.84),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.28),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.preview_rounded, color: AppColors.gold, size: 20),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Demo wall preview. Clear it when you are ready to start fresh.',
              style: TextStyle(
                color: AppColors.muted,
                fontWeight: FontWeight.w800,
                height: 1.25,
              ),
            ),
          ),
          TextButton(onPressed: onClear, child: const Text('Clear demo')),
        ],
      ),
    );
  }
}

class _WallError extends StatelessWidget {
  const _WallError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(message, textAlign: TextAlign.center),
      ),
    );
  }
}

class _PlacementPreviewSheet extends StatefulWidget {
  const _PlacementPreviewSheet({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.canvasSize,
    required this.initialPosition,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Size canvasSize;
  final Offset initialPosition;

  @override
  State<_PlacementPreviewSheet> createState() => _PlacementPreviewSheetState();
}

class _PlacementPreviewSheetState extends State<_PlacementPreviewSheet> {
  late Offset _position;

  @override
  void initState() {
    super.initState();
    _position = widget.initialPosition;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color.withValues(alpha: 0.18),
                    border: Border.all(
                      color: widget.color.withValues(alpha: 0.42),
                    ),
                  ),
                  child: Icon(widget.icon, color: widget.color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        widget.subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.muted,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _PlacementMiniWall(
              position: _position,
              canvasSize: widget.canvasSize,
              color: widget.color,
              icon: widget.icon,
            ),
            const SizedBox(height: 14),
            LayoutBuilder(
              builder: (context, constraints) {
                final controls = _PlacementControls(
                  onMove: _move,
                  onCancel: () => Navigator.of(context).pop(),
                  onPlace: () => Navigator.of(context).pop(_position),
                );

                if (constraints.maxWidth < 520) {
                  return controls.compact();
                }
                return controls.wide();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _move(Offset delta) {
    setState(() {
      _position = Offset(
        (_position.dx + delta.dx).clamp(50, widget.canvasSize.width - 240),
        (_position.dy + delta.dy).clamp(110, widget.canvasSize.height - 190),
      );
    });
  }
}

class _PlacementMiniWall extends StatelessWidget {
  const _PlacementMiniWall({
    required this.position,
    required this.canvasSize,
    required this.color,
    required this.icon,
  });

  final Offset position;
  final Size canvasSize;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        const height = 150.0;
        final x = (position.dx / canvasSize.width * width).clamp(
          12.0,
          width - 52,
        );
        final y = (position.dy / canvasSize.height * height).clamp(
          12.0,
          height - 52,
        );

        return Container(
          height: height,
          decoration: BoxDecoration(
            color: AppColors.wallInk.withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.16)),
          ),
          child: Stack(
            children: [
              Positioned.fill(child: CustomPaint(painter: _MiniGridPainter())),
              Positioned(
                left: x,
                top: y,
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.22),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: AppColors.paperInk, size: 22),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PlacementControls {
  const _PlacementControls({
    required this.onMove,
    required this.onCancel,
    required this.onPlace,
  });

  final ValueChanged<Offset> onMove;
  final VoidCallback onCancel;
  final VoidCallback onPlace;

  Widget compact() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: _moveRow(),
        ),
        const SizedBox(height: 10),
        Align(alignment: Alignment.centerRight, child: _actionRow()),
      ],
    );
  }

  Widget wide() {
    return Row(children: [_moveRow(), const Spacer(), _actionRow()]);
  }

  Widget _moveRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _MoveButton(
          icon: Icons.keyboard_arrow_left_rounded,
          onTap: () => onMove(const Offset(-80, 0)),
        ),
        _MoveButton(
          icon: Icons.keyboard_arrow_up_rounded,
          onTap: () => onMove(const Offset(0, -80)),
        ),
        _MoveButton(
          icon: Icons.keyboard_arrow_down_rounded,
          onTap: () => onMove(const Offset(0, 80)),
        ),
        _MoveButton(
          icon: Icons.keyboard_arrow_right_rounded,
          onTap: () => onMove(const Offset(80, 0)),
        ),
      ],
    );
  }

  Widget _actionRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(onPressed: onCancel, child: const Text('Cancel')),
        const SizedBox(width: 8),
        FilledButton.icon(
          onPressed: onPlace,
          icon: const Icon(Icons.check_rounded),
          label: const Text('Place here'),
        ),
      ],
    );
  }
}

class _MiniGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.gold.withValues(alpha: 0.07)
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 38) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 38) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MoveButton extends StatelessWidget {
  const _MoveButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: IconButton.filledTonal(onPressed: onTap, icon: Icon(icon)),
    );
  }
}

class _QuickPhotoPickerSheet extends StatelessWidget {
  const _QuickPhotoPickerSheet({required this.assets});

  final List<AssetEntity> assets;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.78,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(18, 0, 18, 12),
            child: Row(
              children: [
                Icon(Icons.add_photo_alternate_rounded, color: AppColors.gold),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Choose quick photo',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: assets.isEmpty
                ? const Center(child: Text('No photos found.'))
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                    itemCount: assets.length,
                    itemBuilder: (context, index) {
                      final asset = assets[index];
                      return GestureDetector(
                        onTap: () => Navigator.of(context).pop(asset),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: _AssetThumbnail(asset: asset),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _AssetThumbnail extends StatelessWidget {
  const _AssetThumbnail({required this.asset});

  final AssetEntity asset;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: asset.thumbnailDataWithSize(const ThumbnailSize.square(320)),
      builder: (context, snapshot) {
        final bytes = snapshot.data;
        if (bytes == null) {
          return Container(
            color: AppColors.wallDeep,
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }
        return Image.memory(bytes, fit: BoxFit.cover);
      },
    );
  }
}

class _TextNoteDialog extends StatefulWidget {
  const _TextNoteDialog({
    required this.title,
    required this.actionLabel,
    this.initialText = '',
    this.hintText,
  });

  final String title;
  final String actionLabel;
  final String initialText;
  final String? hintText;

  @override
  State<_TextNoteDialog> createState() => _TextNoteDialogState();
}

class _TextNoteDialogState extends State<_TextNoteDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _controller,
        autofocus: true,
        minLines: 3,
        maxLines: 5,
        decoration: InputDecoration(hintText: widget.hintText),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_controller.text),
          child: Text(widget.actionLabel),
        ),
      ],
    );
  }
}

enum _WallViewMode {
  wall('Wall', Icons.dashboard_customize_rounded),
  timeline('Timeline', Icons.timeline_rounded),
  map('Map', Icons.map_rounded);

  const _WallViewMode(this.label, this.icon);

  final String label;
  final IconData icon;
}

enum _DragTargetKind { memory, wallItem }

enum _MemoryAction { open, edit, connect, delete }

enum _TextAction { edit, attach, delete }

enum _NailAction { connect, delete }

String _formatTimelineDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}

void _pushIfCurrent(BuildContext context, String location) {
  if (!(ModalRoute.of(context)?.isCurrent ?? true)) return;
  context.push(location);
}

String? _cleanPhotoTitle(String? title) {
  final value = title?.trim();
  if (value == null || value.isEmpty) return null;
  final dotIndex = value.lastIndexOf('.');
  final withoutExtension = dotIndex > 0 ? value.substring(0, dotIndex) : value;
  final cleaned = withoutExtension.replaceAll(RegExp(r'[_-]+'), ' ').trim();
  return cleaned.isEmpty ? null : cleaned;
}
