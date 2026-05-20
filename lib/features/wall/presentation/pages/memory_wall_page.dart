import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../memories/data/memory_repository.dart';
import '../../../memories/domain/memory_event.dart';
import '../../domain/wall_item.dart';
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
  WallFilter _filter = WallFilter.all;
  _WallViewMode _mode = _WallViewMode.wall;
  String? _draggingNodeId;
  _DragTargetKind? _draggingKind;
  Offset? _pendingDragPosition;

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
    final repository = ref.read(memoryRepositoryProvider.notifier);

    return Scaffold(
      body: WallBackground(
        child: SafeArea(
          child: memoryState.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => _WallError(message: error.toString()),
            data: (state) {
              final filteredEvents = state.events
                  .where((event) => _filter.matches(event.category))
                  .map(_withPendingMemory)
                  .toList();
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

              if (_mode == _WallViewMode.wall) {
                _setInitialViewport(context, filteredEvents, displayWallItems);
              }

              return Stack(
                children: [
                  if (!hasWallContent)
                    WallEmptyState(
                      onAdd: () => context.push(RouteNames.addMemory),
                    )
                  else if (_mode == _WallViewMode.wall)
                    Positioned.fill(
                      child: InteractiveViewer(
                        transformationController: _wallController,
                        constrained: false,
                        clipBehavior: Clip.none,
                        minScale: 0.42,
                        maxScale: 2.1,
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
                                      ),
                                    ),
                                  ),
                                  for (final item in displayWallItems)
                                    switch (item.type) {
                                      WallItemType.text => WallTextNoteWidget(
                                        item: item,
                                        windValue: _windController.value,
                                        isDragging: _draggingNodeId == item.id,
                                        isAttached:
                                            _attachedMemoryId(item, state) !=
                                            null,
                                        onLongPress: () =>
                                            _showTextMenu(context, state, item),
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
                                        isDragging: _draggingNodeId == item.id,
                                        onLongPress: () =>
                                            _showNailMenu(context, state, item),
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
                                          context.push('/memories/${event.id}'),
                                      onLongPress: () =>
                                          _showMemoryMenu(context, event.id),
                                      onEdit: () => context.push(
                                        '/memories/${event.id}/edit',
                                      ),
                                      onConnect: () => context.push(
                                        '/memories/${event.id}/connections',
                                      ),
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
                        topPadding: 230,
                      ),
                    )
                  else
                    Positioned.fill(
                      child: _MapView(events: filteredEvents, topPadding: 230),
                    ),
                  Positioned(
                    left: 20,
                    right: 20,
                    top: 18,
                    child: _WallHeader(
                      selectedFilter: _filter,
                      selectedMode: _mode,
                      onFilterChanged: (filter) =>
                          setState(() => _filter = filter),
                      onModeChanged: (mode) => setState(() => _mode = mode),
                    ),
                  ),
                  Positioned(
                    right: 20,
                    bottom: 24,
                    child: ExpandableAddButton(
                      onAddEvent: () => context.push(RouteNames.addMemory),
                      onAddText: () => _createTextNote(context, repository),
                      onAddNail: () => _createNail(context, repository),
                    ),
                  ),
                ],
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

  WallItem _withPendingWallItem(WallItem item) {
    if (_draggingKind == _DragTargetKind.wallItem &&
        _draggingNodeId == item.id &&
        _pendingDragPosition != null) {
      return item.copyWith(wallPosition: _pendingDragPosition);
    }
    return item;
  }

  List<WallItem> _displayWallItems(
    MemoryState state,
    List<MemoryEvent> visibleEvents,
  ) {
    final visibleEventById = {
      for (final event in visibleEvents) event.id: event,
    };
    final attachmentCounts = <String, int>{};
    final displayItems = <WallItem>[];

    for (final item in state.wallItems) {
      final attachedMemoryId = _attachedMemoryId(item, state);
      final isDraggingItem =
          _draggingKind == _DragTargetKind.wallItem &&
          _draggingNodeId == item.id &&
          _pendingDragPosition != null;
      if (item.type != WallItemType.text || attachedMemoryId == null) {
        displayItems.add(_withPendingWallItem(item));
        continue;
      }

      final event = visibleEventById[attachedMemoryId];
      if (event == null) continue;

      if (isDraggingItem) {
        displayItems.add(item.copyWith(wallPosition: _pendingDragPosition));
        continue;
      }

      final index = attachmentCounts.update(
        attachedMemoryId,
        (value) => value + 1,
        ifAbsent: () => 0,
      );
      displayItems.add(
        item.copyWith(
          wallPosition: _attachedTextPosition(
            item: item,
            event: event,
            index: index,
          ),
        ),
      );
    }

    return displayItems;
  }

  Offset _attachedTextPosition({
    required WallItem item,
    required MemoryEvent event,
    required int index,
  }) {
    final offset = _attachmentOffset(item, event, index);
    final position = event.wallPosition + offset;
    return Offset(
      _clampDouble(position.dx, 36, _canvasSize.width - 235),
      _clampDouble(position.dy, 88, _canvasSize.height - 180),
    );
  }

  Offset _attachmentOffset(WallItem item, MemoryEvent event, int index) {
    final stored = item.wallPosition;
    if (_looksLikeNoteOffset(stored)) return stored;

    final oldAbsoluteOffset = stored - event.wallPosition;
    if (_looksLikeNoteOffset(oldAbsoluteOffset)) return oldAbsoluteOffset;

    return _defaultAttachmentOffset(index);
  }

  Offset _defaultAttachmentOffset(int index) => Offset(112, -46 + index * 48);

  bool _looksLikeNoteOffset(Offset offset) {
    return offset.dx.abs() <= 360 && offset.dy.abs() <= 280;
  }

  Offset _absoluteTextPosition(WallItem item, MemoryState state) {
    final attachedMemoryId = _attachedMemoryId(item, state);
    final attachedMemory = attachedMemoryId == null
        ? null
        : state.findEvent(attachedMemoryId);
    if (attachedMemory == null) return item.wallPosition;

    final index = state.wallItems
        .where(
          (other) =>
              other.type == WallItemType.text &&
              _attachedMemoryId(other, state) == attachedMemoryId,
        )
        .toList()
        .indexWhere((other) => other.id == item.id);
    return _attachedTextPosition(
      item: item,
      event: attachedMemory,
      index: index < 0 ? 0 : index,
    );
  }

  Offset _nextAttachmentOffset({
    required MemoryState state,
    required MemoryEvent event,
    required WallItem item,
  }) {
    final currentAttachedId = _attachedMemoryId(item, state);
    if (currentAttachedId == event.id) {
      return _clampAttachmentOffset(item.wallPosition);
    }

    final existingCount = state.wallItems
        .where(
          (other) =>
              other.id != item.id &&
              other.type == WallItemType.text &&
              _attachedMemoryId(other, state) == event.id,
        )
        .length;
    return _defaultAttachmentOffset(existingCount);
  }

  String? _attachedMemoryId(WallItem item, MemoryState state) {
    if (item.type != WallItemType.text) return null;
    final eventIds = {for (final event in state.events) event.id};

    for (final connection in state.connections) {
      if (connection.fromEventId == item.id &&
          eventIds.contains(connection.toEventId)) {
        return connection.toEventId;
      }
      if (connection.toEventId == item.id &&
          eventIds.contains(connection.fromEventId)) {
        return connection.fromEventId;
      }
    }
    return null;
  }

  WallItem _sourceWallItem(WallItem item, MemoryState state) {
    for (final source in state.wallItems) {
      if (source.id == item.id) return source;
    }
    return item;
  }

  Map<String, Offset> _buildAnchors(
    List<MemoryEvent> events,
    List<WallItem> wallItems,
  ) {
    return {
      for (final event in events)
        event.id: event.wallPosition + const Offset(88, 44),
      for (final item in wallItems)
        item.id: item.type == WallItemType.nail
            ? item.wallPosition + const Offset(22, 12)
            : item.wallPosition + const Offset(97, 12),
    };
  }

  void _startDrag(String nodeId, Offset startPosition, _DragTargetKind kind) {
    setState(() {
      _draggingNodeId = nodeId;
      _draggingKind = kind;
      _pendingDragPosition = startPosition;
    });
  }

  void _updateDrag(Offset delta) {
    final current = _pendingDragPosition;
    if (current == null) return;
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
    return Offset(
      _clampDouble(offset.dx, -190, 270),
      _clampDouble(offset.dy, -150, 190),
    );
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
    await repository.addTextNote(
      text: trimmed,
      position: _defaultDropPosition(context),
    );
  }

  Future<void> _createNail(
    BuildContext context,
    MemoryRepository repository,
  ) async {
    await repository.addNail(position: _defaultDropPosition(context));
  }

  void _setInitialViewport(
    BuildContext context,
    List<MemoryEvent> events,
    List<WallItem> wallItems,
  ) {
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
          230;
      final minY = positions
          .map((position) => position.dy)
          .reduce((a, b) => a < b ? a : b);
      final contentWidth = maxX - minX;
      final scale = (size.width / (contentWidth + 140)).clamp(0.46, 0.86);
      final headerSpace = size.height < 720 ? 205.0 : 235.0;
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

    if (!context.mounted || action == null) return;

    switch (action) {
      case _MemoryAction.open:
        context.push('/memories/$memoryId');
      case _MemoryAction.edit:
        context.push('/memories/$memoryId/edit');
      case _MemoryAction.connect:
        context.push('/memories/$memoryId/connections');
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

    if (!context.mounted || action == null) return;

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
    if (trimmed == null || trimmed.isEmpty) return;
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

    if (!context.mounted || action == null) return;

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
      onTap: () => context.push('/memories/${event.id}'),
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

    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Stack(
        children: [
          FlutterMap(
            options: MapOptions(initialCenter: center, initialZoom: 5),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'dev.gkcoding.lifethreads',
              ),
              MarkerLayer(
                markers: [
                  for (final event in events)
                    Marker(
                      point: LatLng(event.latitude!, event.longitude!),
                      width: 58,
                      height: 58,
                      child: GestureDetector(
                        onTap: () => context.push('/memories/${event.id}'),
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
      onTap: () => context.push('/memories/${event.id}'),
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
    required this.selectedFilter,
    required this.selectedMode,
    required this.onFilterChanged,
    required this.onModeChanged,
  });

  final WallFilter selectedFilter;
  final _WallViewMode selectedMode;
  final ValueChanged<WallFilter> onFilterChanged;
  final ValueChanged<_WallViewMode> onModeChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.panelWarm.withValues(alpha: 0.82),
            AppColors.wallInk.withValues(alpha: 0.76),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.34),
            blurRadius: 34,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                color: AppColors.amber,
                size: 24,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'LifeThreads',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Your memories, hanging together.',
                      style: TextStyle(
                        color: AppColors.muted,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final mode in _WallViewMode.values) ...[
                  _WallHeaderPill(
                    selected: selectedMode == mode,
                    icon: mode.icon,
                    label: mode.label,
                    onTap: () => onModeChanged(mode),
                  ),
                  const SizedBox(width: 8),
                ],
              ],
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final filter in WallFilter.values) ...[
                  _WallHeaderPill(
                    selected: selectedFilter == filter,
                    icon: selectedFilter == filter ? Icons.check_rounded : null,
                    label: filter.label,
                    onTap: () => onFilterChanged(filter),
                  ),
                  const SizedBox(width: 8),
                ],
              ],
            ),
          ),
        ],
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
        height: 39,
        padding: const EdgeInsets.symmetric(horizontal: 14),
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
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: TextStyle(
                color: foreground,
                fontSize: 14,
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
