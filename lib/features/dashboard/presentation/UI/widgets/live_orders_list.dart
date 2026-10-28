import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LiveOrdersList extends StatelessWidget {
  final Map<int, String> liveOrders;

  const LiveOrdersList({
    super.key,
    required this.liveOrders,
  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'on the way':
        return const Color(0xFF27AE60);
      case 'preparing':
        return const Color(0xFFF2994A);
      case 'pending':
        return const Color(0xFF8A8580);
      case 'delivered':
        return const Color(0xFF2D9CDB);
      default:
        return const Color(0xFF8A8580);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFFE5E5E5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Live orders',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF211E1C),
            ),
          ),
          SizedBox(height: 20.h),
          ...liveOrders.entries
              .where((entry) => entry.value.toLowerCase() != 'cancelled')
              .take(3)
              .map((entry) {
            final orderId = entry.key;
            final status = entry.value;
            final statusColor = _getStatusColor(status);

            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: Row(
                children: [
                  Container(
                    width: 48.w,
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.restaurant,
                        size: 24.sp,
                        color: const Color(0xFF8A8580),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '#$orderId',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF211E1C),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          status,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: statusColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
