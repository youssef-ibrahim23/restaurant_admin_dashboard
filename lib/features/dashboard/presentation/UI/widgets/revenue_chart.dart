import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RevenueChart extends StatelessWidget {
  final Map<String, double> weeklyRevenue;

  const RevenueChart({
    super.key,
    required this.weeklyRevenue,
  });

  @override
  Widget build(BuildContext context) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final maxValue = weeklyRevenue.values.isEmpty 
        ? 1.0 
        : weeklyRevenue.values.reduce((a, b) => a > b ? a : b);
    
    final maxRevenueDay = weeklyRevenue.entries.isEmpty 
        ? null 
        : weeklyRevenue.entries.reduce((a, b) => a.value > b.value ? a : b).key;

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
            'Revenue',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF211E1C),
            ),
          ),
          SizedBox(height: 24.h),
          SizedBox(
            height: 200.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: days.asMap().entries.map((entry) {
                final index = entry.key;
                final day = entry.value;
                final revenue = weeklyRevenue[day] ?? 0.0;
                final barHeight = maxValue > 0 ? (revenue / maxValue) * 160.h : 0.0;
                final isHighlighted = day == maxRevenueDay;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 32.w,
                      height: barHeight,
                      decoration: BoxDecoration(
                        color: isHighlighted 
                            ? const Color(0xFFFD5B22) 
                            : const Color(0xFFE5E5E5),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      day,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: isHighlighted 
                            ? const Color(0xFFFD5B22) 
                            : const Color(0xFF8A8580),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
