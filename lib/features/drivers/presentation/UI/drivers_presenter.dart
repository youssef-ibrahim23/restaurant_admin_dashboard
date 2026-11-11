import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_admin_dashboard/core/di/service_locator.dart';
import 'package:restaurant_admin_dashboard/core/shared/widgets/loading.dart';
import 'package:restaurant_admin_dashboard/core/utils/responsive.dart';
import 'package:restaurant_admin_dashboard/features/drivers/presentation/BLoC/drivers_bloc.dart';
import 'package:restaurant_admin_dashboard/features/drivers/presentation/BLoC/drivers_event.dart';
import 'package:restaurant_admin_dashboard/features/drivers/presentation/BLoC/drivers_state.dart';
import 'package:restaurant_admin_dashboard/features/drivers/presentation/UI/widgets/desktop_view.dart';
import 'package:restaurant_admin_dashboard/features/drivers/presentation/UI/widgets/mobile_view.dart';

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
                AdaptiveView(
                  desktop: DriversDesktopView(
                    onlineCount: state.onlineCount,
                    offlineCount: state.offlineCount,
                    drivers: state.drivers,
                    onAddDriver: () {},
                  ),
                  mobile: DriversMobileView(
                    onlineCount: state.onlineCount,
                    offlineCount: state.offlineCount,
                    drivers: state.drivers,
                    onAddDriver: () {},
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
}
