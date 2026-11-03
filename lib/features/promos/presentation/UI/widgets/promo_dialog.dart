import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:restaurant_admin_dashboard/features/promos/data/model/promos_model.dart';
import 'package:restaurant_admin_dashboard/features/promos/presentation/BLoC/promos_bloc.dart';
import 'package:restaurant_admin_dashboard/features/promos/presentation/BLoC/promos_event.dart';

class PromoDialog {
  static void showAddDialog(BuildContext context) {
    final codeController = TextEditingController();
    final discountController = TextEditingController();
    bool isActive = true;
    String? codeError;
    String? discountError;
    StateSetter? dialogSetState;

    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.scale,
      title: 'Add New Promo',
      desc: 'Create a new promo code for discounts',
      width: 500.w,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      body: StatefulBuilder(
        builder: (context, setState) {
          dialogSetState = setState;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: codeController,
                  textCapitalization: TextCapitalization.characters,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9_-]')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      codeError = null;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Promo Code',
                    hintText: 'e.g., SUMMER50, SAVE20',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(color: Color(0xFFE8E4DF)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(color: Color(0xFFE8E4DF)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(color: Color(0xFFFF5A1F), width: 2),
                    ),
                    errorText: codeError,
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(height: 16.h),
                TextField(
                  controller: discountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      discountError = null;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Discount Percentage (%)',
                    hintText: 'e.g., 15, 20, 50',
                    suffixText: '%',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(color: Color(0xFFE8E4DF)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(color: Color(0xFFE8E4DF)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(color: Color(0xFFFF5A1F), width: 2),
                    ),
                    errorText: discountError,
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Text(
                      'Status:',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF211E1C),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Switch(
                      value: isActive,
                      onChanged: (value) {
                        setState(() {
                          isActive = value;
                        });
                      },
                      activeColor: const Color(0xFFFF5A1F),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      isActive ? 'Active' : 'Inactive',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: isActive
                            ? const Color(0xFF239B56)
                            : const Color(0xFF777777),
                      ),
                    ),
                  ],
                ),
              ],
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
            final code = codeController.text.trim().toUpperCase();
            final discountText = discountController.text.trim();
            final discount = double.tryParse(discountText);

            bool hasError = false;

            if (code.isEmpty) {
              dialogSetState?.call(() {
                codeError = 'Promo code is required';
              });
              hasError = true;
            } else if (code.length < 2) {
              dialogSetState?.call(() {
                codeError = 'Code must be at least 2 characters';
              });
              hasError = true;
            }

            if (discountText.isEmpty || discount == null || discount <= 0) {
              dialogSetState?.call(() {
                discountError = 'Enter a valid discount greater than 0';
              });
              hasError = true;
            } else if (discount > 100) {
              dialogSetState?.call(() {
                discountError = 'Discount cannot exceed 100%';
              });
              hasError = true;
            }

            if (hasError) return;

            context.read<PromosBloc>().add(
                  AddPromo(
                    promoModel: PromoModel(
                      id: '',
                      code: code,
                      discount: discount!,
                      status: isActive ? 'Active' : 'Inactive',
                      createdAt: DateTime.now(),
                    ),
                  ),
                );
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
            'Add Promo',
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

  static void showEditDialog(BuildContext context, PromoModel promo) {
    final codeController = TextEditingController(text: promo.code);
    final discountController =
        TextEditingController(text: promo.discount.toStringAsFixed(0));
    bool isActive = promo.isActive;
    String? codeError;
    String? discountError;
    StateSetter? dialogSetState;

    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.scale,
      title: 'Edit Promo',
      desc: 'Update promo details',
      width: 500.w,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      body: StatefulBuilder(
        builder: (context, setState) {
          dialogSetState = setState;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: codeController,
                  textCapitalization: TextCapitalization.characters,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9_-]')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      codeError = null;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Promo Code',
                    hintText: 'e.g., SUMMER50, SAVE20',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(color: Color(0xFFE8E4DF)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(color: Color(0xFFE8E4DF)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(color: Color(0xFFFF5A1F), width: 2),
                    ),
                    errorText: codeError,
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(height: 16.h),
                TextField(
                  controller: discountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      discountError = null;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Discount Percentage (%)',
                    hintText: 'e.g., 15, 20, 50',
                    suffixText: '%',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(color: Color(0xFFE8E4DF)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(color: Color(0xFFE8E4DF)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(color: Color(0xFFFF5A1F), width: 2),
                    ),
                    errorText: discountError,
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Text(
                      'Status:',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF211E1C),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Switch(
                      value: isActive,
                      onChanged: (value) {
                        setState(() {
                          isActive = value;
                        });
                      },
                      activeColor: const Color(0xFFFF5A1F),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      isActive ? 'Active' : 'Inactive',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: isActive
                            ? const Color(0xFF239B56)
                            : const Color(0xFF777777),
                      ),
                    ),
                  ],
                ),
              ],
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
            final code = codeController.text.trim().toUpperCase();
            final discountText = discountController.text.trim();
            final discount = double.tryParse(discountText);

            bool hasError = false;

            if (code.isEmpty) {
              dialogSetState?.call(() {
                codeError = 'Promo code is required';
              });
              hasError = true;
            } else if (code.length < 2) {
              dialogSetState?.call(() {
                codeError = 'Code must be at least 2 characters';
              });
              hasError = true;
            }

            if (discountText.isEmpty || discount == null || discount <= 0) {
              dialogSetState?.call(() {
                discountError = 'Enter a valid discount greater than 0';
              });
              hasError = true;
            } else if (discount > 100) {
              dialogSetState?.call(() {
                discountError = 'Discount cannot exceed 100%';
              });
              hasError = true;
            }

            if (hasError) return;

            context.read<PromosBloc>().add(
                  EditPromo(
                    promoModel: promo.copyWith(
                      code: code,
                      discount: discount!,
                      status: isActive ? 'Active' : 'Inactive',
                    ),
                  ),
                );
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
}
