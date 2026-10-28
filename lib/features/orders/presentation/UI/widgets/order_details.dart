import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_admin_dashboard/core/constants/app_colors.dart';
import 'package:restaurant_admin_dashboard/features/orders/data/model/order_model.dart';
import 'package:restaurant_admin_dashboard/features/orders/presentation/BLoC/orders_bloc.dart';
import 'package:restaurant_admin_dashboard/features/orders/presentation/BLoC/orders_event.dart';

class OrderDetails extends StatelessWidget {
  final OrderModel order;


  const OrderDetails({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(context),
          SizedBox(height: 24.h),
          _statusBadge(),
          SizedBox(height: 24.h),
          _itemsList(),
          Text(
            '--------------------------------------------------------------------------------',
            style: TextStyle(color: Colors.transparent.withOpacity(0.3)),
          ),
          SizedBox(height: 24.h),
          _total(),
          SizedBox(height: 24.h),
          _driverInfo(),
          SizedBox(height: 24.h),
          _actionButtons(context),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order #${order.id}',
          style: TextStyle(
            fontSize: 30.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF211E1C),
          ),
        ),
        SizedBox(height: 15.h),
        Text(
          '${order.userName} - ${_formatDate(order.createdAt)}',
          style: TextStyle(fontSize: 15.sp, color: const Color(0xFF6F6964)),
        ),
      ],
    );
  }

  Widget _statusBadge() {
    final normalizedStatus = order.status.toLowerCase().trim();

    final (backgroundColor, textColor) = switch (normalizedStatus) {
      'delivered' ||
      'completed' => (const Color(0xFFE3F4E9), const Color(0xFF3A9B5F)),

      'on the way' ||
      'on_the_way' ||
      'ontheway' => (const Color(0xFFFFE9DE), const Color(0xFFFF6B2C)),

      'preparing' ||
      'processing' => (const Color(0xFFFFF1C9), const Color(0xFFD99A00)),

      'pending' => (const Color(0xFFFFF1C9), const Color(0xFFD99A00)),

      'cancelled' ||
      'canceled' => (const Color(0xFFEDEDED), const Color(0xFF777777)),

      _ => (const Color(0xFFF1EFED), const Color(0xFF6F6964)),
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        order.status,
        style: TextStyle(
          color: textColor,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _itemsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...order.orderItems.map((item) {
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${item.quantity}x ${item.menuItem.name}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF211E1C),
                  ),
                ),
                Text(
                  (item.unitPrice * item.quantity).toStringAsFixed(0),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF211E1C),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _total() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Total',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF211E1C),
          ),
        ),
        Text(
          'EGP ${order.totalPrice.toStringAsFixed(0)}',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF211E1C),
          ),
        ),
      ],
    );
  }

  Widget _driverInfo() {
    return Row(
      children: [
        Text(
          'Driver: Ahmed',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.transparent.withOpacity(0.3),
          ),
        ),
        SizedBox(width: 5.w),
        Icon(Icons.star, color: Colors.yellow, size: 17.sp),
        SizedBox(width: 5.w),
        Text(
          '4.9',
          style: TextStyle(fontSize: 16.sp,
          color: Colors.transparent.withOpacity(0.3)),
        ),
      ],
    );
  }

  Widget _actionButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: () => _showUpdateStatusDialog(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 12.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          child: Text(
            'Update status',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        OutlinedButton(
          onPressed: () {
            context.read<OrdersBloc>().add(UpdateStatus(orderId: order.id, status: 'Cancelled'));
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFD64545),
            side: const BorderSide(color: Color(0xFFD64545)),
            padding: EdgeInsets.symmetric(vertical: 12.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          child: Text(
            'Cancel order',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  void _showUpdateStatusDialog(BuildContext context) {
    final statuses = [
      'Pending',
      'Preparing',
      'On the way',
      'Delivered',
      'Cancelled',
    ];

    String selectedStatus = statuses.firstWhere(
          (status) =>
      status.toLowerCase() == order.status.toLowerCase().trim() ||
          (status == 'Delivered' &&
              order.status.toLowerCase().trim() == 'completed') ||
          (status == 'On the way' &&
              ['on_the_way', 'ontheway']
                  .contains(order.status.toLowerCase().trim())) ||
          (status == 'Cancelled' &&
              order.status.toLowerCase().trim() == 'canceled'),
      orElse: () => 'Pending',
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (builderContext, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              titlePadding: EdgeInsets.fromLTRB(24.w, 20.h, 12.w, 8.h),
              contentPadding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 8.h),
              actionsPadding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 20.h),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Update Order Status',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    icon: const Icon(Icons.close),
                    tooltip: 'Close',
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Choose the new status for this order.',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'Order status',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  DropdownButtonFormField<String>(
                    value: selectedStatus,
                    isExpanded: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 12.h,
                      ),
                    ),
                    items: statuses.map((status) {
                      return DropdownMenuItem<String>(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() {
                          selectedStatus = value;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<OrdersBloc>().add(UpdateStatus(orderId: order.id, status: selectedStatus));
                      Navigator.pop(dialogContext, selectedStatus);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'Save Changes',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }


  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }
  }
}
