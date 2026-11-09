import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_admin_dashboard/features/drivers/data/model/driver_model.dart';
import 'package:restaurant_admin_dashboard/features/drivers/presentation/BLoC/drivers_bloc.dart';
import 'package:restaurant_admin_dashboard/features/drivers/presentation/BLoC/drivers_event.dart';
import 'package:restaurant_admin_dashboard/features/drivers/presentation/BLoC/drivers_state.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/shared/widgets/loading.dart';
import 'widgets/driver_list.dart';
import 'widgets/drivers_map.dart';
import 'widgets/header.dart';

class DriversPresenter extends StatelessWidget {
  const DriversPresenter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DriversBloc>()..add(LoadDrivers()),
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F5F1),
        body: BlocBuilder<DriversBloc, DriversState>(
          builder: (context, state) {
            return Stack(
              children: [
                Padding(
                  padding: EdgeInsets.all(32.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DriversHeader(
                        onlineCount: _getOnlineCount(state.allDrivers),
                        offlineCount: _getOfflineCount(state.allDrivers),
                        onAddDriver: () {
                        },
                      ),
                      SizedBox(height: 28.h),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left panel - Driver list
                            Expanded(
                              flex: 1,
                              child: SingleChildScrollView(
                                child: DriverList(drivers: state.drivers),
                              ),
                            ),
                            SizedBox(width: 20.w),
                            // Right panel - Map
                            Expanded(
                              flex: 1,
                              child: const DriversMap(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (state is DriversLoading && state.drivers.isEmpty)
                  const Loading(),
              ],
            );
          },
        ),
      ),
    );
  }

  int _getOnlineCount(List<DriverModel> drivers) {
    return drivers.where((d) => d.status.toLowerCase() == 'available' || d.status.toLowerCase() == 'delivering').length;
  }

  int _getOfflineCount(List<DriverModel> drivers) {
    return drivers.where((d) => d.status.toLowerCase() == 'offline').length;
  }
}
