import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DriversHeader extends StatelessWidget {
  final int onlineCount;
  final int offlineCount;
  final VoidCallback onAddDriver;

  const DriversHeader({
    super.key,
    required this.onlineCount,
    required this.offlineCount,
    required this.onAddDriver,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Drivers',
          style: TextStyle(
            fontSize: 32.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          '$onlineCount online · $offlineCount offline',
          style: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }
}
