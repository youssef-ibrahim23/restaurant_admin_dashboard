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

  @override
  Widget build(BuildContext context) {
    // TODO: Move the screens list outside build() or keep it static/const so screens are not rebuilt from scratch on every tab switch.
    final List<Widget> screens = [
      const Center(child: Text('Dashboard')),
      const Center(child: Text('Orders')),
      const RestaurantsPresenter(),
      const Center(child: Text('Drivers')),
      const Center(child: Text('Customers')),
      const Center(child: Text('Promos')),
      const Center(child: Text('Settings')),
    ];

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
                  child: IndexedStack(index: selectedIndex, children: screens),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
