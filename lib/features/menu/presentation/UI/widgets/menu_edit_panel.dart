import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'menu_category_dropdown.dart';
import 'menu_photo_picture.dart';
import 'menu_text_field.dart';

class MenuEditPanel extends StatefulWidget {
  final bool editing;

  final String name;
  final String price;

  final String selectedCategory;
  final bool isAvailable;
  final String selectedPhoto;

  final String? nameError;
  final String? priceError;

  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<bool> onAvailabilityChanged;
  final ValueChanged<String> onPhotoChanged;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onPriceChanged;

  final VoidCallback onSave;
  final VoidCallback onCancel;

  const MenuEditPanel({
    super.key,
    required this.editing,
    required this.name,
    required this.price,
    required this.selectedCategory,
    required this.isAvailable,
    required this.selectedPhoto,
    this.nameError,
    this.priceError,
    required this.onCategoryChanged,
    required this.onAvailabilityChanged,
    required this.onPhotoChanged,
    required this.onNameChanged,
    required this.onPriceChanged,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<MenuEditPanel> createState() => _MenuEditPanelState();
}

class _MenuEditPanelState extends State<MenuEditPanel> {
  late TextEditingController nameController;
  late TextEditingController priceController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    priceController = TextEditingController(text: widget.price);
  }

  @override
  void didUpdateWidget(MenuEditPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.name != nameController.text) {
      nameController.value = TextEditingValue(
        text: widget.name,
        selection: TextSelection.collapsed(offset: widget.name.length),
      );
    }
    if (widget.price != priceController.text) {
      priceController.value = TextEditingValue(
        text: widget.price,
        selection: TextSelection.collapsed(offset: widget.price.length),
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    super.dispose();
  }

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
            widget.editing ? 'Edit item' : 'Add item',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF211E1C),
            ),
          ),
          SizedBox(height: 12.h),

          MenuPhotoPicker(
            selectedIcon: widget.selectedPhoto,
            onIconChanged: widget.onPhotoChanged,
          ),

          SizedBox(height: 10.h),

          const MenuFieldLabel(
            text: 'Name',
          ),

          SizedBox(height: 5.h),

          MenuTextField(
            controller: nameController,
            hint: 'Double Smash',
            errorText: widget.nameError,
            onChanged: widget.onNameChanged,
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
            errorText: widget.priceError,
            onChanged: widget.onPriceChanged,
          ),

          SizedBox(height: 9.h),

          const MenuFieldLabel(
            text: 'Category',
          ),

          SizedBox(height: 5.h),

          MenuCategoryDropdown(
            value: widget.selectedCategory,
            onChanged: widget.onCategoryChanged,
          ),

          SizedBox(height: 9.h),

          const Spacer(),

          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: widget.onSave,
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
                    onPressed: widget.onCancel,
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