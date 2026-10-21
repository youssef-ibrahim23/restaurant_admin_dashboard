import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const SidebarItem({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Material(
        color: selected
            ? const Color(0xFFFD5B22)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(9.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(9.r),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 11.h,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 19.sp,
                  color: Colors.white,
                ),
                SizedBox(width: 11.w),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontWeight: selected
                        ? FontWeight.w700
                        : FontWeight.w500,
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