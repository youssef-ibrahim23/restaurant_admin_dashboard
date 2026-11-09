import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_admin_dashboard/features/drivers/data/model/driver_model.dart';

import 'driver_list_item.dart';

class DriverList extends StatelessWidget {
  final List<DriverModel> drivers;

  const DriverList({
    super.key,
    required this.drivers,
  });

  @override
  Widget build(BuildContext context) {
    if (drivers.isEmpty) {
      return Center(
        child: Text(
          'No drivers available',
          style: TextStyle(
            fontSize: 16.sp,
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
        return DriverListItem(driver: drivers[index]);
      },
    );
  }
}
