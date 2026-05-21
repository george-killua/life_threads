import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/theme/app_colors.dart';

const lifeThreadsMapTilerKey = String.fromEnvironment('MAPTILER_KEY');
const lifeThreadsMapTilerMapId = String.fromEnvironment(
  'MAPTILER_MAP_ID',
  defaultValue: 'streets-v4',
);
const lifeThreadsHasMapTilerKey = lifeThreadsMapTilerKey != '';
const lifeThreadsOsmTileUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
const lifeThreadsUserAgentPackageName = 'dev.gkcoding.lifethreads';

enum LifeThreadsMapProviderKind { mapTiler, osmDebug, unavailable }

class LifeThreadsMapProvider {
  const LifeThreadsMapProvider._({
    required this.kind,
    required this.tileUrl,
    required this.maxNativeZoom,
  });

  final LifeThreadsMapProviderKind kind;
  final String? tileUrl;
  final int maxNativeZoom;

  static const current = lifeThreadsHasMapTilerKey
      ? LifeThreadsMapProvider._(
          kind: LifeThreadsMapProviderKind.mapTiler,
          tileUrl:
              'https://api.maptiler.com/maps/$lifeThreadsMapTilerMapId/256/{z}/{x}/{y}.png?key=$lifeThreadsMapTilerKey',
          maxNativeZoom: 20,
        )
      : kDebugMode
      ? LifeThreadsMapProvider._(
          kind: LifeThreadsMapProviderKind.osmDebug,
          tileUrl: lifeThreadsOsmTileUrl,
          maxNativeZoom: 19,
        )
      : LifeThreadsMapProvider._(
          kind: LifeThreadsMapProviderKind.unavailable,
          tileUrl: null,
          maxNativeZoom: 0,
        );

  bool get hasTiles => tileUrl != null;
  bool get isMapTiler => kind == LifeThreadsMapProviderKind.mapTiler;
}

class LifeThreadsMapTileLayer extends StatelessWidget {
  const LifeThreadsMapTileLayer({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = LifeThreadsMapProvider.current;
    final url = provider.tileUrl;
    if (url == null) return const SizedBox.shrink();

    return TileLayer(
      urlTemplate: url,
      userAgentPackageName: lifeThreadsUserAgentPackageName,
      maxNativeZoom: provider.maxNativeZoom,
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
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.map_outlined, color: AppColors.gold, size: 38),
          SizedBox(height: 12),
          Text(
            'Map tiles are not configured.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 6),
          Text(
            'Build with --dart-define MAPTILER_KEY to enable production maps.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.muted, height: 1.35),
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
