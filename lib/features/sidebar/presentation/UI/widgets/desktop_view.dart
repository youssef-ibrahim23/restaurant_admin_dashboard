import 'package:flutter/material.dart';
import 'package:restaurant_admin_dashboard/features/sidebar/presentation/UI/widgets/sidebar.dart';

class SidebarDesktopView extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final Widget child;

  const SidebarDesktopView({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Sidebar(
          selectedIndex: selectedIndex,
          onItemSelected: onItemSelected,
        ),
        Expanded(child: child),
      ],
    );
  }
}
