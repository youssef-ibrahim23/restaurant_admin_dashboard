import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../../BLoC/settings_bloc.dart';
import '../../BLoC/settings_event.dart';

class LogoutConfirmationDialog {
  static void show(BuildContext context) {
    AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.noHeader,
      title: 'Sign Out',
      desc:
          'Are you sure you want to log out of FoodAdmin?\n\nYou will need your admin credentials to log back in.',
      width: 450.w,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      descTextStyle: TextStyle(
        fontSize: 14.sp,
        color: const Color(0xFF6F6964),
        height: 1.5,
      ),
      titleTextStyle: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF211E1C),
      ),
      btnOk: Container(
        height: 44.h,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFD64545), Color(0xFFE85D5D)],
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: ElevatedButton(
          onPressed: () {
            context.read<SettingsBloc>().add(LogoutEvent());
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          child: Text(
            'Log Out',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      btnCancel: Container(
        height: 44.h,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F1F1),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: const Color(0xFF211E1C),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          child: Text(
            'Cancel',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      buttonsBorderRadius: BorderRadius.circular(12.r),
    ).show();
  }
}
