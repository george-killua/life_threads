import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:photo_manager/photo_manager.dart' hide LatLng;

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations_x.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../backup/data/backup_reminder.dart';
import '../../../backup/data/backup_service.dart';
import '../../../backup/presentation/widgets/archive_feedback.dart';
import '../../../backup/presentation/widgets/archive_password_dialog.dart';
import '../../../display/data/wall_display_service.dart';
import '../../../display/presentation/pages/wall_display_scanner_page.dart';
import '../../../family/presentation/family_providers.dart';
import '../../../app_lock/app_lock.dart';
import '../../../family/presentation/widgets/wall_switcher.dart';
import '../../../map/presentation/widgets/lifethreads_map_provider.dart';
import '../../../media/data/photo_library_service.dart';
import '../../../media/data/picked_memory_photo.dart';
import '../../../memories/data/memory_repository.dart';
import '../../../memories/data/place_names.dart';
import '../../../memories/domain/personal_wall.dart';
import '../../../memories/presentation/memory_l10n.dart';
import '../../../memories/domain/memory_category.dart';
import '../../../memories/domain/memory_event.dart';
import '../../../memories/domain/memory_feeling.dart';
import '../../../memories/domain/memory_type.dart';
import '../../../on_this_day/data/on_this_day_providers.dart';
import '../../../onboarding/onboarding_preferences.dart';
import '../../../onboarding/presentation/widgets/lifethreads_tutorial.dart';
import '../../../premium/data/premium_entitlement_controller.dart';
import '../../../premium/domain/premium_entitlement.dart';
import '../../../year_thread/presentation/widgets/year_thread_wall_card.dart';
import '../../../look_back/presentation/look_back_wall_card.dart';
import '../../domain/wall_attachment_layout.dart';
import '../../domain/wall_item.dart';
import '../../domain/wall_layout.dart';
import '../widgets/expandable_add_button.dart';
import '../widgets/memory_card.dart';
import '../../data/current_wall.dart';
import '../../data/wall_theme_controller.dart';
import '../widgets/rope_painter.dart';
import '../widgets/wall_background.dart';
import '../widgets/wall_empty_state.dart';
import '../widgets/wall_filter.dart';
import '../../domain/wall_placement.dart';
import '../widgets/wall_nail.dart';
import '../widgets/wall_pan_surface.dart';
import '../widgets/wall_text_note.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../memories/data/memory_seed_data.dart';
import '../../../tour/app_tour.dart';
import '../../../tour/coach.dart';

class MemoryWallPage extends ConsumerStatefulWidget {
  const MemoryWallPage({super.key});

  @override
  ConsumerState<MemoryWallPage> createState() => _MemoryWallPageState();
}

