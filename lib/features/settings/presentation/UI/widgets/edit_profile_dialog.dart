import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:restaurant_admin_dashboard/core/utils/responsive.dart';
import '../../../data/model/restaurant_settings_model.dart';
import '../../BLoC/settings_bloc.dart';
import '../../BLoC/settings_event.dart';


class EditProfileDialog {
  static void show(BuildContext context, RestaurantSettingsModel settings) {
    final nameController =
        TextEditingController(text: settings.restaurantName);
    final emailController = TextEditingController(text: settings.email);
    final phoneController = TextEditingController(text: settings.phone);
    final addressController = TextEditingController(text: settings.address);
    final hoursController =
        TextEditingController(text: settings.openingHours);
    final currencyController =
        TextEditingController(text: settings.currency);

    String? nameError;
    String? emailError;
    StateSetter? dialogSetState;

    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.scale,
      width: context.adaptiveDialogWidth(580.w),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      body: StatefulBuilder(
        builder: (context, setState) {
          dialogSetState = setState;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Edit Restaurant Profile',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF211E1C),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Update your restaurant brand and contact information',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF8A8580),
                    ),
                  ),
                  SizedBox(height: 18.h),
                  _input(
                    controller: nameController,
                    label: 'Restaurant Name',
                    hint: 'e.g., Burger Lab',
                    error: nameError,
                    onChanged: (_) => setState(() => nameError = null),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: _input(
                          controller: emailController,
                          label: 'Email',
                          hint: 'admin@burgerlab.com',
                          error: emailError,
                          onChanged: (_) => setState(() => emailError = null),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _input(
                          controller: phoneController,
                          label: 'Phone',
                          hint: '+20 100 123 4567',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  _input(
                    controller: addressController,
                    label: 'Branch Address',
                    hint: 'Road 90, New Cairo, Egypt',
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: _input(
                          controller: hoursController,
                          label: 'Opening Hours',
                          hint: '10:00 AM - 02:00 AM',
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _input(
                          controller: currencyController,
                          label: 'Currency',
                          hint: 'EGP',
                        ),
                      ),
                      SizedBox(width: 12.w),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      btnOk: Container(
        height: 44.h,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF5A1F), Color(0xFFFF8C42)],
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: ElevatedButton(
          onPressed: () {
            final name = nameController.text.trim();
            final email = emailController.text.trim();

            if (name.isEmpty) {
              dialogSetState?.call(() => nameError = 'Name is required');
              return;
            }
            if (email.isEmpty) {
              dialogSetState?.call(() => emailError = 'Email is required');
              return;
            }

            final updated = settings.copyWith(
              restaurantName: name,
              email: email,
              phone: phoneController.text.trim(),
              address: addressController.text.trim(),
              openingHours: hoursController.text.trim(),
              currency: currencyController.text.trim().toUpperCase(),
            );

            context.read<SettingsBloc>().add(UpdateSettings(settings: updated));
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
            'Save Changes',
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

  static Widget _input({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? error,
    TextInputType keyboardType = TextInputType.text,
    ValueChanged<String>? onChanged,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      style: TextStyle(fontSize: 13.sp, color: const Color(0xFF211E1C)),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        errorText: error,
        labelStyle: TextStyle(fontSize: 12.sp, color: const Color(0xFF6F6964)),
        hintStyle: TextStyle(fontSize: 12.sp, color: const Color(0xFFAAAAAA)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: Color(0xFFE8E4DF)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: Color(0xFFE8E4DF)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: Color(0xFFFF5A1F), width: 1.5),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      ),
    );
  }
}
