import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_admin_dashboard/features/orders/data/model/order_model.dart';
import 'package:restaurant_admin_dashboard/features/orders/presentation/BLoC/orders_bloc.dart';
import 'package:restaurant_admin_dashboard/features/orders/presentation/BLoC/orders_event.dart';
import 'package:restaurant_admin_dashboard/features/orders/presentation/BLoC/orders_state.dart';
import 'package:restaurant_admin_dashboard/features/orders/presentation/UI/widgets/filters_row.dart';
import 'package:restaurant_admin_dashboard/features/orders/presentation/UI/widgets/header.dart';
import 'package:restaurant_admin_dashboard/features/orders/presentation/UI/widgets/order_details.dart';
import 'package:restaurant_admin_dashboard/features/orders/presentation/UI/widgets/table.dart';

class OrdersDesktopView extends StatelessWidget {
  final List<OrderModel> displayedOrders;
  final String? selectedOrderId;
  final OrderModel? selectedOrder;
  final OrdersState state;

  const OrdersDesktopView({
    super.key,
    required this.displayedOrders,
    required this.selectedOrderId,
    required this.selectedOrder,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Header(),
                SizedBox(height: 20.h),
                const FiltersRow(),
                SizedBox(height: 20.h),
                Expanded(
                  child: _buildOrdersContent(context),
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
            child: OrderDetails(order: selectedOrder!),
          ),
      ],
    );
  }

  Widget _buildOrdersContent(BuildContext context) {
    if (state is OrdersError && state.orders.isEmpty) {
      final errorState = state as OrdersError;
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Unable to load orders: ${errorState.message}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: const Color(0xFFD64545)),
            ),
            SizedBox(height: 12.h),
            ElevatedButton(
              onPressed: () =>
                  context.read<OrdersBloc>().add(LoadOrders()),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return OrdersTable(
      orders: displayedOrders,
      selectedOrderId: selectedOrder?.id ?? selectedOrderId,
      onOrderSelected: (orderId) {
        context.read<OrdersBloc>().add(SelectOrder(orderId: orderId));
      },
    );
  }
}
