import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../memories/domain/memory_event.dart';

class MemoryMapPreview extends StatelessWidget {
  const MemoryMapPreview({super.key, required this.event});

  final MemoryEvent event;

  @override
  Widget build(BuildContext context) {
    if (event.latitude == null || event.longitude == null) {
      return _MapShell(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.location_off_rounded,
              color: AppColors.gold,
              size: 38,
            ),
            const SizedBox(height: 10),
            Text(
              event.locationLabel,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            const Text(
              'No GPS point attached yet.',
              style: TextStyle(color: AppColors.muted),
            ),
          ],
        ),
      );
    }

    final point = LatLng(event.latitude!, event.longitude!);

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
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'dev.gkcoding.lifethreads',
            ),
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
