import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_admin_dashboard/features/promos/presentation/UI/widgets/header.dart';
import 'package:restaurant_admin_dashboard/features/promos/presentation/UI/widgets/table.dart';

class PromosDesktopView extends StatelessWidget {
  const PromosDesktopView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(32.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Header(),
          SizedBox(height: 28.h),
          const Expanded(child: PromosTable()),
        ],
      ),
    );
  }
}
