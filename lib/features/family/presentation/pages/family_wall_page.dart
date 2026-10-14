import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations_x.dart';
import '../../../memories/domain/memory_event.dart';
import '../../../memories/domain/memory_type.dart';
import '../../../wall/presentation/widgets/memory_card.dart';
import '../../../wall/presentation/widgets/wall_background.dart';
import '../../../wall/presentation/widgets/wall_pan_surface.dart';
import '../../domain/family_models.dart';
import '../family_flows.dart';
import '../family_providers.dart';
import '../widgets/wall_switcher.dart';

/// A family's shared wall: the members' memories as cards on the wall,
/// panned and zoomed like "My wall". Authors can move their own cards.
class FamilyWallPage extends ConsumerStatefulWidget {
  const FamilyWallPage({super.key, required this.familyId});

  final String familyId;

  @override
  ConsumerState<FamilyWallPage> createState() => _FamilyWallPageState();
}

class _FamilyWallPageState extends ConsumerState<FamilyWallPage>
    with SingleTickerProviderStateMixin {
  static const _boardOrigin = Offset(-20000, -20000);
  static const _boardSize = Size(40000, 40000);

  late final AnimationController _windController;
  final _wallController = TransformationController();
  var _didSetInitialViewport = false;
  var _pointerDown = false;
  String? _draggingId;
  Offset? _dragPosition;

  /// Moves sent to the service, shown until the synced memory catches up.
  final _pendingMoves = <String, Offset>{};

  @override
  void initState() {
    super.initState();
    _windController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat();
    WidgetsBinding.instance.addPostFrameCallback((_) => _sync(quiet: true));
  }

  @override
  void dispose() {
    _windController.dispose();
    _wallController.dispose();
    super.dispose();
  }

  Future<void> _sync({bool quiet = false}) async {
    final service = ref.read(familyServiceOrNullProvider);
    if (service == null) return;
    try {
      await service.sync(widget.familyId);
      ref.invalidate(familyMembersProvider(widget.familyId));
    } catch (error) {
      if (!quiet && mounted) showFamilyError(context, error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final familyState = ref.watch(familyProvider(widget.familyId));
    final family = familyState.asData?.value;
    final account = ref.watch(familyAccountProvider).asData?.value;
    final members =
        ref.watch(familyMembersProvider(widget.familyId)).asData?.value ??
        const <FamilyMember>[];
    final blocked = {
      for (final member in members)
        if (member.isBlockedByMe) member.accountId,
    };
    final memoriesState = ref.watch(familyMemoriesProvider(widget.familyId));
    final memories = (memoriesState.asData?.value ?? const <FamilyMemory>[])
        .where((memory) => !blocked.contains(memory.authorId))
        .toList();
    final syncStatus = ref
        .watch(familySyncStatusProvider(widget.familyId))
        .asData
        ?.value;

    final gone = familyState.hasValue && family == null;

    return Scaffold(
      body: WallBackground(
        child: SafeArea(
          child: Stack(
            children: [
              if (gone)
                _CenteredPanel(
                  icon: Icons.help_outline_rounded,
                  title: l10n.familyErrorNotFound,
                  body: l10n.familyWallGoneBody,
                  actionLabel: l10n.myWall,
                  onAction: () => context.go(RouteNames.wall),
                )
              else if (memoriesState.isLoading && memories.isEmpty)
                const Center(child: CircularProgressIndicator())
              else if (memoriesState.hasError && memories.isEmpty)
                _CenteredPanel(
                  icon: Icons.cloud_off_rounded,
                  title: l10n.familyLoadFailed,
                  body: familyErrorMessage(l10n, memoriesState.error!),
                  actionLabel: l10n.familyRetry,
                  onAction: () {
                    ref.invalidate(familyMemoriesProvider(widget.familyId));
                    _sync();
                  },
                )
              else if (memories.isEmpty)
                RefreshIndicator(
                  onRefresh: _sync,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(24, 140, 24, 24),
                    children: [
                      _CenteredPanel(
                        icon: Icons.diversity_1_rounded,
                        title: l10n.familyWallEmptyTitle,
                        body: l10n.familyWallEmptyBody,
                        actionLabel: l10n.familyAddMemory,
                        onAction: _addMemory,
                      ),
                    ],
                  ),
                )
              else
                Positioned.fill(
                  child: _buildBoard(context, memories, members, account),
                ),
              Positioned(
                left: 16,
                right: 16,
                top: 14,
                child: _FamilyWallHeader(
                  familyId: widget.familyId,
                  title: family?.name,
                  syncStatus: syncStatus,
                  onRefresh: () => _sync(),
                  onSettings: () => context.push(
                    RouteNames.familySettingsFor(widget.familyId),
                  ),
                ),
              ),
              if (!gone && memories.isNotEmpty)
                Positioned(
                  right: 20,
                  bottom: 24,
                  child: FloatingActionButton.extended(
                    key: const ValueKey('family-add-memory'),
                    heroTag: 'family-add-memory',
                    onPressed: _addMemory,
                    backgroundColor: AppColors.gold,
                    foregroundColor: AppColors.paperInk,
                    icon: const Icon(Icons.add_rounded),
                    label: Text(l10n.familyAddMemory),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBoard(
    BuildContext context,
    List<FamilyMemory> memories,
    List<FamilyMember> members,
    FamilyAccount? account,
  ) {
    final l10n = context.l10n;
    final events = [for (final memory in memories) _toEvent(memory)];
    _setInitialViewport(events);
    return InteractiveViewer(
      transformationController: _wallController,
      constrained: false,
      clipBehavior: Clip.none,
      minScale: 0.5,
      maxScale: 2.1,
      panEnabled: false,
      scaleEnabled: _draggingId == null && !_pointerDown,
      boundaryMargin: const EdgeInsets.all(4000),
      child: SizedBox(
        width: _boardSize.width,
        height: _boardSize.height,
        child: AnimatedBuilder(
          animation: _windController,
          builder: (context, _) => Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: WallPanSurface(
                  controller: _wallController,
                  enabled: _draggingId == null && !_pointerDown,
                ),
              ),
              for (var i = 0; i < memories.length; i++)
                _buildCard(
                  memories[i],
                  events[i],
                  author: familyAuthorName(
                    l10n,
                    members,
                    memories[i].authorId,
                    myId: account?.id,
                  ),
                  canMove: memories[i].authorId == account?.id,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
    FamilyMemory memory,
    MemoryEvent event, {
    required String author,
    required bool canMove,
  }) {
    final coverId = memory.coverPhotoId ?? memory.photoIds.firstOrNull;
    final coverPath = coverId == null
        ? null
        : ref
              .watch(
                familyPhotoProvider((
                  familyId: widget.familyId,
                  photoId: coverId,
                )),
              )
              .asData
              ?.value
              .path;
    final boardEvent = event.copyWith(
      wallPosition: event.wallPosition - _boardOrigin,
      coverPhotoPath: coverPath,
    );
    void open() =>
        context.push(RouteNames.familyMemoryFor(widget.familyId, memory.id));
    return MemoryCard(
      key: ValueKey('family-card-${memory.id}'),
      event: boardEvent,
      windValue: _windController.value,
      isDragging: _draggingId == memory.id,
      hasConnection: false,
      showActions: false,
      footnote: author,
      onTap: open,
      onLongPress: open,
      onEdit: open,
      onConnect: () {},
      onPointerDown: _lock,
      onPointerUp: _unlock,
      onDragStart: canMove
          ? () => _startDrag(memory.id, event.wallPosition)
          : () {},
      onDragUpdate: canMove ? (delta) => _updateDrag(memory.id, delta) : (_) {},
      onDragEnd: canMove ? () => _endDrag(memory) : _unlock,
    );
  }

  MemoryEvent _toEvent(FamilyMemory memory) {
    final position = _draggingId == memory.id && _dragPosition != null
        ? _dragPosition!
        : _pendingMoves[memory.id] ?? Offset(memory.wallX, memory.wallY);
    return MemoryEvent(
      id: memory.id,
      title: memory.title,
      description: memory.description,
      category: memory.category,
      memoryType: MemoryType.moment,
      feeling: memory.feeling,
      occurredAt: memory.occurredAt,
      createdAt: memory.createdAt,
      coverColor: memory.feeling.color,
      wallPosition: position,
      rotation: memory.rotation,
      locationLabel: memory.locationLabel,
      latitude: memory.latitude,
      longitude: memory.longitude,
    );
  }

  void _lock() {
    if (!mounted || _pointerDown) return;
    setState(() => _pointerDown = true);
  }

  void _unlock() {
    if (!mounted || !_pointerDown) return;
    setState(() => _pointerDown = false);
  }

  void _startDrag(String id, Offset start) {
    if (_draggingId != null && _draggingId != id) return;
    HapticFeedback.selectionClick();
    setState(() {
      _pointerDown = true;
      _draggingId = id;
      _dragPosition = start;
    });
  }

  void _updateDrag(String id, Offset globalDelta) {
    final current = _dragPosition;
    if (current == null || _draggingId != id) return;
    final m = _wallController.value;
    final scale = math
        .sqrt(m.entry(0, 0) * m.entry(0, 0) + m.entry(1, 0) * m.entry(1, 0))
        .clamp(0.01, 10.0);
    setState(() => _dragPosition = current + globalDelta / scale);
  }

  Future<void> _endDrag(FamilyMemory memory) async {
    final position = _dragPosition;
    final moved = _draggingId == memory.id && position != null;
    setState(() {
      _pointerDown = false;
      _draggingId = null;
      _dragPosition = null;
      if (moved) _pendingMoves[memory.id] = position;
    });
    if (!moved) return;
    final service = ref.read(familyServiceOrNullProvider);
    if (service == null) return;
    try {
      await service.moveMemory(memory, position.dx, position.dy);
    } catch (error) {
      if (mounted) {
        setState(() => _pendingMoves.remove(memory.id));
        showFamilyError(context, error);
      }
    }
  }

  void _setInitialViewport(List<MemoryEvent> events) {
    if (_didSetInitialViewport || events.isEmpty) return;
    _didSetInitialViewport = true;
    final positions = [
      for (final event in events) event.wallPosition - _boardOrigin,
    ];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final size = MediaQuery.sizeOf(context);
      final minX = positions.map((p) => p.dx).reduce(math.min);
      final maxX =
          positions.map((p) => p.dx).reduce(math.max) +
          MemoryCard.visualSize.width +
          40;
      final minY = positions.map((p) => p.dy).reduce(math.min);
      final contentWidth = maxX - minX;
      final mobile = size.width < 520;
      final fitScale = size.width / (contentWidth + 120);
      final scale = mobile
          ? fitScale.clamp(0.62, 0.9)
          : fitScale.clamp(0.5, 0.9);
      final translateX =
          ((size.width - contentWidth * scale) / 2) - minX * scale;
      final translateY = (mobile ? 96.0 : 110.0) - minY * scale;
      _wallController.value = Matrix4.identity()
        ..translateByDouble(translateX, translateY, 0, 1)
        ..scaleByDouble(scale, scale, scale, 1);
    });
  }

  Future<void> _addMemory() async {
    final account = await ensureFamilyPosting(context);
    if (account == null || !mounted) return;
    unawaited(context.push(RouteNames.familyAddMemoryFor(widget.familyId)));
  }
}

class _FamilyWallHeader extends StatelessWidget {
  const _FamilyWallHeader({
    required this.familyId,
    required this.title,
    required this.syncStatus,
    required this.onRefresh,
    required this.onSettings,
  });

  final String familyId;
  final String? title;
  final FamilySyncStatus? syncStatus;
  final VoidCallback onRefresh;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final status = syncStatus;
    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(6, 6, 6, 6),
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
      child: Row(
        children: [
          IconButton(
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            onPressed: () =>
                context.canPop() ? context.pop() : context.go(RouteNames.wall),
            icon: const BackButtonIcon(),
            color: AppColors.muted,
          ),
          Expanded(
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: WallSwitcherButton(
                currentFamilyId: familyId,
                label: title,
              ),
            ),
          ),
          if (status != null && status != FamilySyncStatus.idle)
            _SyncChip(status: status),
          IconButton(
            key: const ValueKey('family-refresh'),
            tooltip: l10n.familyRefresh,
            onPressed: status == FamilySyncStatus.syncing ? null : onRefresh,
            icon: const Icon(Icons.sync_rounded),
            color: AppColors.gold,
          ),
          IconButton(
            key: const ValueKey('family-settings'),
            tooltip: l10n.familySettingsTitle,
            onPressed: onSettings,
            icon: const Icon(Icons.tune_rounded),
            color: AppColors.gold,
          ),
        ],
      ),
    );
  }
}

class _SyncChip extends StatelessWidget {
  const _SyncChip({required this.status});

  final FamilySyncStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (icon, label, color) = switch (status) {
      FamilySyncStatus.syncing => (
        Icons.sync_rounded,
        l10n.familySyncing,
        AppColors.amber,
      ),
      FamilySyncStatus.offline => (
        Icons.cloud_off_rounded,
        l10n.familyOffline,
        AppColors.muted,
      ),
      FamilySyncStatus.error => (
        Icons.error_outline_rounded,
        l10n.familySyncFailed,
        AppColors.error,
      ),
      FamilySyncStatus.idle => (Icons.check_rounded, '', AppColors.sage),
    };
    return Tooltip(
      message: label,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: status == FamilySyncStatus.syncing
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2.2),
              )
            : Icon(icon, size: 20, color: color),
      ),
    );
  }
}

class _CenteredPanel extends StatelessWidget {
  const _CenteredPanel({
    required this.icon,
    required this.title,
    required this.body,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon;
  final String title;
  final String body;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 420),
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: AppColors.panelWarm.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.gold.withValues(alpha: 0.18)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: AppColors.gold),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text(
              body,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.muted,
                height: 1.45,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 18),
            FilledButton(onPressed: onAction, child: Text(actionLabel)),
          ],
        ),
      ),
    );
  }
}
