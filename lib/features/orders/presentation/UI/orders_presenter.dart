import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_admin_dashboard/core/shared/widgets/loading.dart';
import 'package:restaurant_admin_dashboard/features/orders/presentation/UI/widgets/header.dart';
import 'package:restaurant_admin_dashboard/features/orders/presentation/BLoC/orders_event.dart';
import 'package:restaurant_admin_dashboard/features/orders/presentation/BLoC/orders_bloc.dart';
import 'package:restaurant_admin_dashboard/features/orders/presentation/BLoC/orders_state.dart';
import 'package:restaurant_admin_dashboard/features/orders/presentation/UI/widgets/table.dart';
import 'package:restaurant_admin_dashboard/features/orders/presentation/UI/widgets/order_details.dart';

import '../../../../core/di/service_locator.dart';
import '../../data/model/order_model.dart';

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
            OrderModel? selectedOrder;
            if (state.selectedOrderId != null) {
              final index = state.orders.indexWhere(
                (order) => order.id == state.selectedOrderId,
              );
              if (index >= 0) {
                selectedOrder = state.orders[index];
              } else if (state.orders.isNotEmpty) {
                selectedOrder = state.orders.first;
              }
            } else if (state.orders.isNotEmpty) {
              selectedOrder = state.orders.first;
            }

            return Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(10.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Header(),
                            SizedBox(height: 28.h),
                            Expanded(
                              child:
                                  state is OrdersError && state.orders.isEmpty
                                  ? Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Unable to load orders: ${state.message}',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              color: const Color(0xFFD64545),
                                            ),
                                          ),
                                          SizedBox(height: 12.h),
                                          ElevatedButton(
                                            onPressed: () => context
                                                .read<OrdersBloc>()
                                                .add(LoadOrders()),
                                            child: const Text('Retry'),
                                          ),
                                        ],
                                      ),
                                    )
                                  : OrdersTable(
                                      orders: state.orders,
                                      selectedOrderId: state.selectedOrderId,
                                      onOrderSelected: (orderId) {
                                        context.read<OrdersBloc>().add(
                                          SelectOrder(orderId: orderId),
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (selectedOrder != null) SizedBox(width: 24.w),
                    if (selectedOrder != null)
                      Container(
                        width: 400.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFE8E4DF)),
                        ),
                        child: OrderDetails(order: selectedOrder),
                      ),
                  ],
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
