import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenuCategoryDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const MenuCategoryDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  static const List<String> categories = [
    'Burger',
    'Drinks',
    'Sides',
    'Chicken',
    'Pizza',
  ];

  String _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'burger':
        return '🍔';
      case 'drinks':
        return '🥤';
      case 'sides':
        return '🍟';
      case 'chicken':
        return '🍗';
      case 'pizza':
        return '🍕';
      default:
        return '🍽️';
    }
  }

  @override
  Widget build(BuildContext context) {
    final String dropdownValue =
    categories.contains(value) ? value : categories.first;

    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(
        horizontal: 14.w,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color(0xFFE8E4DF),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A1A1A).withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: dropdownValue,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 22.sp,
            color: const Color(0xFF8A8580),
          ),
          iconEnabledColor: const Color(0xFF8A8580),
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF211E1C),
            letterSpacing: 0.2,
          ),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          menuMaxHeight: 300.h,
          items: categories.map((category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Row(
                children: [
                  Text(
                    _getCategoryIcon(category),
                    style: TextStyle(fontSize: 22.sp),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      category,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF38332F),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              onChanged(value);
            }
          },
        ),
      ),
    );
  }
}