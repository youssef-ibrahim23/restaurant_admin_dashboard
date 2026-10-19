import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_admin_dashboard/features/orders/data/model/order_model.dart';

class OrdersTable extends StatelessWidget {
  final List<OrderModel> orders;
  final String? selectedOrderId;
  final Function(String)? onOrderSelected;

  const OrdersTable({
    super.key,
    required this.orders,
    this.selectedOrderId,
    this.onOrderSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return Center(
        child: Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: const Color(0xFFE8E4DF)),
          ),
          child: Text(
            'No orders found',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.sp, color: const Color(0xFF8A8580)),
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: const Color(0xFFE8E4DF)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: SingleChildScrollView(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: DataTable(
                    headingRowHeight: 56.h,
                    dataRowMinHeight: 70.h,
                    dataRowMaxHeight: 70.h,
                    columnSpacing: 40.w,
                    horizontalMargin: 24.w,
                    headingRowColor: WidgetStateProperty.all(
                      const Color(0xFFFAF9F7),
                    ),
                    showCheckboxColumn: false,
                    columns: [
                      _column('Order'),
                      _column('Customer'),
                      _column('Total'),
                      _column('Status'),
                    ],
                    rows: orders.map((order) {
                      final isSelected = order.id == selectedOrderId;
                      return DataRow(
                        color: isSelected
                            ? WidgetStateProperty.all(const Color(0xFFE8E4DF))
                            : WidgetStateProperty.all(Colors.transparent),
                        onSelectChanged: (selected) {
                          if (onOrderSelected != null) {
                            onOrderSelected!(order.id);
                          }
                        },
                        cells: [
                          DataCell(
                            Text(
                              '#${order.id}',
                              style: _cellStyle(
                                color: const Color(0xFF211E1C),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              order.userName,
                              style: _cellStyle(color: const Color(0xFF6F6964)),
                            ),
                          ),
                          DataCell(
                            Text(
                              'EGP ${order.totalPrice.toStringAsFixed(2)}',
                              style: _cellStyle(
                                color: const Color(0xFF211E1C),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          DataCell(_statusBadge(order.status)),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

DataColumn _column(String label) {
  return DataColumn(
    label: Text(
      label,
      style: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF6F6964),
      ),
    ),
  );
}

TextStyle _cellStyle({
  required Color color,
  FontWeight fontWeight = FontWeight.normal,
}) {
  return TextStyle(fontSize: 14.sp, color: color, fontWeight: fontWeight);
}

Widget _statusBadge(String status) {
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

    'preparing' || 'processing' => (
    const Color(0xFFFFF1C9),
    const Color(0xFFD99A00),
    ),

    'pending' => (
    const Color(0xFFFFF1C9),
    const Color(0xFFD99A00),
    ),

    'cancelled' || 'canceled' => (
    const Color(0xFFEDEDED),
    const Color(0xFF777777),
    ),

    _ => (
    const Color(0xFFF1EFED),
    const Color(0xFF6F6964),
    ),
  };

  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: 10.w,
      vertical: 5.h,
    ),
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(20.r),
    ),
    child: Text(
      status,
      style: TextStyle(
        color: textColor,
        fontSize: 11.sp,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
