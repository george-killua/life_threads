import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations_x.dart';

const lifeThreadsMapTilerKey = String.fromEnvironment('MAPTILER_KEY');
const lifeThreadsMapTilerMapId = String.fromEnvironment(
  'MAPTILER_MAP_ID',
  defaultValue: 'streets-v4',
);
const lifeThreadsHasMapTilerKey = lifeThreadsMapTilerKey != '';

/// OpenFreeMap vector style: free, no API key, commercial use allowed.
/// Other styles: positron, bright (https://openfreemap.org).
const lifeThreadsOpenFreeMapStyleUrl = String.fromEnvironment(
  'LIFETHREADS_MAP_STYLE_URL',
  defaultValue: 'https://tiles.openfreemap.org/styles/liberty',
);
const lifeThreadsUserAgentPackageName = 'dev.gkcoding.lifethreads';

enum LifeThreadsMapProviderKind { openFreeMap, mapTiler }

class LifeThreadsMapProvider {
  const LifeThreadsMapProvider._({
    required this.kind,
    required this.tileUrl,
    required this.maxNativeZoom,
  });

  final LifeThreadsMapProviderKind kind;

  /// Raster tile URL; null for vector providers.
  final String? tileUrl;
  final int maxNativeZoom;

  /// OpenFreeMap by default. A MapTiler key passed with --dart-define
  /// switches back to MapTiler raster tiles.
  static const current = lifeThreadsHasMapTilerKey
      ? LifeThreadsMapProvider._(
          kind: LifeThreadsMapProviderKind.mapTiler,
          tileUrl:
              'https://api.maptiler.com/maps/$lifeThreadsMapTilerMapId/256/{z}/{x}/{y}.png?key=$lifeThreadsMapTilerKey',
          maxNativeZoom: 20,
        )
      : LifeThreadsMapProvider._(
          kind: LifeThreadsMapProviderKind.openFreeMap,
          tileUrl: null,
          maxNativeZoom: 14,
        );

  bool get hasTiles => true;
  bool get isMapTiler => kind == LifeThreadsMapProviderKind.mapTiler;
  bool get isOpenFreeMap => kind == LifeThreadsMapProviderKind.openFreeMap;
}

class LifeThreadsMapTileLayer extends StatelessWidget {
  const LifeThreadsMapTileLayer({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = LifeThreadsMapProvider.current;
    final url = provider.tileUrl;
    if (url != null) {
      return TileLayer(
        urlTemplate: url,
        userAgentPackageName: lifeThreadsUserAgentPackageName,
        maxNativeZoom: provider.maxNativeZoom,
      );
    }
    return const _OpenFreeMapLayer();
  }
}

class _OpenFreeMapLayer extends StatefulWidget {
  const _OpenFreeMapLayer();

  @override
  State<_OpenFreeMapLayer> createState() => _OpenFreeMapLayerState();
}

class _OpenFreeMapLayerState extends State<_OpenFreeMapLayer> {
  // The style JSON is shared by every map in the app and fetched once; a
  // failed fetch is retried the next time a map is shown.
  static Future<Style>? _style;

  late final Future<Style> _future = _style ??= StyleReader(
    uri: lifeThreadsOpenFreeMapStyleUrl,
  ).read().catchError((Object error) {
    _style = null;
    throw error;
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Style>(
      future: _future,
      builder: (context, snapshot) {
        final style = snapshot.data;
        if (style == null) return const SizedBox.shrink();
        return VectorTileLayer(
          tileProviders: style.providers,
          theme: style.theme,
          sprites: style.sprites,
          maximumZoom: 20,
        );
      },
    );
  }
}

class LifeThreadsMapAttribution extends StatelessWidget {
  const LifeThreadsMapAttribution({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = LifeThreadsMapProvider.current;
    if (!provider.hasTiles) return const SizedBox.shrink();

    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.wallInk.withValues(alpha: 0.84),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.16)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (provider.isMapTiler)
                  _AttributionLink(
                    label: 'MapTiler',
                    onTap: () =>
                        _openUrl('https://www.maptiler.com/copyright/'),
                  ),
                if (provider.isOpenFreeMap) ...[
                  _AttributionLink(
                    label: 'OpenFreeMap',
                    onTap: () => _openUrl('https://openfreemap.org'),
                  ),
                  _AttributionLink(
                    label: 'OpenMapTiles',
                    onTap: () => _openUrl('https://www.openmaptiles.org/'),
                  ),
                ],
                _AttributionLink(
                  label: 'OpenStreetMap',
                  onTap: () =>
                      _openUrl('https://www.openstreetmap.org/copyright'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LifeThreadsMapUnavailablePanel extends StatelessWidget {
  const LifeThreadsMapUnavailablePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
        color: AppColors.panel,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.line),
      ),
      padding: const EdgeInsets.all(22),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.map_outlined, color: AppColors.gold, size: 38),
          const SizedBox(height: 12),
          Text(
            context.l10n.mapUnavailable,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}

class _AttributionLink extends StatelessWidget {
  const _AttributionLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Text(
          '© $label',
          style: const TextStyle(
            color: AppColors.text,
            fontSize: 10.5,
            fontWeight: FontWeight.w800,
            decoration: TextDecoration.underline,
            decorationColor: AppColors.gold,
          ),
        ),
      ),
    );
  }
}

Future<void> _openUrl(String url) async {
  await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
}
