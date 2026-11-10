
import 'package:flutter/material.dart';

import 'map_grid_painter.dart';
import 'driver_map_marker.dart';

class DriversMap extends StatelessWidget {
  const DriversMap({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

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

              // Drivers
              _marker(0.15, 0.15, '🛵', width, height),
              _marker(0.78, 0.12, '🛵', width, height),
              _marker(0.48, 0.30, '🛵', width, height),
              _marker(0.32, 0.55, '🛵', width, height),

              // Restaurant
              _marker(0.65, 0.48, '🍔', width, height),

              // Destination
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
}
