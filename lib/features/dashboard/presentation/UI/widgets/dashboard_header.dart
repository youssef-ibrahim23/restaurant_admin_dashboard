import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good morning, Admin',
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF211E1C),
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                "Here's what's happening today",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF8A8580),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
