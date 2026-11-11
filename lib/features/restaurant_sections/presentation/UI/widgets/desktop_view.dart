import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/data/model/section_model.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/presentation/UI/widgets/header.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/presentation/UI/widgets/table.dart';

class SectionsDesktopView extends StatelessWidget {
  final Function(SectionModel) onManageMenu;

  const SectionsDesktopView({
    super.key,
    required this.onManageMenu,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(32.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Header(),
          SizedBox(height: 28.h),
          Expanded(child: RestaurantsTable(onManageMenu: onManageMenu)),
        ],
      ),
    );
  }
}
