import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/presentation/UI/widgets/section_dialog.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Menu Sections',
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF211E1C),
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'Manage your restaurant menu sections',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF8A8580),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 44.h,
          child: ElevatedButton.icon(
            onPressed: () {
              SectionDialog.showAddDialog(context);
            },
            icon: Icon(
              Icons.add,
              size: 20.sp,
            ),
            label: Text(
              'Add Section',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF5A1F),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
        ),
      ],
    );
  }


}