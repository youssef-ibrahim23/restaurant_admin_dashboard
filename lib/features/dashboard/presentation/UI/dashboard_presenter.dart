import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_admin_dashboard/core/di/service_locator.dart';
import 'package:restaurant_admin_dashboard/core/shared/widgets/loading.dart';
import 'package:restaurant_admin_dashboard/core/utils/responsive.dart';
import 'package:restaurant_admin_dashboard/features/dashboard/presentation/BLoC/dashboard_bloc.dart';
import 'package:restaurant_admin_dashboard/features/dashboard/presentation/BLoC/dashboard_event.dart';
import 'package:restaurant_admin_dashboard/features/dashboard/presentation/BLoC/dashboard_state.dart';
import 'package:restaurant_admin_dashboard/features/dashboard/presentation/UI/widgets/desktop_view.dart';
import 'package:restaurant_admin_dashboard/features/dashboard/presentation/UI/widgets/mobile_view.dart';

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
                if (state is DashboardLoaded)
                  AdaptiveView(
                    desktop: DashboardDesktopView(
                      dashboard: state.dashboardModel,
                    ),
                    mobile: DashboardMobileView(
                      dashboard: state.dashboardModel,
                    ),
                  )
                else
                  const SizedBox.shrink(),
                if (state is DashboardLoading) const Loading(),
              ],
            );
          },
        ),
      ),
    );
  }
}
