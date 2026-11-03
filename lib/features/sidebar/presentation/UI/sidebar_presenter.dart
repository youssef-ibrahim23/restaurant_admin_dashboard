import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_admin_dashboard/core/di/service_locator.dart';
import 'package:restaurant_admin_dashboard/features/customers/presentation/UI/customers_presenter.dart';
import 'package:restaurant_admin_dashboard/features/orders/presentation/UI/orders_presenter.dart';
import 'package:restaurant_admin_dashboard/features/promos/presentation/UI/promos_presentation.dart';
import 'package:restaurant_admin_dashboard/features/settings/presentation/UI/settings_presenter.dart';
import 'package:restaurant_admin_dashboard/features/promos/presentation/UI/promos_presentation.dart';

import '../../../dashboard/presentation/UI/dashboard_presenter.dart';
import '../../../restaurant_sections/presentation/UI/sections_presenter.dart';
import '../BLoC/sidebar_bloc.dart';
import '../BLoC/sidebar_event.dart';
import '../BLoC/sidebar_state.dart';
import 'widgets/sidebar.dart';

class SidebarPresenter extends StatelessWidget {
  const SidebarPresenter({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const DashboardPresenter(),
      const OrdersPresenter(),
      const RestaurantsPresenter(),
      const Center(child: Text('Drivers')),
      const CustomersPresenter(),
      const PromosPresenter(),
      const SettingsPresenter(),
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
