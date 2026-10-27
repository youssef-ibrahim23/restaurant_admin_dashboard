import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_admin_dashboard/features/customers/presentation/BLoC/customers_event.dart';
import 'package:restaurant_admin_dashboard/features/customers/presentation/BLoC/customers_state.dart';
import 'package:restaurant_admin_dashboard/features/customers/presentation/UI/widgets/search_field.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/shared/widgets/loading.dart';
import '../UI/widgets/header.dart';
import '../BLoC/customers_bloc.dart';
import 'widgets/table.dart';

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
                Padding(
                  padding: EdgeInsets.all(32.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Header(),
                      SizedBox(height: 28.h),
                      SearchField(
                        onChanged: (query) {
                          // TODO: Ensure search input events are debounced before adding to BLoC.
                          context.read<CustomersBloc>().add(
                            SearchCustomers(query),
                          );
                        },
                      ),
                      SizedBox(height: 28.h),
                      Expanded(
                        child: CustomersTable(customers: state.customers),
                      ),
                    ],
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
