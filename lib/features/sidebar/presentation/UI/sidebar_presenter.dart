import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_admin_dashboard/core/di/service_locator.dart';

import '../../../restaurant_sections/presentation/UI/sections_presenter.dart';
import '../BLoC/sidebar_bloc.dart';
import '../BLoC/sidebar_event.dart';
import '../BLoC/sidebar_state.dart';
import 'widgets/sidebar.dart';

class SidebarPresenter extends StatelessWidget {
  const SidebarPresenter({super.key});

  static const List<Widget> _screens = [
    Center(child: Text('Dashboard')),
    Center(child: Text('Orders')),
    RestaurantsPresenter(),
    Center(child: Text('Drivers')),
    Center(child: Text('Customers')),
    Center(child: Text('Promos')),
    Center(child: Text('Settings')),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SidebarBloc>(),
      child: BlocSelector<SidebarBloc, SidebarState, int>(
        selector: (state) => state.selectedIndex,
        builder: (context, selectedIndex) {
          return Scaffold(
            body: Row(
              children: [
                Sidebar(
                  selectedIndex: selectedIndex,
                  onItemSelected: (index) {
                    context.read<SidebarBloc>().add(SidebarItemSelected(index));
                  },
                ),
                Expanded(
                  child: IndexedStack(index: selectedIndex, children: _screens),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