class _MemoryWallPageState extends ConsumerState<MemoryWallPage>
    with TickerProviderStateMixin {
  /// Virtual board large enough that placement feels unbounded.
  /// Wall coordinates are free; widgets are shifted by [_boardOrigin] into this box.
  static const _boardOrigin = Offset(-40000, -40000);
  static const _boardSize = Size(80000, 80000);

  /// Below the top bar: where banners start and timeline/map content begins.
  static const _bannerTop = 64.0;
  static const _topBarSpace = 76.0;

  late final AnimationController _windController;
  final TransformationController _wallController = TransformationController();

  /// Moves the cards to a new arrangement and fades them for a new category
  /// after the View sheet's Done.
  late final AnimationController _viewTransition;

  /// Where each card on the wall was last drawn (wall coordinates).
  Map<String, Offset> _shownPositions = const {};

  /// Set while [_viewTransition] runs: where the cards started, and the
  /// category shown before (null: unchanged).
  Map<String, Offset>? _transitionFrom;
  WallFilter? _transitionFilter;

  /// The wall whose memories are on screen (null: "My wall").
  String? _shownWallId;

  /// Hidden memories are shown (after Face ID, from the View sheet).
  var _showHidden = false;

  bool _didSetInitialViewport = false;

  /// The guided tour started: show the plain wall and frame its demo cards.
  bool _frameTourCards = false;
  bool _tourWasRunning = false;
  bool _isRouteTransitioning = false;
  bool _isCapturingPhotos = false;
  WallFilter _filter = WallFilter.all;
  _WallViewMode _mode = _WallViewMode.wall;
  WallLayoutMode _layoutMode = WallLayoutMode.freeform;
  // Per layout: a card nudged in Timeline must not move it in Freeform.
  final Map<WallLayoutMode, Map<String, Offset>> _manualLayoutOverrides = {};
  String? _draggingNodeId;
  _DragTargetKind? _draggingKind;
  Offset? _pendingDragPosition;
  var _nodePointerIsDown = false;

  Offset _toBoardLocal(Offset wallPosition) => wallPosition - _boardOrigin;

  MemoryEvent _toBoardLocalMemory(MemoryEvent event) {
    return event.copyWith(wallPosition: _toBoardLocal(event.wallPosition));
  }

  WallItem _toBoardLocalWallItem(WallItem item) {
    return item.copyWith(wallPosition: _toBoardLocal(item.wallPosition));
  }

  @override
  void initState() {
    super.initState();
    Coach.instance.addListener(_onTour);
    _onTour(initial: true);
    _windController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat();
    _viewTransition =
        AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 650),
          )
          ..addListener(() {
            if (mounted) setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed && mounted) {
              setState(() {
                _transitionFrom = null;
                _transitionFilter = null;
              });
            }
          });
    WidgetsBinding.instance.addPostFrameCallback((_) => _namePlacesOnce());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // "Reduce Motion": the cards hang still.
    if (MediaQuery.disableAnimationsOf(context)) {
      _windController.stop();
    } else if (!_windController.isAnimating) {
      _windController.repeat();
    }
  }

  /// The part of the board on screen, with a margin of about two cards, in
  /// board coordinates.
  Rect _visibleBoardRect(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final inverse = Matrix4.tryInvert(_wallController.value);
    if (inverse == null) return Rect.largest;
    final topLeft = MatrixUtils.transformPoint(inverse, Offset.zero);
    final bottomRight = MatrixUtils.transformPoint(
      inverse,
      Offset(size.width, size.height),
    );
    return Rect.fromPoints(topLeft, bottomRight).inflate(480);
  }

  static var _placesNamed = false;

  /// Once per app start: memories saved offline get their place names.
  void _namePlacesOnce() {
    if (_placesNamed || !mounted) return;
    _placesNamed = true;
    unawaited(
      ref
          .read(memoryRepositoryProvider.notifier)
          .nameCoordinatePlaces(
            ref.read(placeNameLookupProvider),
            Localizations.localeOf(context),
          )
          .catchError((Object _) {}),
    );
  }

  /// The cards shown last time, and on which wall and view: a single new
  /// one (just saved) is brought into view if it hangs off the screen.
  Set<String>? _knownCardIds;
  String? _knownCardsView;
  AnimationController? _revealController;

  void _noticeNewCard(String? wallId, List<MemoryEvent> boardEvents) {
    final ids = {for (final event in boardEvents) event.id};
    final view =
        '$wallId|${_filter.name}|${_layoutMode.name}|$_showHidden|'
        '${_mode.name}';
    final known = _knownCardIds;
    final sameView = _knownCardsView == view;
    _knownCardIds = ids;
    _knownCardsView = view;
    // A tour keeps the wall where it framed it; imports add many at once.
    if (known == null ||
        !sameView ||
        appTourRunning ||
        _mode != _WallViewMode.wall) {
      return;
    }
    final added = [
      for (final event in boardEvents)
        if (!known.contains(event.id)) event,
    ];
    if (added.length != 1) return;
    final position = added.single.wallPosition;
    WidgetsBinding.instance.addPostFrameCallback((_) => _revealCard(position));
  }

  /// Glides the wall so the card at [boardPosition] is on the screen, at the
  /// same zoom; a card already in view stays where it is.
  void _revealCard(Offset boardPosition) {
    if (!mounted) return;
    final size = MediaQuery.sizeOf(context);
    final padding = MediaQuery.paddingOf(context);
    final from = _wallController.value.clone();
    final card = MatrixUtils.transformRect(
      from,
      boardPosition & MemoryCard.visualSize,
    );
    // Between the top buttons and the bottom bar.
    final view = Rect.fromLTRB(
      0,
      padding.top + 70,
      size.width,
      size.height - padding.bottom - 100,
    );
    if (view.contains(card.topLeft) && view.contains(card.bottomRight)) return;
    final shift = view.center - card.center;
    final to = Matrix4.translationValues(shift.dx, shift.dy, 0) * from;
    final tween = Matrix4Tween(begin: from, end: to);
    final controller = _revealController ??= AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    final curve = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOutCubic,
    );
    void move() => _wallController.value = tween.evaluate(curve);
    controller
      ..stop()
      ..reset();
    curve.addListener(move);
    controller.forward().whenCompleteOrCancel(() {
      curve
        ..removeListener(move)
        ..dispose();
    });
  }

  @override
  void dispose() {
    _revealController?.dispose();
    Coach.instance.removeListener(_onTour);
    _windController.dispose();
    _viewTransition.dispose();
    _wallController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final memoryState = ref.watch(memoryRepositoryProvider);
    final currentWall = ref.watch(currentWallProvider);
    final entitlement = ref.watch(premiumEntitlementProvider).asData?.value;
    final repository = ref.read(memoryRepositoryProvider.notifier);
    final backupReminder = ref.watch(backupReminderProvider).asData?.value;
    final onThisDay = ref.watch(onThisDayMatchesProvider).firstOrNull;
    // Only once family walls were used on this device; otherwise the wall
    // never touches the family service.
    // Also once one has walls of one's own.
    final showWallSwitcher =
        ref.watch(switchableFamiliesProvider).isNotEmpty ||
        (memoryState.asData?.value.walls.isNotEmpty ?? false);

    return Scaffold(
      body: WallBackground(
        child: SafeArea(
          // A failed change (e.g. a save) keeps the memories it had: show
          // them, not the error, which the change reports on its own.
          child: memoryState.when(
            skipError: true,
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => _WallError(message: error.toString()),
            data: (allState) {
              // One wall at a time: "My wall" or a named wall, hidden
              // memories only once shown from the View sheet.
              final wallId = allState.walls.any((w) => w.id == currentWall)
                  ? currentWall
                  : null;
              if (wallId != _shownWallId) {
                _shownWallId = wallId;
                _didSetInitialViewport = false;
                // Face ID unlocks the hidden memories of one wall only.
                _showHidden = false;
              }
              final state = allState.onWall(wallId, includeHidden: _showHidden);
              final filteredEvents = WallLayoutEngine.apply(
                events: state.events
                    .where((event) => _filter.matches(event.category))
                    .toList(),
                mode: _layoutMode,
                manualOverrides:
                    _manualLayoutOverrides[_layoutMode] ?? const {},
              ).map(_withPendingMemory).map(_inTransition).toList();
              // Cards of the category shown before, fading out where they
              // were.
              final from = _transitionFrom;
              final previousFilter = _transitionFilter;
              final leavingEvents = from == null || previousFilter == null
                  ? const <MemoryEvent>[]
                  : [
                      for (final event in state.events)
                        if (from.containsKey(event.id) &&
                            !_filter.matches(event.category))
                          event.copyWith(wallPosition: from[event.id]),
                    ];
              _shownPositions = {
                for (final event in filteredEvents)
                  event.id: event.wallPosition,
              };
              final displayWallItems = _displayWallItems(state, filteredEvents);
              final boardEvents = filteredEvents
                  .map(_toBoardLocalMemory)
                  .toList();
              _noticeNewCard(wallId, boardEvents);
              final boardWallItems = displayWallItems
                  .map(_toBoardLocalWallItem)
                  .toList();
              final anchors = _buildAnchors(boardEvents, boardWallItems);
              final textNoteIds = {
                for (final item in displayWallItems)
                  if (item.type == WallItemType.text) item.id,
              };
              final visibleConnections = state.connections
                  .where(
                    (connection) =>
                        anchors.containsKey(connection.fromEventId) &&
                        anchors.containsKey(connection.toEventId) &&
                        !textNoteIds.contains(connection.fromEventId) &&
                        !textNoteIds.contains(connection.toEventId),
                  )
                  .toList();
              final connectedMemoryIds = {
                for (final connection in visibleConnections) ...[
                  connection.fromEventId,
                  connection.toEventId,
                ],
              };
              final hasWallContent =
                  state.events.isNotEmpty || state.wallItems.isNotEmpty;
              // The free limit counts the memories on every wall.
              final canCreateMemory =
                  entitlement?.canCreateMemory(allState.countedMemories) ??
                  allState.countedMemories < PremiumEntitlement.freeMemoryLimit;

              if (_mode == _WallViewMode.wall) {
                if (_frameTourCards) {
                  final demo = [
                    for (final event in boardEvents)
                      if (MemorySeedData.isDemoEventId(event.id)) event,
                  ];
                  if (demo.isNotEmpty) {
                    _frameTourCards = false;
                    _setInitialViewport(context, demo, const []);
                  }
                }
                _setInitialViewport(context, boardEvents, boardWallItems);
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
                        onMoveHere:
                            wallId != null &&
                                allState.visibleEvents.any(
                                  (e) => e.wallId != wallId,
                                )
                            ? () => _moveMemoriesHere(context, wallId)
                            : null,
                        onAdd: () => _pushRoute(RouteNames.addMemory),
                        onQuickPhoto: () => _guardMemoryCreation(
                          canCreateMemory,
                          () => _createQuickPhotoMemory(context, repository),
                        ),
                        onTakePhotos: _isCapturingPhotos
                            ? null
                            : () => _guardMemoryCreation(
                                canCreateMemory,
                                () => _capturePhotosForNewMemory(),
                              ),
                      )
                    else if (_mode == _WallViewMode.wall)
                      Positioned.fill(
                        child: InteractiveViewer(
                          transformationController: _wallController,
                          constrained: false,
                          clipBehavior: Clip.none,
                          minScale: 0.5,
                          maxScale: 2.1,
                          // Pan is handled by [WallPanSurface] behind nodes so
                          // card/nail/note drags never fight InteractiveViewer.
                          panEnabled: false,
                          scaleEnabled:
                              _draggingNodeId == null && !_nodePointerIsDown,
                          boundaryMargin: const EdgeInsets.all(4000),
                          child: SizedBox(
                            width: _boardSize.width,
                            height: _boardSize.height,
                            // Rebuilt with the wind and while panning or
                            // zooming: only the cards near the screen are
                            // built, so a wall of hundreds stays smooth.
                            child: AnimatedBuilder(
                              animation: Listenable.merge([
                                _windController,
                                _wallController,
                              ]),
                              builder: (context, _) {
                                final visible = _visibleBoardRect(context);
                                bool onScreen(Offset position, String id) =>
                                    id == _draggingNodeId ||
                                    visible.contains(position);
                                return Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Positioned.fill(
                                      child: WallPanSurface(
                                        controller: _wallController,
                                        enabled:
                                            _draggingNodeId == null &&
                                            !_nodePointerIsDown,
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
                                            paintAnchors: false,
                                            glowColor: ref
                                                .watch(
                                                  effectiveWallThemeProvider,
                                                )
                                                .ropeGlow,
                                          ),
                                        ),
                                      ),
                                    ),
                                    for (final item in displayWallItems)
                                      if (onScreen(
                                        _toBoardLocal(item.wallPosition),
                                        item.id,
                                      ))
                                        switch (item.type) {
                                          WallItemType.text =>
                                            WallTextNoteWidget(
                                              item: _toBoardLocalWallItem(item),
                                              windValue: _windController.value,
                                              isDragging:
                                                  _draggingNodeId == item.id,
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
                                              onPointerDown: _lockWallGestures,
                                              onPointerUp: _unlockWallGestures,
                                              onDragStart: () => _startDrag(
                                                item.id,
                                                item.wallPosition,
                                                _DragTargetKind.wallItem,
                                              ),
                                              onDragUpdate: (delta) =>
                                                  _updateDrag(item.id, delta),
                                              onDragEnd: () =>
                                                  _endDrag(repository, item.id),
                                            ),
                                          WallItemType.nail => WallNailWidget(
                                            item: _toBoardLocalWallItem(item),
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
                                            onDragUpdate: (delta) =>
                                                _updateDrag(item.id, delta),
                                            onDragEnd: () =>
                                                _endDrag(repository, item.id),
                                          ),
                                        },
                                    for (final event in leavingEvents)
                                      if (onScreen(
                                        _toBoardLocal(event.wallPosition),
                                        event.id,
                                      ))
                                        MemoryCard(
                                          key: ValueKey('leaving-${event.id}'),
                                          event: _toBoardLocalMemory(event),
                                          windValue: _windController.value,
                                          isDragging: false,
                                          hasConnection: false,
                                          opacity: 1 - _transitionValue,
                                          interactive: false,
                                          onTap: () {},
                                          onLongPress: () {},
                                          onEdit: () {},
                                          onConnect: () {},
                                          onPointerDown: () {},
                                          onPointerUp: () {},
                                          onDragStart: () {},
                                          onDragUpdate: (_) {},
                                          onDragEnd: () {},
                                        ),
                                    for (final event in filteredEvents)
                                      if (onScreen(
                                        _toBoardLocal(event.wallPosition),
                                        event.id,
                                      ))
                                        MemoryCard(
                                          coachId: event.id == tourCardMemoryId
                                              ? TourTargets.card
                                              : null,
                                          event: _toBoardLocalMemory(event),
                                          windValue: _windController.value,
                                          // New in this category: fades in.
                                          opacity:
                                              _transitionFilter != null &&
                                                  !(_transitionFrom
                                                          ?.containsKey(
                                                            event.id,
                                                          ) ??
                                                      true)
                                              ? _transitionValue
                                              : 1,
                                          isDragging:
                                              _draggingNodeId == event.id,
                                          hasConnection: connectedMemoryIds
                                              .contains(event.id),
                                          onTap: () {
                                            _markHintSeen();
                                            _pushRoute('/memories/${event.id}');
                                          },
                                          onLongPress: () => _showMemoryMenu(
                                            context,
                                            event.id,
                                          ),
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
                                          onDragUpdate: (delta) =>
                                              _updateDrag(event.id, delta),
                                          onDragEnd: () =>
                                              _endDrag(repository, event.id),
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
                          topPadding: _topBarSpace,
                          onAdd: () => _guardMemoryCreation(
                            canCreateMemory,
                            () => _pushRoute(RouteNames.addMemory),
                          ),
                          onShowAll: _filter == WallFilter.all
                              ? null
                              : () => setState(() => _filter = WallFilter.all),
                        ),
                      )
                    else
                      Positioned.fill(
                        child: _MapView(
                          events: filteredEvents,
                          topPadding: _topBarSpace,
                          onAdd: () => _guardMemoryCreation(
                            canCreateMemory,
                            () => _pushRoute(RouteNames.addMemory),
                          ),
                          onShowAll: _filter == WallFilter.all
                              ? null
                              : () => setState(() => _filter = WallFilter.all),
                        ),
                      ),
                    if (_mode == _WallViewMode.wall &&
                        filteredEvents.isEmpty &&
                        state.events.isNotEmpty)
                      Center(
                        child: Text(
                          context.l10n.noMemoriesFilter,
                          style: TextStyle(
                            color: AppColors.muted,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    Positioned(
                      left: 16,
                      right: 16,
                      top: 12,
                      child: _WallTopBar(
                        selectedMode: _mode,
                        // Dot on "View" when cards are hidden or rearranged.
                        hasCustomView:
                            _filter != WallFilter.all ||
                            (_mode == _WallViewMode.wall &&
                                _layoutMode != WallLayoutMode.freeform),
                        wallSwitcher: showWallSwitcher
                            ? const WallSwitcherButton()
                            : null,
                        onOpenView: () => _showViewSheet(context),
                        onSearch: () => _pushRoute(RouteNames.search),
                        onMoreAction: (action) => switch (action) {
                          _MoreAction.story => _pushRoute(
                            RouteNames.createStory,
                          ),
                          _MoreAction.yearThread => _pushRoute(
                            RouteNames.yearThread,
                          ),
                          _MoreAction.lookBack => _pushRoute(
                            RouteNames.lookBack,
                          ),
                          _MoreAction.newWall => createNewWall(context),
                          _MoreAction.familyWalls => _pushRoute(
                            RouteNames.familyWalls,
                          ),
                          _MoreAction.display => _displayWall(context, state),
                          _MoreAction.help => showLifeThreadsTutorialSheet(
                            context,
                          ),
                          _MoreAction.settings => _pushRoute(
                            RouteNames.settings,
                          ),
                        },
                      ),
                    ),
                    // Demo or backup banner, then the first-run hint.
                    Positioned(
                      left: 16,
                      right: 16,
                      top: _bannerTop,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // The tour explains the demo memories itself and
                          // asks about them at the end.
                          if (state.isDemoOnly && !appTourRunning)
                            _DemoWallBanner(
                              onClear: () =>
                                  _clearDemoWall(context, repository),
                            )
                          else if (backupReminder != null &&
                              backupReminder.shouldRemind(allState.events))
                            _BackupReminderBanner(
                              // A backup holds every wall and hidden memory,
                              // not just what is on screen.
                              unsavedCount: backupReminder.unsavedMemories(
                                allState.events,
                              ),
                              onBackUp: () => _exportBackup(context, allState),
                              onLater: () => ref
                                  .read(backupReminderProvider.notifier)
                                  .snooze(),
                            ),
                          // The tour says the same in its bubble; the hint
                          // would sit inside the ring around the first card.
                          if (hasWallContent &&
                              _mode == _WallViewMode.wall &&
                              !appTourRunning &&
                              ref.watch(wallHintSeenProvider).asData?.value ==
                                  false)
                            const Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: _WallInteractionHint(),
                            ),
                        ],
                      ),
                    ),
                    if (hasWallContent && _mode == _WallViewMode.wall)
                      // Thread of the Year in December and January; the
                      // month before in the first week of a month.
                      const Positioned(
                        left: 20,
                        right: 20,
                        bottom: 100,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [YearThreadWallCard(), LookBackWallCard()],
                        ),
                      ),
                    if (hasWallContent)
                      Positioned(
                        left: 20,
                        right: 20,
                        bottom: 24,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: _MemoryRitualCard(
                                // A memory from this day in an earlier year
                                // comes first.
                                // Then one from this week in an earlier year.
                                event:
                                    onThisDay?.memory ??
                                    _thisWeekEarlier(state.events)?.memory ??
                                    _memoryToRevisit(state.events),
                                yearsAgo: onThisDay?.yearsAgo,
                                weekYearsAgo: onThisDay == null
                                    ? _thisWeekEarlier(state.events)?.years
                                    : null,
                                onSave: () => _guardMemoryCreation(
                                  canCreateMemory,
                                  () => _pushRoute(RouteNames.addMemory),
                                ),
                                onOpen: (event) =>
                                    _pushRoute('/memories/${event.id}'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            CoachTarget(
                              id: TourTargets.camera,
                              child: _CameraCaptureFab(
                                onPressed: _isCapturingPhotos
                                    ? null
                                    : () => _guardMemoryCreation(
                                        canCreateMemory,
                                        () => _capturePhotosForNewMemory(),
                                      ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ExpandableAddButton(
                              onAddEvent: () => _guardMemoryCreation(
                                canCreateMemory,
                                _addMemory,
                              ),
                              onAddQuickPhoto: () => _guardMemoryCreation(
                                canCreateMemory,
                                () => _createQuickPhotoMemory(
                                  context,
                                  repository,
                                ),
                              ),
                              onAddText: () =>
                                  _createTextNote(context, repository),
                              onAddNail: () => _createNail(context, repository),
                            ),
                          ],
                        ),
                      )
                    else
                      Positioned(
                        right: 20,
                        bottom: 24,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            CoachTarget(
                              id: TourTargets.camera,
                              child: _CameraCaptureFab(
                                onPressed: _isCapturingPhotos
                                    ? null
                                    : () => _guardMemoryCreation(
                                        canCreateMemory,
                                        () => _capturePhotosForNewMemory(),
                                      ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ExpandableAddButton(
                              onAddEvent: () => _guardMemoryCreation(
                                canCreateMemory,
                                _addMemory,
                              ),
                              onAddQuickPhoto: () => _guardMemoryCreation(
                                canCreateMemory,
                                () => _createQuickPhotoMemory(
                                  context,
                                  repository,
                                ),
                              ),
                              onAddText: () =>
                                  _createTextNote(context, repository),
                              onAddNail: () => _createNail(context, repository),
                            ),
                          ],
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

  /// How far the View transition is, eased.
  double get _transitionValue =>
      Curves.easeInOutCubic.transform(_viewTransition.value);

  /// During the View transition: [event] on its way from where it was to
  /// its new place.
  MemoryEvent _inTransition(MemoryEvent event) {
    final start = _transitionFrom?[event.id];
    if (start == null || event.id == _draggingNodeId) return event;
    return event.copyWith(
      wallPosition: Offset.lerp(start, event.wallPosition, _transitionValue),
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

  /// A memory from within 3 days of today's date in an earlier year (the
  /// nearest date, then the most recent year), when none is from today.
  ({MemoryEvent memory, int years})? _thisWeekEarlier(
    List<MemoryEvent> events,
  ) {
    final today = ref.read(onThisDayClockProvider)();
    ({MemoryEvent memory, int years, int distance})? best;
    for (final event in events) {
      final years = today.year - event.occurredAt.year;
      if (years < 1) continue;
      final sameDay = DateTime(
        today.year,
        event.occurredAt.month,
        event.occurredAt.day,
      );
      final distance = sameDay
          .difference(DateTime(today.year, today.month, today.day))
          .inDays
          .abs();
      if (distance == 0 || distance > 3) continue;
      if (best == null ||
          distance < best.distance ||
          (distance == best.distance && years < best.years)) {
        best = (memory: event, years: years, distance: distance);
      }
    }
    return best == null ? null : (memory: best.memory, years: best.years);
  }

  MemoryEvent? _memoryToRevisit(List<MemoryEvent> events) {
    if (events.isEmpty) return null;
    final sorted = [...events]
      ..sort((first, second) => first.occurredAt.compareTo(second.occurredAt));
    final today = DateTime.now();
    for (final event in sorted) {
      if (!_sameDate(event.occurredAt, today)) return event;
    }
    return sorted.first;
  }

  bool _sameDate(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
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

  void _lockWallGestures() {
    if (!mounted || _nodePointerIsDown) return;
    // Sync flag first so any same-frame logic sees the lock; setState disables
    // InteractiveViewer pan/scale before the finger moves far.
    _nodePointerIsDown = true;
    setState(() {});
  }

  void _unlockWallGestures() {
    if (!mounted || !_nodePointerIsDown) return;
    _nodePointerIsDown = false;
    setState(() {});
  }

  void _markHintSeen() {
    ref.read(wallHintSeenProvider.notifier).markSeen();
  }

  /// Whether the wall on screen has hidden memories.
  bool _wallHasHidden() {
    final all = ref.read(memoryRepositoryProvider).asData?.value;
    return all?.events.any((e) => e.hidden && e.wallId == _shownWallId) ??
        false;
  }

  /// Showing hidden memories asks for Face ID (or the passcode) first,
  /// where the phone has one. Returns whether they are shown now.
  /// Whether hidden memories may be shown: after Face ID or the passcode.
  /// The wall shows them once the View sheet is closed with Done.
  Future<bool> _authorizeHidden(bool show) async {
    if (!show) return true;
    final auth = ref.read(appLockAuthProvider);
    final reason = context.l10n.showHiddenReason;
    return !await auth.isAvailable() || await auth.authenticate(reason);
  }

  /// The View sheet: the wall changes only with Done; closing it any other
  /// way leaves the wall as it was.
  Future<void> _showViewSheet(BuildContext context) async {
    final choice = await showModalBottomSheet<_ViewChoice>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _WallViewSheet(
        current: _ViewChoice(
          mode: _mode,
          layout: _layoutMode,
          filter: _filter,
          showHidden: _showHidden,
        ),
        hasHidden: _wallHasHidden(),
        onAuthorizeHidden: _authorizeHidden,
      ),
    );
    if (choice == null || !mounted) return;
    _applyView(choice);
    if (choice.tidy) await _tidyUp();
  }

  /// Asks, then rehangs every card of this wall neatly (oldest first); the
  /// cards glide to their new places, and Undo puts them back.
  Future<void> _tidyUp() async {
    final l10n = context.l10n;
    final sure = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.wallTidyUp),
        content: Text(l10n.wallTidyUpBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            key: const ValueKey('wall-tidy-up-confirm'),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.wallTidyUpAction),
          ),
        ],
      ),
    );
    if (sure != true || !mounted) return;
    final repository = ref.read(memoryRepositoryProvider.notifier);
    final messenger = ScaffoldMessenger.of(context);
    void glide() {
      if (MediaQuery.disableAnimationsOf(context)) return;
      setState(() {
        _transitionFrom = Map.of(_shownPositions);
        _transitionFilter = null;
        _viewTransition.forward(from: 0);
      });
    }

    glide();
    final before = await repository.tidyWall(activeWallId(ref));
    if (!mounted || before.isEmpty) return;
    messenger.showToast(
      l10n.wallTidiedToast,
      kind: ToastKind.success,
      action: ToastAction(
        label: l10n.undo,
        onPressed: () {
          if (mounted) glide();
          unawaited(repository.moveMemories(before));
        },
      ),
    );
  }

  /// Applies the View sheet's choice. On the wall, a new arrangement moves
  /// the cards from where they were and a new category fades cards out and
  /// in (not with Reduce Motion).
  void _applyView(_ViewChoice choice) {
    final rearranged = choice.layout != _layoutMode;
    final refiltered = choice.filter != _filter;
    final animate =
        choice.mode == _WallViewMode.wall &&
        _mode == _WallViewMode.wall &&
        (rearranged || refiltered) &&
        !MediaQuery.disableAnimationsOf(context);
    setState(() {
      if (animate) {
        _transitionFrom = Map.of(_shownPositions);
        _transitionFilter = refiltered ? _filter : null;
        _viewTransition.forward(from: 0);
      }
      _mode = choice.mode;
      _layoutMode = choice.layout;
      _filter = choice.filter;
      _showHidden = choice.showHidden;
    });
  }

  void _startDrag(String nodeId, Offset startPosition, _DragTargetKind kind) {
    _markHintSeen();
    if (!mounted || _isRouteTransitioning) return;
    // One node at a time: a second finger on another card doesn't take over.
    if (_draggingNodeId != null && _draggingNodeId != nodeId) return;
    HapticFeedback.selectionClick();
    _nodePointerIsDown = true;
    setState(() {
      _draggingNodeId = nodeId;
      _draggingKind = kind;
      _pendingDragPosition = startPosition;
    });
  }

  void _updateDrag(String nodeId, Offset globalDelta) {
    final current = _pendingDragPosition;
    if (!mounted || current == null || _draggingNodeId != nodeId) return;
    // globalDelta is screen-space so it stays correct even if the viewer pans.
    final scale = _viewportScale().clamp(0.01, 10.0);
    setState(() => _pendingDragPosition = current + globalDelta / scale);
  }

  /// Zoom of the wall viewport, read from the x axis. getMaxScaleOnAxis()
  /// is wrong here when the z axis isn't scaled along with x and y.
  double _viewportScale() {
    final m = _wallController.value;
    return math.sqrt(
      m.entry(0, 0) * m.entry(0, 0) + m.entry(1, 0) * m.entry(1, 0),
    );
  }

  Future<void> _endDrag(MemoryRepository repository, String endedNodeId) async {
    // A release from a node that isn't the active drag (e.g. a second finger)
    // must not end or save the active one.
    if (_draggingNodeId != null && _draggingNodeId != endedNodeId) return;

    final nodeId = _draggingNodeId;
    final position = _pendingDragPosition;
    final kind = _draggingKind;

    if (nodeId == null || position == null || kind == null) {
      _unlockWallGestures();
      if (mounted) {
        setState(() {
          _draggingNodeId = null;
          _draggingKind = null;
          _pendingDragPosition = null;
        });
      }
      return;
    }

    // The move applies to the repository state synchronously; only the
    // database write is awaited below.
    final Future<void> save;
    switch (kind) {
      case _DragTargetKind.memory:
        _manualLayoutOverrides.putIfAbsent(_layoutMode, () => {})[nodeId] =
            position;
        // Computed layouts place cards themselves; a nudge there stays for
        // this session instead of overwriting the hand-made freeform spot.
        save = _layoutMode == WallLayoutMode.freeform
            ? repository.moveMemory(nodeId, position)
            : Future<void>.value();
      case _DragTargetKind.wallItem:
        save = repository.moveWallItem(nodeId, position);
    }

    // The card lands on the wall.
    HapticFeedback.lightImpact();

    // End the drag now, not after the save: a slow write must not clear a
    // drag the user has started on another node in the meantime.
    _draggingNodeId = null;
    _draggingKind = null;
    _pendingDragPosition = null;
    _nodePointerIsDown = false;
    if (mounted) setState(() {});

    try {
      await save;
    } catch (error, stackTrace) {
      AppLogger.recordCrash(error, stackTrace);
    }
  }

  Offset _defaultDropPosition(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final local = _wallController.toScene(
      Offset(size.width * 0.58, size.height * 0.58),
    );
    // Convert board-local scene coords back to free wall coordinates.
    final near = local + _boardOrigin - const Offset(90, 70);
    // Starts in a free spot near the middle of the screen, not on a card.
    final wall = activeWallId(ref);
    final state = ref.read(memoryRepositoryProvider).asData?.value;
    if (state == null) return near;
    return WallPlacement.freeSpotNear([
      for (final event in state.events)
        if (event.wallId == wall) event.wallPosition,
      for (final item in state.wallItems)
        if (item.wallId == wall) item.wallPosition,
    ], near);
  }

  /// When the guided tour starts, the wall shows every card in its own
  /// layout and frames the demo cards the tour points at.
  void _onTour({bool initial = false}) {
    final running = appTourRunning;
    if (running && !_tourWasRunning) {
      void reset() {
        _mode = _WallViewMode.wall;
        _filter = WallFilter.all;
        _layoutMode = WallLayoutMode.freeform;
        _showHidden = false;
        _didSetInitialViewport = false;
        _frameTourCards = true;
      }

      if (!initial && mounted) {
        setState(reset);
      } else {
        reset();
      }
    } else if (!running && _tourWasRunning && mounted) {
      // The wall hint comes back after the tour.
      setState(() {});
    }
    _tourWasRunning = running;
  }

  /// Opens Add memory; during the guided tour with the tour's demo picture.
  Future<void> _addMemory() async {
    if (!appTourRunning) return _pushRoute(RouteNames.addMemory);
    final photos = await tourPhotos(context.l10n);
    if (!mounted) return;
    await _pushRoute(RouteNames.addMemory, extra: photos);
  }

  Future<void> _pushRoute(String location, {Object? extra}) async {
    if (!mounted || _isRouteTransitioning || !_isCurrentRoute(context)) return;
    _cancelDrag();
    _isRouteTransitioning = true;
    try {
      await context.push(location, extra: extra);
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

  Future<void> _capturePhotosForNewMemory() async {
    if (_isCapturingPhotos) return;
    setState(() => _isCapturingPhotos = true);

    try {
      final photos = <PickedMemoryPhoto>[];
      final photoService = ref.read(photoLibraryServiceProvider);

      while (mounted) {
        final photo = await photoService.capturePhotoToAppStorage();
        if (!mounted) return;
        if (photo == null) {
          if (photos.isEmpty) return;
          break;
        }

        photos.add(photo);
        final action = await showModalBottomSheet<_CameraSessionAction>(
          context: context,
          backgroundColor: AppColors.panelWarm,
          isDismissible: true,
          enableDrag: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          builder: (sheetContext) {
            final l10n = sheetContext.l10n;
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l10n.photosCapturedCount(photos.length),
                      style: TextStyle(
                        color: AppColors.text,
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.takeAnotherOrContinueBody,
                      style: TextStyle(
                        color: AppColors.muted,
                        fontWeight: FontWeight.w600,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 18),
                    FilledButton.icon(
                      onPressed: () => Navigator.of(
                        sheetContext,
                      ).pop(_CameraSessionAction.takeAnother),
                      icon: const Icon(Icons.photo_camera_rounded),
                      label: Text(l10n.takeAnotherPhoto),
                    ),
                    const SizedBox(height: 10),
                    FilledButton.tonalIcon(
                      onPressed: () => Navigator.of(
                        sheetContext,
                      ).pop(_CameraSessionAction.addToMemory),
                      icon: const Icon(Icons.auto_stories_rounded),
                      label: Text(l10n.addPhotosToMemory),
                    ),
                    const SizedBox(height: 4),
                    TextButton(
                      onPressed: () => Navigator.of(
                        sheetContext,
                      ).pop(_CameraSessionAction.cancel),
                      child: Text(l10n.cancel),
                    ),
                  ],
                ),
              ),
            );
          },
        );

        if (action == _CameraSessionAction.takeAnother) continue;
        if (action == _CameraSessionAction.addToMemory) break;
        return;
      }

      if (!mounted || photos.isEmpty) return;
      await _pushRoute(RouteNames.addMemory, extra: photos);
    } finally {
      if (mounted) {
        setState(() => _isCapturingPhotos = false);
      } else {
        _isCapturingPhotos = false;
      }
    }
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

  Future<void> _createTextNote(
    BuildContext context,
    MemoryRepository repository,
  ) async {
    final text = await showDialog<String>(
      context: context,
      builder: (_) => _TextNoteDialog(
        title: context.l10n.addTextToWall,
        actionLabel: context.l10n.addTextAction,
        hintText: context.l10n.textNoteHint,
      ),
    );

    final trimmed = text?.trim();
    if (!context.mounted || trimmed == null || trimmed.isEmpty) return;
    final position = await _previewPlacement(
      context,
      title: context.l10n.placeTextNote,
      subtitle: trimmed,
      icon: Icons.sticky_note_2_rounded,
      color: AppColors.cardDark,
      initialPosition: _defaultDropPosition(context),
    );
    if (!context.mounted || position == null) return;
    await repository.addTextNote(
      text: trimmed,
      position: position,
      wallId: activeWallId(ref),
    );
  }

  Future<void> _createNail(
    BuildContext context,
    MemoryRepository repository,
  ) async {
    final position = await _previewPlacement(
      context,
      title: context.l10n.placeRopeAnchor,
      subtitle: context.l10n.nailSubtitle,
      icon: Icons.push_pin_rounded,
      color: AppColors.gold,
      initialPosition: _defaultDropPosition(context),
    );
    if (!context.mounted || position == null) return;
    await repository.addNail(position: position, wallId: activeWallId(ref));
  }

  Future<void> _createQuickPhotoMemory(
    BuildContext context,
    MemoryRepository repository,
  ) async {
    final service = ref.read(photoLibraryServiceProvider);
    final source = await showModalBottomSheet<_QuickPhotoSource>(
      context: context,
      showDragHandle: true,
      builder: (_) => const _QuickPhotoSourceSheet(),
    );
    if (!context.mounted || source == null) return;

    PickedMemoryPhoto? picked;
    switch (source) {
      case _QuickPhotoSource.camera:
        picked = await service.capturePhotoToAppStorage();
      case _QuickPhotoSource.gallery:
        var permission = await service.currentPermission();
        if (!permission.hasAccess) {
          permission = await service.requestPermission();
        }
        if (!context.mounted) return;

        if (!permission.hasAccess) {
          ScaffoldMessenger.of(
            context,
          ).showToast(context.l10n.photoAccessNeeded, kind: ToastKind.error);
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

        picked = await service.copyAssetToAppStorage(asset);
    }
    if (!context.mounted || picked == null) return;

    final title =
        _cleanPhotoTitle(picked.title) ?? context.l10n.quickPhotoMemory;
    // Looked up while the photo is placed on the wall.
    final locationLabel = placeLabelFor(
      ref.read(placeNameLookupProvider),
      picked.hasLocation ? picked.latitude : null,
      picked.hasLocation ? picked.longitude : null,
      Localizations.localeOf(context),
    );
    final position = await _previewPlacement(
      context,
      title: context.l10n.hangQuickPhoto,
      subtitle: title,
      icon: Icons.add_photo_alternate_rounded,
      color: AppColors.gold,
      initialPosition: _defaultDropPosition(context),
    );
    if (!context.mounted || position == null) return;
    final place = await locationLabel;
    if (!context.mounted) return;

    // Hung on the wall.
    HapticFeedback.mediumImpact();
    await repository.addMemory(
      NewMemoryDraft(
        title: title,
        description: context.l10n.quickPhotoDescription,
        category: MemoryCategory.personal,
        memoryType: MemoryType.moment,
        feeling: MemoryFeeling.warm,
        occurredAt: picked.capturedAt,
        locationLabel: place,
        latitude: picked.latitude,
        longitude: picked.longitude,
        coverPhotoPath: picked.localPath,
        wallPosition: position,
        wallId: activeWallId(ref),
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
        title: Text(context.l10n.clearDemoWallQuestion),
        content: Text(context.l10n.clearDemoWallBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(context.l10n.startFresh),
          ),
        ],
      ),
    );
    if (!context.mounted || confirmed != true) return;
    await repository.clearDemoWall();
  }

  Future<void> _exportBackup(BuildContext context, MemoryState state) async {
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
      await shareExportedArchive(
        context,
        result,
        onSaved: ref.read(backupReminderProvider.notifier).markSaved,
      );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showToast(context.l10n.exportFailed('$error'), kind: ToastKind.error);
    }
  }

  Future<void> _displayWall(BuildContext context, MemoryState state) async {
    final l10n = context.l10n;

    if (state.events.isEmpty) {
      ScaffoldMessenger.of(context).showToast(l10n.addMemoryBeforeDisplay);
      return;
    }

    final scanUri = await showWallDisplayScanner(context);
    if (!context.mounted || scanUri == null) return;

    final service = ref.read(wallDisplayServiceProvider);
    if (!service.isDisplayScanLink(scanUri)) {
      ScaffoldMessenger.of(
        context,
      ).showToast(l10n.notLifeThreadsDisplayQr, kind: ToastKind.error);
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.displayWallQuestion),
        content: Text(l10n.displayWallBody(state.events.length)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.of(context).pop(true),
            icon: const Icon(Icons.desktop_windows_rounded),
            label: Text(l10n.displayAction),
          ),
        ],
      ),
    );
    if (!context.mounted || confirmed != true) return;

    var progressVisible = false;
    try {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        // Back must not dismiss it: the caller pops it when work finishes.
        builder: (_) =>
            const PopScope(canPop: false, child: _WallDisplayProgressDialog()),
      );
      progressVisible = true;

      final result = await service.publishSnapshot(
        scanUri: scanUri,
        state: state,
      );
      if (!context.mounted) return;
      if (progressVisible) {
        Navigator.of(context, rootNavigator: true).pop();
        progressVisible = false;
      }
      final expires = result.expiresAt == null
          ? l10n.soon
          : '${result.expiresAt!.hour.toString().padLeft(2, '0')}:${result.expiresAt!.minute.toString().padLeft(2, '0')}';
      ScaffoldMessenger.of(context).showToast(
        l10n.wallDisplayLive(result.memoryCount, expires),
        kind: ToastKind.success,
      );
    } on WallDisplayException catch (error) {
      if (context.mounted && progressVisible) {
        Navigator.of(context, rootNavigator: true).pop();
        progressVisible = false;
      }
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showToast(error.message, kind: ToastKind.error);
    } finally {
      if (context.mounted && progressVisible) {
        Navigator.of(context, rootNavigator: true).pop();
      }
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
        canvasSize: WallAttachmentLayout.canvasSize,
        initialPosition: initialPosition,
      ),
    );
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
      // The cards' outer edges plus the same margin on both sides, so the
      // first and last column are equally far from the screen edges.
      final minX =
          positions
              .map((position) => position.dx)
              .reduce((a, b) => a < b ? a : b) -
          20;
      final maxX =
          positions
              .map((position) => position.dx)
              .reduce((a, b) => a > b ? a : b) +
          MemoryCard.visualSize.width +
          20;
      final minY = positions
          .map((position) => position.dy)
          .reduce((a, b) => a < b ? a : b);
      final contentWidth = maxX - minX;
      final fitScale = size.width / (contentWidth + 120);
      final mobile = size.width < 520;
      // Narrow phones (iPhone 16/17 Pro: 402 pt) need a little more zoom-out
      // to show three columns without cutting off the outer cards.
      final scale = mobile
          ? fitScale.clamp(0.56, 0.9)
          : fitScale.clamp(0.5, 0.9);
      final headerSpace = mobile ? 116.0 : 132.0;
      final translateX =
          ((size.width - contentWidth * scale) / 2) - minX * scale;
      final translateY = headerSpace - minY * scale;

      _wallController.value = Matrix4.identity()
        ..translateByDouble(translateX, translateY, 0, 1)
        ..scaleByDouble(scale, scale, scale, 1);
    });
  }

  Future<void> _showMemoryMenu(BuildContext context, String memoryId) async {
    final repository = ref.read(memoryRepositoryProvider.notifier);
    final all = ref.read(memoryRepositoryProvider).asData?.value;
    final memory = all?.findEvent(memoryId);
    final hasOwnWalls = all?.walls.isNotEmpty ?? false;
    final action = await showModalBottomSheet<_MemoryAction>(
      context: context,
      showDragHandle: true,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.open_in_new_rounded),
              title: Text(context.l10n.open),
              onTap: () => Navigator.of(context).pop(_MemoryAction.open),
            ),
            ListTile(
              leading: const Icon(Icons.edit_rounded),
              title: Text(context.l10n.edit),
              onTap: () => Navigator.of(context).pop(_MemoryAction.edit),
            ),
            ListTile(
              leading: const Icon(Icons.hub_rounded),
              title: Text(context.l10n.connect),
              onTap: () => Navigator.of(context).pop(_MemoryAction.connect),
            ),
            ListTile(
              leading: const Icon(Icons.auto_stories_rounded),
              title: Text(context.l10n.createStory),
              onTap: () => Navigator.of(context).pop(_MemoryAction.story),
            ),
            if (hasOwnWalls)
              ListTile(
                leading: const Icon(Icons.drive_file_move_rounded),
                title: Text(context.l10n.moveToWall),
                onTap: () =>
                    Navigator.of(context).pop(_MemoryAction.moveToWall),
              ),
            ListTile(
              leading: Icon(
                memory?.hidden ?? false
                    ? Icons.visibility_rounded
                    : Icons.visibility_off_rounded,
              ),
              title: Text(
                memory?.hidden ?? false
                    ? context.l10n.unhideMemory
                    : context.l10n.hideMemory,
              ),
              onTap: () => Navigator.of(context).pop(_MemoryAction.hide),
            ),
            ListTile(
              leading: const Icon(
                Icons.delete_outline_rounded,
                color: AppColors.error,
              ),
              title: Text(
                context.l10n.delete,
                style: const TextStyle(color: AppColors.error),
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
      case _MemoryAction.story:
        await _pushRoute(RouteNames.createStory, extra: memoryId);
      case _MemoryAction.moveToWall:
        await _moveToWall(context, repository, memoryId);
      case _MemoryAction.hide:
        final hide = !(memory?.hidden ?? false);
        final messenger = ScaffoldMessenger.of(context);
        final hiddenText = context.l10n.memoryHiddenToast;
        await repository.setHidden(memoryId, hidden: hide);
        if (hide) messenger.showToast(hiddenText);
      case _MemoryAction.delete:
        await _removeWithUndo(
          context,
          repository,
          () => repository.removeMemory(memoryId),
          context.l10n.memoryDeletedToast,
        );
    }
  }

  /// On an empty wall of one's own: pick memories from other walls and move
  /// them here.
  Future<void> _moveMemoriesHere(BuildContext context, String wallId) async {
    final all = ref.read(memoryRepositoryProvider).asData?.value;
    if (all == null) return;
    final candidates = [
      for (final event in all.visibleEvents)
        if (event.wallId != wallId) event,
    ]..sort((a, b) => b.occurredAt.compareTo(a.occurredAt));
    final chosen = await showModalBottomSheet<Set<String>>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => _MoveHereSheet(memories: candidates, walls: all.walls),
    );
    if (chosen == null || chosen.isEmpty) return;
    final repository = ref.read(memoryRepositoryProvider.notifier);
    for (final id in chosen) {
      await repository.moveMemoryToWall(id, wallId);
    }
  }

  /// Moves a memory to "My wall" or another wall of one's own.
  Future<void> _moveToWall(
    BuildContext context,
    MemoryRepository repository,
    String memoryId,
  ) async {
    final l10n = context.l10n;
    final all = ref.read(memoryRepositoryProvider).asData?.value;
    final memory = all?.findEvent(memoryId);
    if (all == null || memory == null) return;
    final target = await showModalBottomSheet<({String? id, String name})>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(
                l10n.moveToWall,
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
            if (memory.wallId != null)
              ListTile(
                leading: const Icon(Icons.person_rounded),
                title: Text(l10n.myWall),
                onTap: () => Navigator.of(
                  sheetContext,
                ).pop((id: null, name: l10n.myWall)),
              ),
            for (final wall in all.walls)
              if (wall.id != memory.wallId)
                ListTile(
                  leading: const Icon(Icons.dashboard_rounded),
                  title: Text(wall.name),
                  onTap: () => Navigator.of(
                    sheetContext,
                  ).pop((id: wall.id, name: wall.name)),
                ),
          ],
        ),
      ),
    );
    if (target == null || !context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    final moved = l10n.movedToWall(target.name);
    await repository.moveMemoryToWall(memoryId, target.id);
    messenger.showToast(moved, kind: ToastKind.success);
  }

  /// Removes at once and offers "Undo" for a few seconds, instead of asking
  /// "Are you sure?" first. Photo files are deleted once it can't be undone.
  Future<void> _removeWithUndo(
    BuildContext context,
    MemoryRepository repository,
    Future<RemovedFromWall> Function() remove,
    String message,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final undoLabel = context.l10n.undo;
    final removed = await remove();
    var undone = false;
    // The standard time for a toast with a button (9 seconds).
    final toast = messenger.showToast(
      message,
      action: ToastAction(
        label: undoLabel,
        onPressed: () {
          undone = true;
          repository.restore(removed);
        },
      ),
    );
    await toast.closed;
    if (!undone) await repository.forget(removed);
  }

  Future<void> _showTextMenu(
    BuildContext context,
    MemoryState state,
    WallItem item,
  ) async {
    final repository = ref.read(memoryRepositoryProvider.notifier);
    final sourceItem = _sourceWallItem(item, state);
    final action = await showModalBottomSheet<_TextAction>(
      context: context,
      showDragHandle: true,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_note_rounded),
              title: Text(context.l10n.editTextTitle),
              onTap: () => Navigator.of(context).pop(_TextAction.edit),
            ),
            ListTile(
              leading: const Icon(
                Icons.delete_outline_rounded,
                color: AppColors.error,
              ),
              title: Text(
                context.l10n.delete,
                style: const TextStyle(color: AppColors.error),
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
      case _TextAction.delete:
        await _removeWithUndo(
          context,
          repository,
          () => repository.removeWallItem(sourceItem.id),
          context.l10n.noteDeletedToast,
        );
    }
  }

  Future<void> _editTextNote(
    BuildContext context,
    MemoryRepository repository,
    WallItem item,
  ) async {
    final text = await showDialog<String>(
      context: context,
      builder: (_) => _TextNoteDialog(
        title: context.l10n.editText,
        actionLabel: context.l10n.save,
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
              title: Text(context.l10n.connectRope),
              subtitle: Text(context.l10n.connectRopeSubtitle),
              onTap: () => Navigator.of(context).pop(_NailAction.connect),
            ),
            ListTile(
              leading: const Icon(
                Icons.delete_outline_rounded,
                color: AppColors.error,
              ),
              title: Text(
                context.l10n.deleteNail,
                style: const TextStyle(color: AppColors.error),
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
        await _removeWithUndo(
          context,
          repository,
          () => repository.removeWallItem(nail.id),
          context.l10n.nailDeletedToast,
        );
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
              ListTile(
                title: Text(context.l10n.connectNailTitle),
                subtitle: Text(context.l10n.connectNailSubtitle),
              ),
              for (final event in state.events)
                SwitchListTile(
                  value: selectedIds.contains(event.id),
                  title: Text(event.title),
                  subtitle: Text(_eventLocationSubtitle(context, event)),
                  onChanged: (value) {
                    setModalState(() {
                      if (value) {
                        selectedIds.add(event.id);
                      } else {
                        selectedIds.remove(event.id);
                      }
                    });
                    if (value) HapticFeedback.mediumImpact();
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
  const _TimelineView({
    required this.events,
    required this.topPadding,
    required this.onAdd,
    this.onShowAll,
  });

  final List<MemoryEvent> events;
  final double topPadding;
  final VoidCallback onAdd;

  /// Set when a category filter hides everything.
  final VoidCallback? onShowAll;

  @override
  Widget build(BuildContext context) {
    final sorted = [...events]
      ..sort((a, b) => b.occurredAt.compareTo(a.occurredAt));
    // Newest year first; each year's heading stays at the top while its
    // memories scroll by.
    final years = <int, List<MemoryEvent>>{};
    for (final event in sorted) {
      years.putIfAbsent(event.occurredAt.year, () => []).add(event);
    }

    // Starts below the wall's top bar, so the year headings pin under it.
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: ClipRect(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              sliver: SliverToBoxAdapter(
                child: _ViewTitle(
                  icon: Icons.timeline_rounded,
                  title: context.l10n.timelineTitle,
                  subtitle: context.l10n.timelineSubtitle,
                ),
              ),
            ),
            if (sorted.isEmpty)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
                sliver: SliverToBoxAdapter(
                  child: _EmptyModePanel(
                    icon: Icons.timeline_rounded,
                    title: context.l10n.noMemoriesFilter,
                    subtitle: context.l10n.noMemoriesFilterBody,
                    primary: (
                      label: context.l10n.addAMemory,
                      icon: Icons.add_rounded,
                      onTap: onAdd,
                    ),
                    secondary: onShowAll == null
                        ? null
                        : (
                            label: context.l10n.showAllMemories,
                            icon: Icons.filter_alt_off_rounded,
                            onTap: onShowAll!,
                          ),
                  ),
                ),
              )
            else
              for (final MapEntry(key: year, value: memories) in years.entries)
                SliverMainAxisGroup(
                  slivers: [
                    PinnedHeaderSliver(
                      child: _TimelineYearHeader(
                        year: year,
                        count: memories.length,
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 18),
                      sliver: SliverList.list(
                        children: [
                          for (var i = 0; i < memories.length; i++)
                            _TimelineMemoryTile(
                              event: memories[i],
                              isLast: i == memories.length - 1,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}

/// A year in the timeline, pinned while that year's memories scroll by.
class _TimelineYearHeader extends StatelessWidget {
  const _TimelineYearHeader({required this.year, required this.count});

  final int year;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: ColoredBox(
        color: AppColors.wallInk.withValues(alpha: 0.94),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$year',
                style: TextStyle(
                  color: AppColors.gold,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                context.l10n.yearThreadMemories(count),
                style: TextStyle(
                  color: AppColors.muted,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
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
                              _formatTimelineDate(context, event.occurredAt),
                              style: TextStyle(
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
                              _eventTimelineSubtitle(context, event),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
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
  const _MapView({
    required this.events,
    required this.topPadding,
    required this.onAdd,
    this.onShowAll,
  });

  final List<MemoryEvent> events;
  final double topPadding;
  final VoidCallback onAdd;

  /// Set when a category filter hides everything.
  final VoidCallback? onShowAll;

  @override
  Widget build(BuildContext context) {
    final located = events.where((event) => event.hasGeoPoint).toList();

    return Padding(
      padding: EdgeInsets.fromLTRB(20, topPadding, 20, 120),
      child: Column(
        children: [
          _ViewTitle(
            icon: Icons.map_rounded,
            title: context.l10n.memoryMapTitle,
            subtitle: context.l10n.memoryMapSubtitle,
          ),
          const SizedBox(height: 18),
          if (located.isEmpty)
            Expanded(
              child: _EmptyModePanel(
                icon: Icons.location_off_rounded,
                title: context.l10n.noMappedMemories,
                subtitle: context.l10n.noMappedMemoriesBody,
                primary: (
                  label: context.l10n.mapAddPhotoMemory,
                  icon: Icons.add_location_alt_rounded,
                  onTap: onAdd,
                ),
                secondary: onShowAll == null
                    ? null
                    : (
                        label: context.l10n.showAllMemories,
                        icon: Icons.filter_alt_off_rounded,
                        onTap: onShowAll!,
                      ),
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
                  if (event.hasGeoPoint) ...[
                    const SizedBox(height: 3),
                    Text(
                      event.locationDisplayLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: AppColors.muted),
                    ),
                  ],
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
                Text(subtitle, style: TextStyle(color: AppColors.muted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// An empty view never ends there: it says why, and offers what to do.
class _EmptyModePanel extends StatelessWidget {
  const _EmptyModePanel({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.primary,
    this.secondary,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final ({String label, IconData icon, VoidCallback onTap})? primary;
  final ({String label, IconData icon, VoidCallback onTap})? secondary;

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
              style: TextStyle(color: AppColors.muted, height: 1.4),
            ),
            if (primary != null) ...[
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: primary!.onTap,
                  icon: Icon(primary!.icon),
                  label: Text(primary!.label),
                ),
              ),
            ],
            if (secondary != null) ...[
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: secondary!.onTap,
                  icon: Icon(secondary!.icon),
                  label: Text(secondary!.label),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

enum _MoreAction {
  story,
  yearThread,
  lookBack,
  newWall,
  familyWalls,
  display,
  help,
  settings,
}

/// One row at the top of the wall: which wall, how it is shown, and a
/// menu for everything else. It never grows over the cards.
class _WallTopBar extends StatelessWidget {
  const _WallTopBar({
    required this.selectedMode,
    required this.hasCustomView,
    required this.onOpenView,
    required this.onSearch,
    required this.onMoreAction,
    this.wallSwitcher,
  });

  final _WallViewMode selectedMode;
  final bool hasCustomView;
  final VoidCallback onOpenView;
  final VoidCallback onSearch;
  final ValueChanged<_MoreAction> onMoreAction;

  /// "My wall" / family walls, once family walls are in use.
  final Widget? wallSwitcher;

  @override
  Widget build(BuildContext context) {
    // A one-row bar: larger text would cut the labels off.
    return MediaQuery.withClampedTextScaling(
      maxScaleFactor: 1.35,
      child: Row(
        children: [
          Flexible(
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: wallSwitcher ?? const _WallWordmark(),
            ),
          ),
          const SizedBox(width: 8),
          CoachTarget(
            id: TourTargets.search,
            child: _WallSearchButton(onTap: onSearch),
          ),
          const SizedBox(width: 8),
          CoachTarget(
            id: TourTargets.view,
            child: _WallViewButton(
              selectedMode: selectedMode,
              hasCustomView: hasCustomView,
              onTap: onOpenView,
            ),
          ),
          const SizedBox(width: 8),
          CoachTarget(
            id: TourTargets.more,
            child: _WallMoreButton(onSelected: onMoreAction),
          ),
        ],
      ),
    );
  }
}

BoxDecoration _barDecoration(BuildContext context) {
  final scheme = Theme.of(context).colorScheme;
  return BoxDecoration(
    color: scheme.surface.withValues(alpha: 0.86),
    borderRadius: BorderRadius.circular(999),
    border: Border.all(color: scheme.primary.withValues(alpha: 0.24)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.3),
        blurRadius: 20,
        offset: const Offset(0, 10),
      ),
    ],
  );
}

class _WallSearchButton extends StatelessWidget {
  const _WallSearchButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: _barDecoration(context),
      child: IconButton(
        key: const ValueKey('wall-search-button'),
        tooltip: context.l10n.searchTooltip,
        onPressed: onTap,
        icon: Icon(Icons.search_rounded, color: AppColors.card),
        iconSize: 22,
        padding: EdgeInsets.zero,
        style: IconButton.styleFrom(
          fixedSize: const Size(40, 40),
          minimumSize: const Size(40, 40),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }
}

class _WallWordmark extends StatelessWidget {
  const _WallWordmark();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 14, 0),
      decoration: _barDecoration(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.auto_awesome_rounded,
            color: Theme.of(context).colorScheme.primary,
            size: 18,
          ),
          const SizedBox(width: 7),
          const Flexible(
            child: Text(
              'LifeThreads',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WallViewButton extends StatelessWidget {
  const _WallViewButton({
    required this.selectedMode,
    required this.hasCustomView,
    required this.onTap,
  });

  final _WallViewMode selectedMode;
  final bool hasCustomView;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Semantics(
      button: true,
      child: GestureDetector(
        key: const ValueKey('wall-view-button'),
        onTap: onTap,
        child: Container(
          height: 40,
          padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 10, 0),
          decoration: _barDecoration(context),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(selectedMode.icon, color: primary, size: 18),
              const SizedBox(width: 7),
              Text(
                context.l10n.wallViewButton,
                style: TextStyle(
                  color: AppColors.card,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w900,
                ),
              ),
              if (hasCustomView) ...[
                const SizedBox(width: 6),
                Container(
                  key: const ValueKey('wall-view-custom-dot'),
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
              const SizedBox(width: 2),
              Icon(
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

class _WallMoreButton extends StatelessWidget {
  const _WallMoreButton({required this.onSelected});

  final ValueChanged<_MoreAction> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final primary = Theme.of(context).colorScheme.primary;
    PopupMenuItem<_MoreAction> item(
      _MoreAction action,
      IconData icon,
      String label, {
      String? coachId,
    }) {
      final row = Row(
        children: [
          Icon(icon, size: 20, color: primary),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      );
      return PopupMenuItem(
        value: action,
        child: coachId == null ? row : CoachTarget(id: coachId, child: row),
      );
    }

    return DecoratedBox(
      decoration: _barDecoration(context),
      child: PopupMenuButton<_MoreAction>(
        key: const ValueKey('wall-more-button'),
        tooltip: l10n.moreActionsTooltip,
        onSelected: onSelected,
        position: PopupMenuPosition.under,
        color: Theme.of(context).cardTheme.color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        icon: Icon(Icons.more_horiz_rounded, color: AppColors.card),
        iconSize: 22,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 200),
        style: IconButton.styleFrom(
          fixedSize: const Size(40, 40),
          minimumSize: const Size(40, 40),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        itemBuilder: (_) => [
          item(
            _MoreAction.story,
            Icons.auto_stories_rounded,
            l10n.createStory,
            coachId: TourTargets.moreStory,
          ),
          item(
            _MoreAction.yearThread,
            Icons.movie_filter_rounded,
            l10n.yearThreadTitle,
            coachId: TourTargets.moreYear,
          ),
          item(
            _MoreAction.lookBack,
            Icons.calendar_month_rounded,
            l10n.lookBackMenu,
            coachId: TourTargets.moreLookBack,
          ),
          item(
            _MoreAction.newWall,
            Icons.dashboard_customize_rounded,
            l10n.newWall,
            coachId: TourTargets.moreNewWall,
          ),
          item(
            _MoreAction.familyWalls,
            Icons.diversity_1_rounded,
            l10n.familyWallsTitle,
            coachId: TourTargets.moreFamily,
          ),
          item(
            _MoreAction.display,
            Icons.qr_code_scanner_rounded,
            l10n.displayWallTooltip,
          ),
          item(
            _MoreAction.help,
            Icons.help_outline_rounded,
            l10n.tutorialTooltip,
          ),
          item(
            _MoreAction.settings,
            Icons.settings_rounded,
            l10n.settingsTooltip,
            coachId: TourTargets.moreSettings,
          ),
        ],
      ),
    );
  }
}

/// How the wall is shown: view, arrangement and category filter. Changes
/// apply as you tap, so the sheet can stay open while you compare.
/// What the View sheet sets: returned by Done.
class _ViewChoice {
  const _ViewChoice({
    required this.mode,
    required this.layout,
    required this.filter,
    required this.showHidden,
    this.tidy = false,
  });

  final _WallViewMode mode;
  final WallLayoutMode layout;
  final WallFilter filter;
  final bool showHidden;

  /// Rehang the cards neatly (Wand aufräumen).
  final bool tidy;
}

class _WallViewSheet extends StatefulWidget {
  const _WallViewSheet({
    required this.current,
    required this.hasHidden,
    required this.onAuthorizeHidden,
  });

  /// How the wall is shown now.
  final _ViewChoice current;

  /// The wall has hidden memories; the switch shows only then.
  final bool hasHidden;

  /// Whether hidden memories may be shown (Face ID can refuse).
  final Future<bool> Function(bool show) onAuthorizeHidden;

  @override
  State<_WallViewSheet> createState() => _WallViewSheetState();
}

/// Choices stay in the sheet until Done.
class _WallViewSheetState extends State<_WallViewSheet> {
  late var _mode = widget.current.mode;
  late var _layout = widget.current.layout;
  late var _filter = widget.current.filter;
  late var _showHidden = widget.current.showHidden;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Done closes the sheet also when it fills the screen (large
            // text) and for screen reader users.
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.wallViewButton,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                CoachTarget(
                  id: TourTargets.viewDone,
                  child: TextButton(
                    key: const ValueKey('wall-view-done'),
                    onPressed: () => Navigator.of(context).pop(
                      _ViewChoice(
                        mode: _mode,
                        layout: _layout,
                        filter: _filter,
                        showHidden: _showHidden,
                      ),
                    ),
                    child: Text(l10n.done),
                  ),
                ),
              ],
            ),
            _SheetSectionLabel(l10n.wallShowAs),
            CoachTarget(
              id: TourTargets.viewModes,
              child: SegmentedButton<_WallViewMode>(
                key: const ValueKey('wall-mode-segments'),
                expandedInsets: EdgeInsets.zero,
                showSelectedIcon: false,
                style: SegmentedButton.styleFrom(
                  selectedBackgroundColor: scheme.primary,
                  selectedForegroundColor: scheme.onPrimary,
                  foregroundColor: AppColors.muted,
                  side: BorderSide(color: scheme.outline),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 8,
                  ),
                ),
                segments: [
                  for (final mode in _WallViewMode.values)
                    ButtonSegment(
                      value: mode,
                      // Icon above the label: three labels share a phone's
                      // width even in German and Arabic.
                      label: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(mode.icon, size: 20),
                          const SizedBox(height: 3),
                          Text(
                            _wallViewModeLabel(context, mode),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
                selected: {_mode},
                onSelectionChanged: (selection) {
                  setState(() => _mode = selection.single);
                },
              ),
            ),
            if (_mode == _WallViewMode.wall) ...[
              _SheetSectionLabel(l10n.wallArrange),
              _ChoiceGrid(
                columns: 2,
                children: [
                  for (final layout in WallLayoutMode.values)
                    _SheetChoice(
                      selected: _layout == layout,
                      icon: layout.icon,
                      label: _layoutLabel(context, layout),
                      onSelected: () {
                        setState(() => _layout = layout);
                      },
                    ),
                ],
              ),
              // Free arrangement: cards that ended up on top of each other
              // can be hung neatly again.
              if (_layout == WallLayoutMode.freeform)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: OutlinedButton.icon(
                    key: const ValueKey('wall-tidy-up'),
                    onPressed: () => Navigator.of(context).pop(
                      _ViewChoice(
                        mode: _mode,
                        layout: _layout,
                        filter: _filter,
                        showHidden: _showHidden,
                        tidy: true,
                      ),
                    ),
                    icon: const Icon(Icons.auto_fix_high_rounded, size: 18),
                    label: Text(l10n.wallTidyUp),
                  ),
                ),
            ],
            _SheetSectionLabel(l10n.wallShowOnly),
            _ChoiceGrid(
              columns: 4,
              children: [
                for (final filter in WallFilter.values)
                  _SheetChoice(
                    selected: _filter == filter,
                    label: _filterLabel(context, filter),
                    onSelected: () {
                      setState(() => _filter = filter);
                    },
                  ),
              ],
            ),
            if (widget.hasHidden) ...[
              const SizedBox(height: 14),
              // Hidden memories show only after Face ID or the passcode.
              MergeSemantics(
                child: SwitchListTile.adaptive(
                  key: const ValueKey('wall-show-hidden'),
                  contentPadding: EdgeInsets.zero,
                  secondary: Icon(
                    Icons.visibility_off_rounded,
                    color: AppColors.gold,
                  ),
                  title: Text(
                    l10n.showHiddenMemories,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  value: _showHidden,
                  onChanged: (value) async {
                    final allowed = await widget.onAuthorizeHidden(value);
                    if (mounted && allowed) {
                      setState(() => _showHidden = value);
                    }
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _layoutLabel(BuildContext context, WallLayoutMode layout) {
    return switch (layout) {
      WallLayoutMode.freeform => context.l10n.freeformLayout,
      WallLayoutMode.timeline => context.l10n.layoutByDate,
      WallLayoutMode.categoryCluster => context.l10n.categoryLayout,
      WallLayoutMode.locationCluster => context.l10n.locationLayout,
    };
  }

  String _filterLabel(BuildContext context, WallFilter filter) {
    return switch (filter) {
      WallFilter.all => context.l10n.wallFilterAll,
      WallFilter.family => context.l10n.categoryFamily,
      WallFilter.travel => context.l10n.categoryTravel,
      WallFilter.personal => context.l10n.categoryPersonal,
    };
  }
}

String _wallViewModeLabel(BuildContext context, _WallViewMode mode) {
  return switch (mode) {
    _WallViewMode.wall => context.l10n.wallView,
    _WallViewMode.timeline => context.l10n.timelineView,
    _WallViewMode.map => context.l10n.mapView,
  };
}

class _SheetSectionLabel extends StatelessWidget {
  const _SheetSectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.muted,
          fontSize: 13,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _SheetChoice extends StatelessWidget {
  const _SheetChoice({
    required this.selected,
    required this.label,
    required this.onSelected,
    this.icon,
  });

  final bool selected;
  final String label;
  final VoidCallback onSelected;
  final IconData? icon;

  static const labelStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w900,
  );
  static const iconSize = 18.0;
  static const horizontalPadding = 12.0;

  /// The width this choice needs to show its label on one line.
  double neededWidth(BuildContext context) {
    final painter = TextPainter(
      text: TextSpan(text: label, style: labelStyle),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
      maxLines: 1,
    )..layout();
    final iconWidth = icon == null
        ? 0.0
        : MediaQuery.textScalerOf(context).scale(iconSize) + 6;
    return painter.width + iconWidth + 2 * horizontalPadding + 2;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final foreground = selected ? scheme.onPrimary : AppColors.muted;
    final shape = StadiumBorder(
      side: BorderSide(color: selected ? Colors.transparent : scheme.outline),
    );
    return Semantics(
      button: true,
      selected: selected,
      inMutuallyExclusiveGroup: true,
      excludeSemantics: true,
      label: label,
      child: Material(
        color: selected
            ? scheme.primary
            : AppColors.panelWarm.withValues(alpha: 0.6),
        shape: shape,
        child: InkWell(
          customBorder: shape,
          onTap: onSelected,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: iconSize, color: foreground),
                  const SizedBox(width: 6),
                ],
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: labelStyle.copyWith(color: foreground),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Equal-width choices across the sheet, [columns] per row; two per row (or
/// one) when a label would not fit, e.g. in German, Arabic or large text.
class _ChoiceGrid extends StatelessWidget {
  const _ChoiceGrid({required this.columns, required this.children});

  final int columns;
  final List<_SheetChoice> children;

  static const _gap = 8.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final needed = children
            .map((choice) => choice.neededWidth(context))
            .fold(0.0, math.max);
        var perRow = columns;
        while (perRow > 1 &&
            (constraints.maxWidth - (perRow - 1) * _gap) / perRow < needed) {
          perRow = perRow > 2 ? 2 : 1;
        }
        return Column(
          children: [
            for (var start = 0; start < children.length; start += perRow)
              Padding(
                padding: EdgeInsets.only(top: start == 0 ? 0 : _gap),
                child: Row(
                  children: [
                    for (var i = start; i < start + perRow; i++) ...[
                      if (i > start) const SizedBox(width: _gap),
                      Expanded(
                        child: i < children.length
                            ? children[i]
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

class _MemoryRitualCard extends StatelessWidget {
  const _MemoryRitualCard({
    required this.event,
    required this.onSave,
    required this.onOpen,
    this.yearsAgo,
    this.weekYearsAgo,
  });

  final MemoryEvent? event;

  /// Set when [event] happened on this day [yearsAgo] years ago.
  final int? yearsAgo;

  /// Set when [event] happened this week [weekYearsAgo] years ago.
  final int? weekYearsAgo;
  final VoidCallback onSave;
  final ValueChanged<MemoryEvent> onOpen;

  @override
  Widget build(BuildContext context) {
    final memory = event;
    final years = yearsAgo;
    // Room for one short line each at large text sizes.
    return MediaQuery.withClampedTextScaling(
      maxScaleFactor: 1.5,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.wallInk.withValues(alpha: 0.78),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.gold.withValues(alpha: 0.14)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.28),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(13),
          // With a large text size there is little room: the text keeps it
          // and the icon goes.
          child: LayoutBuilder(
            builder: (context, constraints) => Row(
              children: [
                if (constraints.maxWidth >= 96) ...[
                  Icon(
                    memory == null
                        ? Icons.edit_note_rounded
                        : years != null
                        ? Icons.event_repeat_rounded
                        : Icons.history_edu_rounded,
                    color: AppColors.gold,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: InkWell(
                    onTap: memory == null ? onSave : () => onOpen(memory),
                    borderRadius: BorderRadius.circular(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          memory == null
                              ? context.l10n.saveToday
                              : years != null
                              ? context.l10n.onThisDayYearsAgoToday(years)
                              : weekYearsAgo != null
                              ? context.l10n.thisWeekYearsAgo(weekYearsAgo!)
                              : context.l10n.rememberThis,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.gold,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          memory == null
                              ? context.l10n.whatHappenedToday
                              : memory.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WallDisplayProgressDialog extends StatelessWidget {
  const _WallDisplayProgressDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Row(
        children: [
          const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              context.l10n.preparingWallDisplay,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
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
        alignment: AlignmentDirectional.centerStart,
        child: DecoratedBox(
          // It floats over the cards (on small phones right on them), so
          // it is solid enough that card text never shows through.
          decoration: BoxDecoration(
            color: AppColors.wallInk.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              context.l10n.tapToOpenDrag,
              style: TextStyle(
                color: AppColors.text,
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
          Icon(Icons.preview_rounded, color: AppColors.gold, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              context.l10n.demoWallPreview,
              style: TextStyle(
                color: AppColors.muted,
                fontWeight: FontWeight.w800,
                height: 1.25,
              ),
            ),
          ),
          TextButton(onPressed: onClear, child: Text(context.l10n.clearDemo)),
        ],
      ),
    );
  }
}

class _BackupReminderBanner extends StatelessWidget {
  const _BackupReminderBanner({
    required this.unsavedCount,
    required this.onBackUp,
    required this.onLater,
  });

  final int unsavedCount;
  final VoidCallback onBackUp;
  final VoidCallback onLater;

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
          Icon(Icons.save_alt_rounded, color: AppColors.gold, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              context.l10n.backupReminder(unsavedCount),
              style: TextStyle(
                color: AppColors.muted,
                fontWeight: FontWeight.w800,
                height: 1.25,
              ),
            ),
          ),
          TextButton(onPressed: onLater, child: Text(context.l10n.later)),
          TextButton(onPressed: onBackUp, child: Text(context.l10n.backUp)),
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
                        style: TextStyle(color: AppColors.muted, height: 1.3),
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
                  return controls.compact(context);
                }
                return controls.wide(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _move(Offset delta) {
    setState(() => _position += delta);
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
        // Map free wall coords into the preview by centering around the card.
        final localX = position.dx - (canvasSize.width * 0.5);
        final localY = position.dy - (canvasSize.height * 0.5);
        final x = ((0.5 + localX / canvasSize.width) * width).clamp(
          12.0,
          width - 52,
        );
        final y = ((0.5 + localY / canvasSize.height) * height).clamp(
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

  Widget compact(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: _moveRow(context),
        ),
        const SizedBox(height: 10),
        Align(alignment: Alignment.centerRight, child: _actionRow(context)),
      ],
    );
  }

  Widget wide(BuildContext context) {
    return Row(
      children: [_moveRow(context), const Spacer(), _actionRow(context)],
    );
  }

  Widget _moveRow(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _MoveButton(
          icon: Icons.keyboard_arrow_left_rounded,
          label: context.l10n.moveLeft,
          onTap: () => onMove(const Offset(-80, 0)),
        ),
        _MoveButton(
          icon: Icons.keyboard_arrow_up_rounded,
          label: context.l10n.moveUp,
          onTap: () => onMove(const Offset(0, -80)),
        ),
        _MoveButton(
          icon: Icons.keyboard_arrow_down_rounded,
          label: context.l10n.moveDown,
          onTap: () => onMove(const Offset(0, 80)),
        ),
        _MoveButton(
          icon: Icons.keyboard_arrow_right_rounded,
          label: context.l10n.moveRight,
          onTap: () => onMove(const Offset(80, 0)),
        ),
      ],
    );
  }

  Widget _actionRow(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(onPressed: onCancel, child: Text(context.l10n.cancel)),
        const SizedBox(width: 8),
        FilledButton.icon(
          onPressed: onPlace,
          icon: const Icon(Icons.check_rounded),
          label: Text(context.l10n.placeHere),
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
  const _MoveButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: IconButton.filledTonal(
        onPressed: onTap,
        tooltip: label,
        icon: Icon(icon),
      ),
    );
  }
}

enum _QuickPhotoSource { camera, gallery }

class _QuickPhotoSourceSheet extends StatelessWidget {
  const _QuickPhotoSourceSheet();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.chooseQuickPhoto,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () =>
                  Navigator.of(context).pop(_QuickPhotoSource.camera),
              icon: const Icon(Icons.photo_camera_rounded),
              label: Text(l10n.takePhoto),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () =>
                  Navigator.of(context).pop(_QuickPhotoSource.gallery),
              icon: const Icon(Icons.photo_library_rounded),
              label: Text(l10n.choosePhoto),
            ),
          ],
        ),
      ),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
            child: Row(
              children: [
                Icon(Icons.add_photo_alternate_rounded, color: AppColors.gold),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    context.l10n.chooseQuickPhoto,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: assets.isEmpty
                ? Center(child: Text(context.l10n.noPhotosFound))
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
          child: Text(context.l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_controller.text),
          child: Text(widget.actionLabel),
        ),
      ],
    );
  }
}

enum _CameraSessionAction { takeAnother, addToMemory, cancel }

class _CameraCaptureFab extends StatelessWidget {
  const _CameraCaptureFab({required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.28),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.34),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      // The secondary action beside the gold "+": dark with a gold icon.
      child: FloatingActionButton(
        heroTag: 'wall-camera-capture',
        tooltip: context.l10n.takePhotosFabTooltip,
        onPressed: onPressed,
        backgroundColor: AppColors.panelWarm,
        foregroundColor: AppColors.gold,
        shape: CircleBorder(
          side: BorderSide(color: AppColors.gold.withValues(alpha: 0.4)),
        ),
        child: const Icon(Icons.photo_camera_rounded),
      ),
    );
  }
}

enum _WallViewMode {
  wall(Icons.dashboard_customize_rounded),
  timeline(Icons.timeline_rounded),
  map(Icons.map_rounded);

  const _WallViewMode(this.icon);

  final IconData icon;
}

enum _DragTargetKind { memory, wallItem }

enum _MemoryAction { open, edit, connect, story, moveToWall, hide, delete }

enum _TextAction { edit, delete }

enum _NailAction { connect, delete }

String _formatTimelineDate(BuildContext context, DateTime date) {
  final locale = Localizations.localeOf(context).toLanguageTag();
  return DateFormat.yMMMd(locale).format(date);
}

String _eventLocationSubtitle(BuildContext context, MemoryEvent event) {
  if (event.hasGeoPoint) return event.locationDisplayLabel;
  return _formatTimelineDate(context, event.occurredAt);
}

String _eventTimelineSubtitle(BuildContext context, MemoryEvent event) {
  final l10n = context.l10n;
  return [
    event.memoryType.localizedLabel(l10n),
    event.feeling.localizedLabel(l10n),
    if (event.hasGeoPoint) event.locationDisplayLabel,
  ].join(' • ');
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

/// Memories from other walls to tick and move to this one.
class _MoveHereSheet extends StatefulWidget {
  const _MoveHereSheet({required this.memories, required this.walls});

  final List<MemoryEvent> memories;
  final List<PersonalWall> walls;

  @override
  State<_MoveHereSheet> createState() => _MoveHereSheetState();
}

class _MoveHereSheetState extends State<_MoveHereSheet> {
  final _chosen = <String>{};

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    String wallName(String? id) =>
        widget.walls.where((w) => w.id == id).firstOrNull?.name ?? l10n.myWall;
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Text(
                l10n.moveMemoriesTitle,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final memory in widget.memories)
                    CheckboxListTile(
                      value: _chosen.contains(memory.id),
                      onChanged: (on) => setState(
                        () => on == true
                            ? _chosen.add(memory.id)
                            : _chosen.remove(memory.id),
                      ),
                      title: Text(
                        memory.title,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      subtitle: Text(wallName(memory.wallId)),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
              child: FilledButton.icon(
                key: const ValueKey('move-here-confirm'),
                onPressed: _chosen.isEmpty
                    ? null
                    : () => Navigator.of(context).pop(_chosen),
                icon: const Icon(Icons.drive_file_move_rounded),
                label: Text(l10n.moveSelected(_chosen.length)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
