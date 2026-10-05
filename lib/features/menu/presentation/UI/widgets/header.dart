import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenuHeader extends StatelessWidget {
  final String sectionName;
  final VoidCallback onClick;

  const MenuHeader({
    super.key,
    required this.sectionName,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sectionName,
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF211E1C),
                ),
              ),
              SizedBox(height: 7.h),
              Row(
                children: [
                  Icon(
                    Icons.star_rounded,
                    color: const Color(0xFFF4C542),
                    size: 17.sp,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '4.7',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF77716B),
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    '•',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFFAAA49E),
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    '42 menu items',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF8A8580),
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    '•',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFFAAA49E),
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    'Open now',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF8A8580),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 42.h,
          child: ElevatedButton.icon(
            onPressed: onClick,
            icon: Icon(
              Icons.clear_outlined,
              size: 18.sp,
            ),
            label: Text(
              'Clear Form',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF5A1F),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: EdgeInsets.symmetric(
                horizontal: 17.w,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9.r),
              ),
            ),
          ),
        ),
      ],
    );
  }
}