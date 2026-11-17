
import 'package:flutter/material.dart';
import 'package:restaurant_admin_dashboard/features/drivers/data/model/driver_model.dart';

import 'map_grid_painter.dart';
import 'driver_map_marker.dart';

class DriversMap extends StatelessWidget {
  final List<DriverModel> drivers;

  const DriversMap({
    super.key,
    required this.drivers,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          // Calculate bounding box for normalization
          final driverLocations = drivers
              .where((d) => d.latitude != null && d.longitude != null)
              .map((d) => (d.latitude!, d.longitude!))
              .toList();

          final bounds = _calculateBounds(driverLocations);

          return Stack(
            children: [
              // Background
              Positioned.fill(
                child: CustomPaint(
                  painter: const MapGridPainter(
                    gridSize: 30,
                  ),
                  child: Container(
                    color: const Color(0xFFF3F0EB),
                  ),
                ),
              ),

              // Drivers with real coordinates
              ...drivers.where((d) => d.latitude != null && d.longitude != null).map((driver) {
                final (x, y) = _normalizeCoordinate(
                  driver.latitude!,
                  driver.longitude!,
                  bounds,
                );
                return _marker(x, y, '🛵', width, height);
              }),

              // Restaurant (example - you can add restaurant lat/long from DB)
              _marker(0.65, 0.48, '🍔', width, height),

              // Destination (example - you can add destination lat/long from DB)
              _marker(0.90, 0.34, '📍', width, height),
            ],
          );
        },
      ),
    );
  }

  Widget _marker(
      double x,
      double y,
      String emoji,
      double width,
      double height,
      ) {
    return Positioned(
      left: width * x,
      top: height * y,
      child: DriverMapMarker(
        emoji: emoji,
      ),
    );
  }

  // Calculate min/max lat/long to normalize coordinates to 0-1 range
  ({double minLat, double maxLat, double minLong, double maxLong}) _calculateBounds(
    List<(double, double)> locations,
  ) {
    if (locations.isEmpty) {
      return (minLat: 0, maxLat: 1, minLong: 0, maxLong: 1);
    }

    double minLat = locations.first.$1;
    double maxLat = locations.first.$1;
    double minLong = locations.first.$2;
    double maxLong = locations.first.$2;

    for (final (lat, long) in locations) {
      if (lat < minLat) minLat = lat;
      if (lat > maxLat) maxLat = lat;
      if (long < minLong) minLong = long;
      if (long > maxLong) maxLong = long;
    }

    // Add padding to bounds
    final latPadding = (maxLat - minLat) * 0.1;
    final longPadding = (maxLong - minLong) * 0.1;

    return (
      minLat: minLat - latPadding,
      maxLat: maxLat + latPadding,
      minLong: minLong - longPadding,
      maxLong: maxLong + longPadding,
    );
  }

  // Normalize lat/long to 0-1 range for display
  (double x, double y) _normalizeCoordinate(
    double lat,
    double long,
    ({double minLat, double maxLat, double minLong, double maxLong}) bounds,
  ) {
    final x = (long - bounds.minLong) / (bounds.maxLong - bounds.minLong);
    final y = (bounds.maxLat - lat) / (bounds.maxLat - bounds.minLat); // Invert Y for screen coordinates

    return (x.clamp(0.0, 1.0), y.clamp(0.0, 1.0));
  }
}
