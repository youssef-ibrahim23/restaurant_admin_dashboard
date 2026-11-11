import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_admin_dashboard/features/orders/data/model/order_model.dart';
import 'package:restaurant_admin_dashboard/features/orders/presentation/BLoC/orders_bloc.dart';
import 'package:restaurant_admin_dashboard/features/orders/presentation/BLoC/orders_event.dart';
import 'package:restaurant_admin_dashboard/features/orders/presentation/BLoC/orders_state.dart';
import 'package:restaurant_admin_dashboard/features/orders/presentation/UI/widgets/filters_row.dart';
import 'package:restaurant_admin_dashboard/features/orders/presentation/UI/widgets/order_details.dart';

class OrdersMobileView extends StatelessWidget {
  final List<OrderModel> displayedOrders;
  final OrdersState state;

  const OrdersMobileView({
    super.key,
    required this.displayedOrders,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
          child: _MobileHeader(),
        ),
        SizedBox(height: 16.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: const FiltersRow(),
        ),
        SizedBox(height: 16.h),
        Expanded(child: _buildOrdersList(context)),
      ],
    );
  }

  Widget _buildOrdersList(BuildContext context) {
    if (state is OrdersError && state.orders.isEmpty) {
      final errorState = state as OrdersError;
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Unable to load orders: ${errorState.message}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28.sp, color: const Color(0xFFD64545)),
            ),
            SizedBox(height: 12.h),
            ElevatedButton(
              onPressed: () => context.read<OrdersBloc>().add(LoadOrders()),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (displayedOrders.isEmpty) {
      return Center(
        child: Text(
          'No orders found',
          style: TextStyle(fontSize: 28.sp, color: const Color(0xFF8A8580)),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: displayedOrders.length,
      separatorBuilder: (_, _) => SizedBox(height: 10.h),
      itemBuilder: (context, index) {
        final order = displayedOrders[index];
        return _OrderCard(
          order: order,
          onTap: () {
            context.read<OrdersBloc>().add(SelectOrder(orderId: order.id));
            _showOrderDetails(context, order);
          },
        );
      },
    );
  }

  void _showOrderDetails(BuildContext context, OrderModel order) {
    final ordersBloc = context.read<OrdersBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (sheetContext) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return BlocProvider.value(
              value: ordersBloc,
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: const TextScaler.linear(1.8),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: OrderDetails(
                    order: order,
                    onStatusUpdated: () => Navigator.of(sheetContext).pop(),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _MobileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Restaurant Orders',
          style: TextStyle(
            fontSize: 56.sp,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF211E1C),
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          'Explore your restaurant orders information',
          style: TextStyle(
            fontSize: 28.sp,
            color: const Color(0xFF8A8580),
          ),
        ),
      ],
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onTap;

  const _OrderCard({required this.order, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(28.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28.r),
        child: Container(
          padding: EdgeInsets.all(28.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28.r),
            border: Border.all(color: const Color(0xFFE8E4DF)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '#${order.id}',
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF211E1C),
                    ),
                  ),
                  _StatusBadge(status: order.status),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      order.userName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 26.sp,
                        color: const Color(0xFF6F6964),
                      ),
                    ),
                  ),
                  Text(
                    'EGP ${order.totalPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF211E1C),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final normalizedStatus = status.toLowerCase().trim();

    final (backgroundColor, textColor) = switch (normalizedStatus) {
      'delivered' || 'completed' => (
        const Color(0xFFE3F4E9),
        const Color(0xFF3A9B5F),
      ),
      'on the way' || 'on_the_way' || 'ontheway' => (
        const Color(0xFFFFE9DE),
        const Color(0xFFFF6B2C),
      ),
      'preparing' || 'processing' || 'pending' => (
        const Color(0xFFFFF1C9),
        const Color(0xFFD99A00),
      ),
      'cancelled' || 'canceled' => (
        const Color(0xFFEDEDED),
        const Color(0xFF777777),
      ),
      _ => (const Color(0xFFF1EFED), const Color(0xFF6F6964)),
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(40.r),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 22.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
