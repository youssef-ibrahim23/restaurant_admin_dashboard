import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'menu_category_dropdown.dart';
import 'menu_photo_picture.dart';
import 'menu_text_field.dart';

class MenuEditPanel extends StatelessWidget {
  final bool editing;

  final TextEditingController nameController;
  final TextEditingController priceController;

  final String selectedCategory;
  final bool isAvailable;
  final String selectedPhoto;

  final String? nameError;
  final String? priceError;

  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<bool> onAvailabilityChanged;
  final ValueChanged<String> onPhotoChanged;

  final VoidCallback onSave;
  final VoidCallback onCancel;

  const MenuEditPanel({
    super.key,
    required this.editing,
    required this.nameController,
    required this.priceController,
    required this.selectedCategory,
    required this.isAvailable,
    required this.selectedPhoto,
    this.nameError,
    this.priceError,
    required this.onCategoryChanged,
    required this.onAvailabilityChanged,
    required this.onPhotoChanged,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            editing ? 'Edit item' : 'Add item',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF211E1C),
            ),
          ),
          SizedBox(height: 12.h),

          MenuPhotoPicker(
            selectedIcon: selectedPhoto,
            onIconChanged: onPhotoChanged,
          ),

          SizedBox(height: 10.h),

          const MenuFieldLabel(
            text: 'Name',
          ),

          SizedBox(height: 5.h),

          MenuTextField(
            controller: nameController,
            hint: 'Double Smash',
            errorText: nameError,
          ),

          SizedBox(height: 9.h),

          const MenuFieldLabel(
            text: 'Price (EGP)',
          ),

          SizedBox(height: 5.h),

          MenuTextField(
            controller: priceController,
            hint: '145',
            keyboardType: TextInputType.number,
            errorText: priceError,
          ),

          SizedBox(height: 9.h),

          const MenuFieldLabel(
            text: 'Category',
          ),

          SizedBox(height: 5.h),

          MenuCategoryDropdown(
            value: selectedCategory,
            onChanged: onCategoryChanged,
          ),

          SizedBox(height: 9.h),

          const Spacer(),

          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: onSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF5A1F),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(width: 8.w),

              Expanded(
                child: SizedBox(
                  height: 38.h,
                  child: OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF38332F),
                      side: const BorderSide(
                        color: Color(0xFFE3DED8),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}