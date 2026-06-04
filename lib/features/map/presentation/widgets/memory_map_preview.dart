import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../memories/domain/memory_event.dart';
import 'lifethreads_map_provider.dart';

class MemoryMapPreview extends StatelessWidget {
  const MemoryMapPreview({super.key, required this.event});

  final MemoryEvent event;

  @override
  Widget build(BuildContext context) {
    if (!event.hasGeoPoint) return const SizedBox.shrink();

    final point = LatLng(event.latitude!, event.longitude!);

    if (!LifeThreadsMapProvider.current.hasTiles) {
      return const _MapShell(child: LifeThreadsMapUnavailablePanel());
    }

    return _MapShell(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: FlutterMap(
          options: MapOptions(
            initialCenter: point,
            initialZoom: 12,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.none,
            ),
          ),
          children: [
            const LifeThreadsMapTileLayer(),
            MarkerLayer(
              markers: [
                Marker(
                  point: point,
                  width: 48,
                  height: 48,
                  child: const Icon(
                    Icons.location_pin,
                    color: AppColors.gold,
                    size: 42,
                  ),
                ),
              ],
            ),
            const LifeThreadsMapAttribution(),
          ],
        ),
      ),
    );
  }
}

class _MapShell extends StatelessWidget {
  const _MapShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
      decoration: BoxDecoration(
        color: AppColors.panel,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.line),
      ),
      child: child,
    );
  }
}
