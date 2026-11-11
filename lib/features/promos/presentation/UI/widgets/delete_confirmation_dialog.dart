import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:restaurant_admin_dashboard/core/utils/responsive.dart';
import 'package:restaurant_admin_dashboard/features/promos/presentation/BLoC/promos_bloc.dart';
import 'package:restaurant_admin_dashboard/features/promos/presentation/BLoC/promos_event.dart';

class DeletePromoConfirmationDialog {
  static void show(BuildContext context, String id, String promoCode) {
    AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.noHeader,
      title: 'Delete Promo',
      desc:
          'Are you sure you want to delete promo "$promoCode"?\n\nThis action cannot be undone.',
      width: context.adaptiveDialogWidth(450.w),
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
            context.read<PromosBloc>().add(DeletePromo(id: id));
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
            'Delete',
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
