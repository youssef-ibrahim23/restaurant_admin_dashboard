
import 'package:flutter/material.dart';

class DriverMapMarker extends StatelessWidget {
  final String emoji;
  final double size;

  const DriverMapMarker({
    super.key,
    required this.emoji,
    this.size = 28,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: Text(
          emoji,
          style: TextStyle(fontSize: size * 0.75),
        ),
      ),
    );
  }
}
