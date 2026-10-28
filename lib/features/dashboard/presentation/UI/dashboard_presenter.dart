import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_admin_dashboard/features/dashboard/presentation/BLoC/dashboard_bloc.dart';
import 'package:restaurant_admin_dashboard/features/dashboard/presentation/BLoC/dashboard_event.dart';
import 'package:restaurant_admin_dashboard/features/dashboard/presentation/BLoC/dashboard_state.dart';
import 'package:restaurant_admin_dashboard/features/dashboard/presentation/UI/widgets/dashboard_header.dart';
import 'package:restaurant_admin_dashboard/features/dashboard/presentation/UI/widgets/live_orders_list.dart';
import 'package:restaurant_admin_dashboard/features/dashboard/presentation/UI/widgets/metric_card.dart';
import 'package:restaurant_admin_dashboard/features/dashboard/presentation/UI/widgets/revenue_chart.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/shared/widgets/loading.dart';

class DashboardPresenter extends StatelessWidget {
  const DashboardPresenter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DashboardBloc>()..add(GetDashboardData()),
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F5F1),
        body: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            return Stack(
              children: [
                Padding(
                  padding: EdgeInsets.all(32.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const DashboardHeader(),
                      SizedBox(height: 32.h),
                      if (state is DashboardLoaded) ...[
                        Row(
                          children: [
                            Expanded(
                              child: MetricCard(
                                title: 'Revenue',
                                value: 'EGP ${(state.dashboardModel.revenue / 1000).toStringAsFixed(1)}k',
                                percentageChange: '12%',
                                isPositive: true,
                                icon: Icons.attach_money,
                              ),
                            ),
                            SizedBox(width: 20.w),
                            Expanded(
                              child: MetricCard(
                                title: 'Orders',
                                value: state.dashboardModel.totalOrders?.toString() ?? '0',
                                percentageChange: '8%',
                                isPositive: true,
                                icon: Icons.shopping_bag,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 32.h),
                        Row(
                          children: [
                            Expanded(
                              child: RevenueChart(
                                weeklyRevenue: state.dashboardModel.currentWeekDaysRevenue,
                              ),
                            ),
                            SizedBox(width: 20.w),
                            Expanded(
                              child: LiveOrdersList(
                                liveOrders: state.dashboardModel.liveOrders,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                if (state is DashboardLoading)
                  const Loading(),
              ],
            );
          },
        ),
      ),
    );
  }
}