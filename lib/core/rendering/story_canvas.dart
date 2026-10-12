import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_theme.dart';
import '../../l10n/generated/app_localizations.dart';

/// Renders widgets offscreen (never shown on screen) to images, e.g. story
/// images and video frames.
///
/// The widget gets the app theme, localizations, [Directionality] and a
/// [MediaQuery] of [logicalSize]; images it shows ([Image] and
/// [DecorationImage]) are decoded before the picture is taken. Animations
/// are frozen ([TickerMode] off): render each video frame with its own
/// progress value instead.
///
/// One canvas can render many frames; [dispose] it when done.
///
/// ```dart
/// final canvas = StoryCanvas.fromContext(context);
/// try {
///   final png = await canvas.renderPng(StoryCard(memory: memory));
/// } finally {
///   canvas.dispose();
/// }
/// ```
class StoryCanvas {
  StoryCanvas({
    this.logicalSize = storyLogicalSize,
    this.pixelRatio = storyPixelRatio,
    ThemeData? theme,
    this.locale = const Locale('en'),
    this.textDirection,
    this.assetBundle,
    this.providerContainer,
    this.imageTimeout = const Duration(seconds: 10),
  }) : theme = theme ?? AppTheme.dark {
    final view =
        WidgetsBinding.instance.platformDispatcher.implicitView ??
        WidgetsBinding.instance.platformDispatcher.views.first;
    _renderView = RenderView(
      view: view,
      configuration: ViewConfiguration(
        logicalConstraints: BoxConstraints.tight(logicalSize),
        physicalConstraints: BoxConstraints.tight(logicalSize * pixelRatio),
        devicePixelRatio: pixelRatio,
      ),
      // Tight constraints: the widget fills the whole canvas.
      child: _boundary,
    );
    _pipelineOwner.rootNode = _renderView;
    _renderView.prepareInitialFrame();
  }

  /// Takes theme, locale, text direction, asset bundle and the Riverpod
  /// container from [context], so the offscreen widget sees what the app
  /// sees.
  factory StoryCanvas.fromContext(
    BuildContext context, {
    Size logicalSize = storyLogicalSize,
    double pixelRatio = storyPixelRatio,
  }) {
    ProviderContainer? container;
    try {
      container = ProviderScope.containerOf(context, listen: false);
    } catch (_) {
      container = null;
    }
    return StoryCanvas(
      logicalSize: logicalSize,
      pixelRatio: pixelRatio,
      theme: Theme.of(context),
      locale: Localizations.localeOf(context),
      textDirection: Directionality.of(context),
      assetBundle: DefaultAssetBundle.of(context),
      providerContainer: container,
    );
  }

  /// 360×640 logical pixels at 3× is a 1080×1920 (9:16) story.
  static const storyLogicalSize = Size(360, 640);
  static const storyPixelRatio = 3.0;

  final Size logicalSize;
  final double pixelRatio;
  final ThemeData theme;
  final Locale locale;

  /// Defaults to the direction of [locale] (right-to-left for Arabic).
  final TextDirection? textDirection;
  final AssetBundle? assetBundle;
  final ProviderContainer? providerContainer;

  /// How long to wait for one image; a slow or broken image is drawn as
  /// whatever its widget shows without it (e.g. its error builder).
  final Duration imageTimeout;

  final _boundary = RenderRepaintBoundary();
  final _pipelineOwner = PipelineOwner();
  final _focusManager = FocusManager();
  late final _buildOwner = BuildOwner(focusManager: _focusManager);
  late final RenderView _renderView;
  RenderObjectToWidgetElement<RenderBox>? _root;
  var _disposed = false;

  /// The size of rendered images in physical pixels.
  Size get pixelSize => logicalSize * pixelRatio;

