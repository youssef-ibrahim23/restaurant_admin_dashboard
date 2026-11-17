import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_admin_dashboard/core/constants/app_colors.dart';
import 'package:restaurant_admin_dashboard/core/utils/responsive.dart';
import 'package:restaurant_admin_dashboard/features/orders/presentation/BLoC/orders_bloc.dart';
import 'package:restaurant_admin_dashboard/features/orders/presentation/BLoC/orders_event.dart';
import 'package:restaurant_admin_dashboard/features/orders/presentation/BLoC/orders_state.dart';

class FiltersRow extends StatelessWidget {
  const FiltersRow({super.key});

  static const List<String> filters = [
    'All',
    'Pending',
    'Preparing',
    'On the way',
    'Delivered',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersBloc, OrdersState>(
      buildWhen: (previous, current) =>
          previous.selectedFilter != current.selectedFilter,
      builder: (context, state) {
        final fontScale = context.isMobile ? 1.8 : 1.0;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: filters.map((filter) {
              final isSelected =
                  state.selectedFilter.toLowerCase() == filter.toLowerCase();

              return Padding(
                padding: EdgeInsets.only(right: 12.w),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      context
                          .read<OrdersBloc>()
                          .add(FilterOrders(status: filter));
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 9.h,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryColor
                            : Colors.white,
                        borderRadius: BorderRadius.circular(24.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        filter,
                        style: TextStyle(
                          fontSize: 13.sp * fontScale,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF6F6964),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
