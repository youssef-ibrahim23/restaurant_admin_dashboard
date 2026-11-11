import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_admin_dashboard/features/settings/data/model/restaurant_settings_model.dart';
import 'package:restaurant_admin_dashboard/features/settings/presentation/UI/widgets/edit_profile_dialog.dart';
import 'package:restaurant_admin_dashboard/features/settings/presentation/UI/widgets/logout_confirmation_dialog.dart';

class SettingsMobileView extends StatelessWidget {
  final RestaurantSettingsModel settings;

  const SettingsMobileView({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MobileHeader(),
          SizedBox(height: 16.h),
          _MobileRestaurantProfileCard(settings: settings),
          SizedBox(height: 16.h),
          const _MobileSecuritySessionCard(),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}

class _MobileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Settings',
          style: TextStyle(
            fontSize: 56.sp,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF211E1C),
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          'Manage your restaurant profile, operational preferences, and account security',
          style: TextStyle(
            fontSize: 28.sp,
            color: const Color(0xFF8A8580),
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: const Color(0xFFE7F7ED),
            borderRadius: BorderRadius.circular(40.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 16.w,
                height: 16.w,
                decoration: const BoxDecoration(
                  color: Color(0xFF239B56),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 16.w),
              Text(
                'Store Online',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF239B56),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MobileRestaurantProfileCard extends StatelessWidget {
  final RestaurantSettingsModel settings;

  const _MobileRestaurantProfileCard({required this.settings});

  @override
  Widget build(BuildContext context) {
    final tileWidth =
        (MediaQuery.sizeOf(context).width - 48.w * 2 - 24.w) / 2;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(48.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32.r),
        border: Border.all(color: const Color(0xFFE8E4DF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 88.w,
                    height: 88.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF0E9),
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.storefront_rounded,
                      color: const Color(0xFFFF5A1F),
                      size: 48.sp,
                    ),
                  ),
                  SizedBox(width: 28.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Restaurant Profile',
                        style: TextStyle(
                          fontSize: 36.sp,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF211E1C),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Basic details & branding information',
                        style: TextStyle(
                          fontSize: 24.sp,
                          color: const Color(0xFF8A8580),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              OutlinedButton.icon(
                onPressed: () => EditProfileDialog.show(context, settings),
                icon: Icon(Icons.edit_outlined, size: 32.sp),
                label: Text(
                  'Edit Details',
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFFF5A1F),
                  side: const BorderSide(color: Color(0xFFFF5A1F)),
                  padding:
                      EdgeInsets.symmetric(horizontal: 32.w, vertical: 20.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 48.h),
          const Divider(color: Color(0xFFF1EFEA), height: 1),
          SizedBox(height: 40.h),
          Wrap(
            spacing: 24.w,
            runSpacing: 32.h,
            children: [
              _infoTile('Brand Name', settings.restaurantName, Icons.business,
                  width: tileWidth),
              _infoTile('Contact Email', settings.email, Icons.email_outlined,
                  width: tileWidth),
              _infoTile('Phone Number', settings.phone, Icons.phone_outlined,
                  width: tileWidth),
              _infoTile('Branch Location', settings.address,
                  Icons.location_on_outlined, width: tileWidth),
              _infoTile('Operating Hours', settings.openingHours,
                  Icons.access_time_rounded, width: tileWidth),
              _infoTile('Base Currency', settings.currency,
                  Icons.payments_outlined, width: tileWidth),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoTile(String label, String value, IconData icon,
      {required double width}) {
    return SizedBox(
      width: width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 36.sp, color: const Color(0xFF8A8580)),
          SizedBox(width: 20.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 24.sp,
                    color: const Color(0xFF8A8580),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 28.sp,
                    color: const Color(0xFF211E1C),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileSecuritySessionCard extends StatelessWidget {
  const _MobileSecuritySessionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(48.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32.r),
        border: Border.all(color: const Color(0xFFE8E4DF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 88.w,
                height: 88.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0E9),
                  borderRadius: BorderRadius.circular(24.r),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.shield_outlined,
                  color: const Color(0xFFFF5A1F),
                  size: 48.sp,
                ),
              ),
              SizedBox(width: 28.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Account & Security',
                    style: TextStyle(
                      fontSize: 36.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF211E1C),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Manage your session and administrator credentials',
                    style: TextStyle(
                      fontSize: 24.sp,
                      color: const Color(0xFF8A8580),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 40.h),
          const Divider(color: Color(0xFFF1EFEA), height: 1),
          SizedBox(height: 32.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F5F0),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Icon(
                      Icons.admin_panel_settings_outlined,
                      size: 40.sp,
                      color: const Color(0xFF6F6964),
                    ),
                  ),
                  SizedBox(width: 28.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Administrator Access',
                            style: TextStyle(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF211E1C),
                            ),
                          ),
                          SizedBox(width: 20.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF0E9),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              'Super Admin',
                              style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFFF5A1F),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Full permissions across menus, orders, promos, and settings',
                        style: TextStyle(
                          fontSize: 24.sp,
                          color: const Color(0xFF8A8580),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 32.h),
          const Divider(color: Color(0xFFF1EFEA), height: 1),
          SizedBox(height: 32.h),
          Container(
            padding: EdgeInsets.all(32.w),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF5F5),
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(color: const Color(0xFFFFD1D1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFDE8E8),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.logout_rounded,
                        color: const Color(0xFFD64545),
                        size: 44.sp,
                      ),
                    ),
                    SizedBox(width: 28.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sign Out of FoodAdmin',
                          style: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFD64545),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'End your current admin session on this device',
                          style: TextStyle(
                            fontSize: 24.sp,
                            color: const Color(0xFF6F6964),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => LogoutConfirmationDialog.show(context),
                  icon: Icon(Icons.logout_rounded, size: 32.sp),
                  label: Text(
                    'Log Out',
                    style: TextStyle(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD64545),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(
                        horizontal: 40.w, vertical: 24.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
