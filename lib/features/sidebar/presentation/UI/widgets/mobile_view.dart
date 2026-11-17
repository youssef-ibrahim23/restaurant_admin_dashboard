import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SidebarMobileView extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final Widget child;

  const SidebarMobileView({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.child,
  });

  static const List<({IconData icon, String label})> _items = [
    (icon: Icons.dashboard_outlined, label: 'Dashboard'),
    (icon: Icons.receipt_long_outlined, label: 'Orders'),
    (icon: Icons.restaurant_menu_outlined, label: 'Restaurants'),
    (icon: Icons.delivery_dining_outlined, label: 'Drivers'),
    (icon: Icons.people_outline, label: 'Customers'),
    (icon: Icons.local_offer_outlined, label: 'Promos'),
    (icon: Icons.settings_outlined, label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: child),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: onItemSelected,
        backgroundColor: const Color(0xFF211E1C),
        indicatorColor: const Color(0xFFFD5B22),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: 20.sp,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
            color: states.contains(WidgetState.selected)
                ? Colors.white
                : const Color(0xFFB8B2AC),
          ),
        ),
        destinations: _items
            .map(
              (item) => NavigationDestination(
                icon: Icon(item.icon, size: 32.sp, color: const Color(0xFFB8B2AC)),
                selectedIcon: Icon(item.icon, size: 32.sp, color: Colors.white),
                label: item.label,
              ),
            )
            .toList(),
      ),
    );
  }
}
