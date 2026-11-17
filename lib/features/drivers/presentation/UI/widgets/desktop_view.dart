import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_admin_dashboard/features/drivers/data/model/driver_model.dart';
import 'package:restaurant_admin_dashboard/features/drivers/presentation/UI/widgets/driver_list.dart';
import 'package:restaurant_admin_dashboard/features/drivers/presentation/UI/widgets/drivers_map.dart';
import 'package:restaurant_admin_dashboard/features/drivers/presentation/UI/widgets/header.dart';

class DriversDesktopView extends StatelessWidget {
  final int onlineCount;
  final int offlineCount;
  final List<DriverModel> drivers;
  final VoidCallback onAddDriver;

  const DriversDesktopView({
    super.key,
    required this.onlineCount,
    required this.offlineCount,
    required this.drivers,
    required this.onAddDriver,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(32.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DriversHeader(
            onlineCount: onlineCount,
            offlineCount: offlineCount,
            onAddDriver: onAddDriver,
          ),
          SizedBox(height: 28.h),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: DriverList(drivers: drivers),
                  ),
                ),
                SizedBox(width: 20.w),
                const Expanded(flex: 1, child: DriversMap()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
