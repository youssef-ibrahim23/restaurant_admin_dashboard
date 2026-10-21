import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_admin_dashboard/features/sidebar/presentation/UI/widgets/sidebar_item.dart';

class Sidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const Sidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230.w,
      color: Color(0xFF211E1C),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 24.h,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/logo.png', width: 30.sp,),
                  SizedBox(width: 5.w),
                  Text(
                    'FoodAdmin',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10.h),

            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                children: [
                  SidebarItem(
                    icon: Icons.dashboard_outlined,
                    label: 'Dashboard',
                    selected: selectedIndex == 0,
                    onTap: () => onItemSelected(0),
                  ),
                  SidebarItem(
                    icon: Icons.receipt_long_outlined,
                    label: 'Orders',
                    selected: selectedIndex == 1,
                    onTap: () => onItemSelected(1),
                  ),
                  SidebarItem(
                    icon: Icons.restaurant_menu_outlined,
                    label: 'Restaurants',
                    selected: selectedIndex == 2,
                    onTap: () => onItemSelected(2),
                  ),
                  SidebarItem(
                    icon: Icons.delivery_dining_outlined,
                    label: 'Drivers',
                    selected: selectedIndex == 3,
                    onTap: () => onItemSelected(3),
                  ),
                  SidebarItem(
                    icon: Icons.people_outline,
                    label: 'Customers',
                    selected: selectedIndex == 4,
                    onTap: () => onItemSelected(4),
                  ),
                  SidebarItem(
                    icon: Icons.local_offer_outlined,
                    label: 'Promos',
                    selected: selectedIndex == 5,
                    onTap: () => onItemSelected(5),
                  ),
                  SidebarItem(
                    icon: Icons.settings_outlined,
                    label: 'Settings',
                    selected: selectedIndex == 6,
                    onTap: () => onItemSelected(6),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
