import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenuPhotoPicker extends StatefulWidget {
  final String selectedIcon;
  final ValueChanged<String> onIconChanged;

  const MenuPhotoPicker({
    super.key,
    required this.selectedIcon,
    required this.onIconChanged,
  });

  @override
  State<MenuPhotoPicker> createState() => _MenuPhotoPickerState();
}

class _MenuPhotoPickerState extends State<MenuPhotoPicker> {
  late String selectedIcon;

  @override
  void initState() {
    super.initState();
    selectedIcon = widget.selectedIcon;
  }

  @override
  void didUpdateWidget(MenuPhotoPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIcon != widget.selectedIcon) {
      setState(() {
        selectedIcon = widget.selectedIcon;
      });
    }
  }

  final List<String> foodIcons = [
    '🍔',
    '🍟',
    '🍗',
    '🍕',
    '🌭',
    '🥪',
    '🌮',
    '🌯',
    '🍗',
    '🍤',
    '🥗',
    '🥓',
    '🍳',
    '🥩',
    '🍖',
    '🍿',
    '🧀',
    '🥖',
    '🥨',
    '🍩',
    '🍪',
    '🍰',
    '🧁',
    '🍦',
    '🍨',
    '🍋',
    '🍊',
    '🍓',
    '🍉',
    '🥤',
    '🧋',
    '☕',
  ];

  void _showIconPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(18.r),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20.w,
            14.h,
            20.w,
            24.h,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 35.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9D5D0),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),

                SizedBox(height: 18.h),

                Text(
                  'Choose an icon',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF211E1C),
                  ),
                ),

                SizedBox(height: 5.h),

                Text(
                  'Select an icon for this menu item',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: const Color(0xFF8A8580),
                  ),
                ),

                SizedBox(height: 18.h),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: foodIcons.length,
                  gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    crossAxisSpacing: 10.w,
                    mainAxisSpacing: 10.h,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final icon = foodIcons[index];
                    final isSelected = icon == selectedIcon;

                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedIcon = icon;
                        });

                        widget.onIconChanged(icon);
                        Navigator.pop(context);
                      },
                      borderRadius: BorderRadius.circular(10.r),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFFFF0E8)
                              : const Color(0xFFF7F5F2),
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF8B0000)
                                : Colors.transparent,
                            width: 1.2,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          icon,
                          style: TextStyle(
                            fontSize: 25.sp,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 76.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9.r),
            gradient: const LinearGradient(
              colors: [
                Color(0xFFFFA16A),
                Color(0xFFFF5A1F),
              ],
            ),
          ),
          child: Center(
            child: Text(
              selectedIcon,
              style: TextStyle(
                fontSize: 32.sp,
              ),
            ),
          ),
        ),

        SizedBox(height: 4.h),

        InkWell(
          onTap: _showIconPicker,
          borderRadius: BorderRadius.circular(4.r),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 2.h,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.photo_camera_outlined,
                  size: 12.sp,
                  color: const Color(0xFF77716B),
                ),
                SizedBox(width: 3.w),
                Text(
                  'Change photo',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: const Color(0xFF77716B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}