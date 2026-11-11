import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_admin_dashboard/core/di/service_locator.dart';
import 'package:restaurant_admin_dashboard/core/shared/widgets/loading.dart';
import 'package:restaurant_admin_dashboard/core/utils/responsive.dart';
import 'package:restaurant_admin_dashboard/features/customers/presentation/BLoC/customers_bloc.dart';
import 'package:restaurant_admin_dashboard/features/customers/presentation/BLoC/customers_event.dart';
import 'package:restaurant_admin_dashboard/features/customers/presentation/BLoC/customers_state.dart';
import 'package:restaurant_admin_dashboard/features/customers/presentation/UI/widgets/desktop_view.dart';
import 'package:restaurant_admin_dashboard/features/customers/presentation/UI/widgets/mobile_view.dart';

class CustomersPresenter extends StatelessWidget {
  const CustomersPresenter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CustomersBloc>()..add(LoadCustomers()),
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F5F1),
        body: BlocBuilder<CustomersBloc, CustomersState>(
          builder: (context, state) {
            return Stack(
              children: [
                AdaptiveView(
                  desktop: CustomersDesktopView(
                    customers: state.customers,
                    onSearchChanged: (query) {
                      context.read<CustomersBloc>().add(
                        SearchCustomers(query),
                      );
                    },
                  ),
                  mobile: CustomersMobileView(
                    customers: state.customers,
                    onSearchChanged: (query) {
                      context.read<CustomersBloc>().add(
                        SearchCustomers(query),
                      );
                    },
                  ),
                ),
                if (state is CustomersLoading && state.customers.isEmpty)
                  const Loading(),
              ],
            );
          },
        ),
      ),
    );
  }
}
