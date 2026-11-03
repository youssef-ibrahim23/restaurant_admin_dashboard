import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../data/model/restaurant_settings_model.dart';
import 'edit_profile_dialog.dart';

class RestaurantProfileCard extends StatelessWidget {
  final RestaurantSettingsModel settings;

  const RestaurantProfileCard({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
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
                    width: 44.w,
                    height: 44.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF0E9),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.storefront_rounded,
                      color: const Color(0xFFFF5A1F),
                      size: 24.sp,
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Restaurant Profile',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF211E1C),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Basic details & branding information',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFF8A8580),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              OutlinedButton.icon(
                onPressed: () => EditProfileDialog.show(context, settings),
                icon: Icon(Icons.edit_outlined, size: 16.sp),
                label: Text(
                  'Edit Details',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFFF5A1F),
                  side: const BorderSide(color: Color(0xFFFF5A1F)),
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          const Divider(color: Color(0xFFF1EFEA), height: 1),
          SizedBox(height: 20.h),
          Wrap(
            spacing: 32.w,
            runSpacing: 20.h,
            children: [
              _infoTile('Brand Name', settings.restaurantName, Icons.business),
              _infoTile('Contact Email', settings.email, Icons.email_outlined),
              _infoTile('Phone Number', settings.phone, Icons.phone_outlined),
              _infoTile('Branch Location', settings.address,
                  Icons.location_on_outlined),
              _infoTile('Operating Hours', settings.openingHours,
                  Icons.access_time_rounded),
              _infoTile('Base Currency', settings.currency,
                  Icons.payments_outlined),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoTile(String label, String value, IconData icon) {
    return SizedBox(
      width: 240.w,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18.sp, color: const Color(0xFF8A8580)),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF8A8580),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.sp,
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
