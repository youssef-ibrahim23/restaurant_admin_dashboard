import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_admin_dashboard/features/settings/data/model/restaurant_settings_model.dart';
import 'package:restaurant_admin_dashboard/features/settings/presentation/UI/widgets/header.dart';
import 'package:restaurant_admin_dashboard/features/settings/presentation/UI/widgets/restaurant_profile_card.dart';
import 'package:restaurant_admin_dashboard/features/settings/presentation/UI/widgets/security_session_card.dart';

class SettingsDesktopView extends StatelessWidget {
  final RestaurantSettingsModel settings;

  const SettingsDesktopView({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(32.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SettingsHeader(),
          SizedBox(height: 24.h),
          RestaurantProfileCard(settings: settings),
          SizedBox(height: 24.h),
          const SecuritySessionCard(),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }
}
