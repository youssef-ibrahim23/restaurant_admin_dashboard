import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_admin_dashboard/features/drivers/data/model/driver_model.dart';
import 'package:restaurant_admin_dashboard/features/drivers/presentation/UI/widgets/drivers_map.dart';

class DriversMobileView extends StatelessWidget {
  final int onlineCount;
  final int offlineCount;
  final List<DriverModel> drivers;
  final VoidCallback onAddDriver;

  const DriversMobileView({
    super.key,
    required this.onlineCount,
    required this.offlineCount,
    required this.drivers,
    required this.onAddDriver,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
          child: _MobileHeader(
            onlineCount: onlineCount,
            offlineCount: offlineCount,
            onAddDriver: onAddDriver,
          ),
        ),
        SizedBox(height: 16.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SizedBox(
            height: 220.h,
            child: const DriversMap(),
          ),
        ),
        SizedBox(height: 16.h),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SingleChildScrollView(
              child: _MobileDriverList(drivers: drivers),
            ),
          ),
        ),
      ],
    );
  }
}

class _MobileHeader extends StatelessWidget {
  final int onlineCount;
  final int offlineCount;
  final VoidCallback onAddDriver;

  const _MobileHeader({
    required this.onlineCount,
    required this.offlineCount,
    required this.onAddDriver,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Drivers',
          style: TextStyle(
            fontSize: 64.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          '$onlineCount online · $offlineCount offline',
          style: TextStyle(
            fontSize: 28.sp,
            color: const Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }
}

class _MobileDriverList extends StatelessWidget {
  final List<DriverModel> drivers;

  const _MobileDriverList({required this.drivers});

  @override
  Widget build(BuildContext context) {
    if (drivers.isEmpty) {
      return Center(
        child: Text(
          'No drivers available',
          style: TextStyle(
            fontSize: 28.sp,
            color: const Color(0xFF6B7280),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: drivers.length,
      itemBuilder: (context, index) {
        return _MobileDriverListItem(driver: drivers[index]);
      },
    );
  }
}

class _MobileDriverListItem extends StatelessWidget {
  final DriverModel driver;

  const _MobileDriverListItem({required this.driver});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      padding: EdgeInsets.all(32.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 56.r,
            backgroundColor: const Color(0xFFFF6B00).withOpacity(0.1),
            child: Text(
              _getInitials(driver.name),
              style: TextStyle(
                fontSize: 36.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFFF6B00),
              ),
            ),
          ),
          SizedBox(width: 32.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  driver.name,
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: 32.sp,
                      color: const Color(0xFFFFC107),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      driver.rate.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 26.sp,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Text(
                      '·',
                      style: TextStyle(
                        fontSize: 26.sp,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Text(
                      '${driver.totalTrips} trips',
                      style: TextStyle(
                        fontSize: 26.sp,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 24.w),
          _buildStatusTag(driver.status),
        ],
      ),
    );
  }

  Widget _buildStatusTag(String status) {
    Color backgroundColor;
    Color textColor;
    String displayText;

    switch (status.toLowerCase()) {
      case 'delivering':
        backgroundColor = const Color(0xFFFEE2E2);
        textColor = const Color(0xFFDC2626);
        displayText = 'Delivering';
        break;
      case 'available':
        backgroundColor = const Color(0xFFD1FAE5);
        textColor = const Color(0xFF059669);
        displayText = 'Available';
        break;
      case 'offline':
      default:
        backgroundColor = const Color(0xFFF3F4F6);
        textColor = const Color(0xFF6B7280);
        displayText = 'Offline';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Text(
        displayText,
        style: TextStyle(
          fontSize: 24.sp,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, 1).toUpperCase();
  }
}
