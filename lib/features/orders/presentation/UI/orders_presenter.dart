import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_admin_dashboard/core/shared/widgets/loading.dart';
import 'package:restaurant_admin_dashboard/core/utils/responsive.dart';
import 'package:restaurant_admin_dashboard/features/orders/data/model/order_model.dart';
import 'package:restaurant_admin_dashboard/features/orders/presentation/BLoC/orders_bloc.dart';
import 'package:restaurant_admin_dashboard/features/orders/presentation/BLoC/orders_event.dart';
import 'package:restaurant_admin_dashboard/features/orders/presentation/BLoC/orders_state.dart';
import 'package:restaurant_admin_dashboard/features/orders/presentation/UI/widgets/desktop_view.dart';
import 'package:restaurant_admin_dashboard/features/orders/presentation/UI/widgets/mobile_view.dart';

import '../../../../core/di/service_locator.dart';

class OrdersPresenter extends StatelessWidget {
  const OrdersPresenter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<OrdersBloc>()..add(LoadOrders()),
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F5F1),
        body: BlocBuilder<OrdersBloc, OrdersState>(
          builder: (context, state) {
            final displayedOrders = state.filteredOrders;
            OrderModel? selectedOrder;
            if (state.selectedOrderId != null) {
              final index = displayedOrders.indexWhere(
                (order) => order.id == state.selectedOrderId,
              );
              if (index >= 0) {
                selectedOrder = displayedOrders[index];
              } else if (displayedOrders.isNotEmpty) {
                selectedOrder = displayedOrders.first;
              }
            } else if (displayedOrders.isNotEmpty) {
              selectedOrder = displayedOrders.first;
            }

            return Stack(
              children: [
                AdaptiveView(
                  desktop: OrdersDesktopView(
                    displayedOrders: displayedOrders,
                    selectedOrderId:
                        selectedOrder?.id ?? state.selectedOrderId,
                    selectedOrder: selectedOrder,
                    state: state,
                  ),
                  mobile: OrdersMobileView(
                    displayedOrders: displayedOrders,
                    state: state,
                  ),
                ),
                if (state is OrdersLoading && state.orders.isEmpty) Loading(),
              ],
            );
          },
        ),
      ),
    );
  }
}
