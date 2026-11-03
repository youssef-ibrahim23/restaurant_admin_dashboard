import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:restaurant_admin_dashboard/core/di/service_locator.dart';
import 'package:restaurant_admin_dashboard/core/shared/widgets/loading.dart';
import '../BLoC/settings_bloc.dart';
import '../BLoC/settings_event.dart';
import '../BLoC/settings_state.dart';
import 'widgets/header.dart';
import 'widgets/restaurant_profile_card.dart';
import 'widgets/security_session_card.dart';

class SettingsPresenter extends StatelessWidget {
  const SettingsPresenter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SettingsBloc>()..add(LoadSettings()),
      child: BlocListener<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is SettingsActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: const Color(0xFF239B56),
                duration: const Duration(seconds: 2),
              ),
            );
          } else if (state is SettingsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: const Color(0xFFD64545),
                duration: const Duration(seconds: 3),
              ),
            );
          } else if (state is LogoutSuccess) {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.noHeader,
              animType: AnimType.scale,
              title: 'Logged Out',
              desc:
                  'You have been logged out successfully.',
              width: 450.w,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              btnOkText: 'OK',
              btnOkColor: const Color(0xFFFD5B22),
              btnOkOnPress: () {
                context.read<SettingsBloc>().add(LoadSettings());
              },
            ).show();
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF7F5F1),
          body: BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              return Stack(
                children: [
                  SingleChildScrollView(
                    padding: EdgeInsets.all(32.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SettingsHeader(),
                        SizedBox(height: 24.h),
                        RestaurantProfileCard(settings: state.settings),
                        SizedBox(height: 24.h),
                        const SecuritySessionCard(),
                        SizedBox(height: 32.h),
                      ],
                    ),
                  ),
                  if (state is SettingsLoading) Loading(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