  /// Renders [child]; the caller disposes the returned image.
  Future<ui.Image> renderImage(Widget child) async {
    assert(!_disposed, 'StoryCanvas used after dispose');
    _attach(_wrap(child));
    final seen = <ImageProvider>{};
    // Build until no new images show up; each round waits for the images
    // found in the last one (decoded images rebuild their widgets).
    for (var round = 0; round < 8; round++) {
      _buildOwner.buildScope(_root!);
      _buildOwner.finalizeTree();
      _pipelineOwner.flushLayout();
      final pending = _pendingImages(seen);
      if (pending.isEmpty && round > 0) break;
      await Future.wait(pending);
      // Lets synchronous-looking work (localizations, image listeners)
      // settle before the next build.
      await Future<void>.delayed(Duration.zero);
    }
    _buildOwner.buildScope(_root!);
    _buildOwner.finalizeTree();
    _pipelineOwner
      ..flushLayout()
      ..flushCompositingBits()
      ..flushPaint();
    return _boundary.toImage(pixelRatio: pixelRatio);
  }

  /// Renders [child] as PNG bytes of [pixelSize].
  Future<Uint8List> renderPng(Widget child) async {
    final image = await renderImage(child);
    try {
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      return bytes!.buffer.asUint8List();
    } finally {
      image.dispose();
    }
  }

  /// Renders [child] as raw RGBA bytes (row by row, 4 bytes per pixel), the
  /// cheaper format for video frames.
  Future<Uint8List> renderRgba(Widget child) async {
    final image = await renderImage(child);
    try {
      final bytes = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
      return bytes!.buffer.asUint8List();
    } finally {
      image.dispose();
    }
  }

  /// Unmounts the offscreen tree (disposing its states).
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    final root = _root;
    if (root != null) {
      RenderObjectToWidgetAdapter<RenderBox>(
        container: _boundary,
      ).attachToRenderTree(_buildOwner, root);
      _buildOwner
        ..buildScope(root)
        ..finalizeTree();
    }
    _focusManager.dispose();
  }

  void _attach(Widget widget) {
    _root = RenderObjectToWidgetAdapter<RenderBox>(
      container: _boundary,
      debugShortDescription: '[StoryCanvas]',
      child: widget,
    ).attachToRenderTree(_buildOwner, _root);
  }

  Widget _wrap(Widget child) {
    Widget tree = Material(type: MaterialType.transparency, child: child);
    final direction = textDirection;
    if (direction != null) {
      tree = Directionality(textDirection: direction, child: tree);
    }
    tree = MediaQuery(
      data: MediaQueryData(
        size: logicalSize,
        devicePixelRatio: pixelRatio,
        textScaler: TextScaler.noScaling,
      ),
      child: Localizations(
        locale: locale,
        delegates: AppLocalizations.localizationsDelegates,
        child: Theme(
          data: theme,
          child: TickerMode(enabled: false, child: tree),
        ),
      ),
    );
    final bundle = assetBundle;
    if (bundle != null) {
      tree = DefaultAssetBundle(bundle: bundle, child: tree);
    }
    final container = providerContainer;
    if (container != null) {
      tree = UncontrolledProviderScope(container: container, child: tree);
    }
    return tree;
  }

  /// Starts (or joins) loading every image in the tree not seen before.
  List<Future<void>> _pendingImages(Set<ImageProvider> seen) {
    final pending = <Future<void>>[];
    void visit(Element element) {
      final widget = element.widget;
      final provider = switch (widget) {
        Image(:final image) => image,
        DecoratedBox(decoration: BoxDecoration(:final image?)) => image.image,
        _ => null,
      };
      if (provider != null && seen.add(provider)) {
        pending.add(_load(provider, createLocalImageConfiguration(element)));
      }
      element.visitChildren(visit);
    }

    _root?.visitChildren(visit);
    return pending;
  }

  Future<void> _load(ImageProvider provider, ImageConfiguration configuration) {
    final completer = Completer<void>();
    final stream = provider.resolve(configuration);
    late final ImageStreamListener listener;
    void done() {
      if (completer.isCompleted) return;
      completer.complete();
      // Removed after the current notification: the widget's own listener
      // keeps the image alive.
      scheduleMicrotask(() => stream.removeListener(listener));
    }

    listener = ImageStreamListener((_, _) => done(), onError: (_, _) => done());
    stream.addListener(listener);
    return completer.future.timeout(imageTimeout, onTimeout: done);
  }
}
