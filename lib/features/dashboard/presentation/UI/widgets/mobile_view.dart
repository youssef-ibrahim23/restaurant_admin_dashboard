import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_admin_dashboard/features/dashboard/data/model/dashboard_model.dart';
import 'package:restaurant_admin_dashboard/features/dashboard/presentation/UI/widgets/dashboard_header.dart';
import 'package:restaurant_admin_dashboard/features/dashboard/presentation/UI/widgets/live_orders_list.dart';
import 'package:restaurant_admin_dashboard/features/dashboard/presentation/UI/widgets/revenue_chart.dart';

class DashboardMobileView extends StatelessWidget {
  final DashboardModel dashboard;

  const DashboardMobileView({super.key, required this.dashboard});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        const DashboardHeader(),
        SizedBox(height: 20.h),
        _MobileMetricCard(
          title: 'Revenue',
          value: 'EGP ${(dashboard.revenue / 1000).toStringAsFixed(1)}k',
          percentageChange: '12%',
          isPositive: true,
          icon: Icons.attach_money,
        ),
        SizedBox(height: 12.h),
        _MobileMetricCard(
          title: 'Orders',
          value: dashboard.totalOrders?.toString() ?? '0',
          percentageChange: '8%',
          isPositive: true,
          icon: Icons.shopping_bag,
        ),
        SizedBox(height: 20.h),
        RevenueChart(weeklyRevenue: dashboard.currentWeekDaysRevenue),
        SizedBox(height: 20.h),
        LiveOrdersList(liveOrders: dashboard.liveOrders),
        SizedBox(height: 24.h),
      ],
    );
  }
}

class _MobileMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String percentageChange;
  final bool isPositive;
  final IconData icon;

  const _MobileMetricCard({
    required this.title,
    required this.value,
    required this.percentageChange,
    required this.isPositive,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(40.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32.r),
        border: Border.all(
          color: const Color(0xFFE5E5E5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 48.sp,
            color: const Color(0xFFFD5B22),
          ),
          SizedBox(height: 32.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 28.sp,
              color: const Color(0xFF8A8580),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 48.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF211E1C),
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Icon(
                isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                size: 32.sp,
                color: isPositive ? const Color(0xFF27AE60) : const Color(0xFFEB5757),
              ),
              SizedBox(width: 8.w),
              Text(
                percentageChange,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                  color: isPositive ? const Color(0xFF27AE60) : const Color(0xFFEB5757),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
