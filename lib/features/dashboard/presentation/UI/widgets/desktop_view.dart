import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_admin_dashboard/features/dashboard/data/model/dashboard_model.dart';
import 'package:restaurant_admin_dashboard/features/dashboard/presentation/UI/widgets/dashboard_header.dart';
import 'package:restaurant_admin_dashboard/features/dashboard/presentation/UI/widgets/live_orders_list.dart';
import 'package:restaurant_admin_dashboard/features/dashboard/presentation/UI/widgets/metric_card.dart';
import 'package:restaurant_admin_dashboard/features/dashboard/presentation/UI/widgets/revenue_chart.dart';

class DashboardDesktopView extends StatelessWidget {
  final DashboardModel dashboard;

  const DashboardDesktopView({super.key, required this.dashboard});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(32.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DashboardHeader(),
          SizedBox(height: 32.h),
          Row(
            children: [
              Expanded(
                child: MetricCard(
                  title: 'Revenue',
                  value:
                      'EGP ${(dashboard.revenue / 1000).toStringAsFixed(1)}k',
                  percentageChange: '12%',
                  isPositive: true,
                  icon: Icons.attach_money,
                ),
              ),
              SizedBox(width: 20.w),
              Expanded(
                child: MetricCard(
                  title: 'Orders',
                  value: dashboard.totalOrders?.toString() ?? '0',
                  percentageChange: '8%',
                  isPositive: true,
                  icon: Icons.shopping_bag,
                ),
              ),
            ],
          ),
          SizedBox(height: 32.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: RevenueChart(
                  weeklyRevenue: dashboard.currentWeekDaysRevenue,
                ),
              ),
              SizedBox(width: 20.w),
              Expanded(
                child: LiveOrdersList(liveOrders: dashboard.liveOrders),
              ),
            ],
          ),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }
}
