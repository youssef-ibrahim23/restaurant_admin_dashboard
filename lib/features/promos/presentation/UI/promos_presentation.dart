import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_admin_dashboard/core/di/service_locator.dart';
import 'package:restaurant_admin_dashboard/core/shared/widgets/loading.dart';
import 'package:restaurant_admin_dashboard/core/utils/responsive.dart';
import 'package:restaurant_admin_dashboard/features/promos/presentation/BLoC/promos_bloc.dart';
import 'package:restaurant_admin_dashboard/features/promos/presentation/BLoC/promos_event.dart';
import 'package:restaurant_admin_dashboard/features/promos/presentation/BLoC/promos_state.dart';
import 'package:restaurant_admin_dashboard/features/promos/presentation/UI/widgets/desktop_view.dart';
import 'package:restaurant_admin_dashboard/features/promos/presentation/UI/widgets/mobile_view.dart';

class PromosPresenter extends StatelessWidget {
  const PromosPresenter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<PromosBloc>()..add(LoadPromos()),
      child: BlocListener<PromosBloc, PromosState>(
        listener: (context, state) {
          if (state is PromoActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: const Color(0xFF239B56),
                duration: const Duration(seconds: 2),
              ),
            );
            context.read<PromosBloc>().add(LoadPromos());
          } else if (state is PromosError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: const Color(0xFFD64545),
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF7F5F1),
          body: BlocBuilder<PromosBloc, PromosState>(
            buildWhen: (previous, current) {
              return previous.isLoading != current.isLoading ||
                  previous.promos.length != current.promos.length;
            },
            builder: (context, state) {
              return Stack(
                children: [
                  AdaptiveView(
                    desktop: const PromosDesktopView(),
                    mobile: const PromosMobileView(),
                  ),
                  if (state is PromosLoading && state.promos.isEmpty)
                    Loading(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
