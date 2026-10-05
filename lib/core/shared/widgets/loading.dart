import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Loading extends StatelessWidget{
  const Loading({super.key});


  @override
  Widget build(BuildContext context) {

    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          color: Colors.white.withOpacity(0.3),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    const Color(0xFFFF5A1F),
                  ),
                  strokeWidth: 3,
                ),
                SizedBox(height: 16.h),
                Text(
                  'Loading...',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF211E1C),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}