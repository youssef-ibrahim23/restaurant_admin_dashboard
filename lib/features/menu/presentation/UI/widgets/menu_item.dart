import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenuItemWidget extends StatelessWidget {
  final int index;
  final String name;
  final String category;
  final String price;
  final String? image;
  final bool isAvailable;
  final bool selected;
  final VoidCallback onTap;
  final ValueChanged<bool> onAvailabilityChanged;

  const MenuItemWidget({
    super.key,
    required this.index,
    required this.name,
    required this.category,
    required this.price,
    required this.image,
    required this.isAvailable,
    required this.selected,
    required this.onTap,
    required this.onAvailabilityChanged,
  });

  Color _getIconBackground() {
    switch (category.toLowerCase()) {
      case 'burger':
        return const Color(0xFFFFB36B);

      case 'sides':
        return const Color(0xFFFFD95C);

      case 'drinks':
        return const Color(0xFF59B87A);

      case 'chicken':
        return const Color(0xFFFFD95C);

      case 'pizza':
        return const Color(0xFFFFA45B);

      default:
        return const Color(0xFFFFB36B);
    }
  }

  String _getIcon() {
    switch (category.toLowerCase()) {
      case 'burger':
        return '🍔';

      case 'sides':
        return '🍟';

      case 'drinks':
        return '🍋';

      case 'chicken':
        return '🍗';

      case 'pizza':
        return '🍕';

      default:
        return '🍔';
    }
  }


  Widget _buildEmojiIcon() {
    return Container(
      width: 48.w,
      height: 48.w,
      decoration: BoxDecoration(
        color: _getIconBackground(),
        borderRadius: BorderRadius.circular(10.r),
      ),
      alignment: Alignment.center,
      child: Text(
        image == null || image!.isEmpty ? _getIcon() : image!,
        style: TextStyle(
          fontSize: 23.sp,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        height: 70.h,
        padding: EdgeInsets.symmetric(
          horizontal: 4.w,
          vertical: 8.h,
        ),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFFFF4EF)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child:  _buildEmojiIcon(),
            ),

            SizedBox(width: 10.w),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF211E1C),
                    ),
                  ),

                  SizedBox(height: 3.h),

                  Text(
                    category,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: const Color(0xFF8A8580),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: 8.w),

            Text(
              'EGP $price',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF38332F),
              ),
            ),

            SizedBox(width: 9.w),

            Transform.scale(
              scale: 0.72,
              child: Switch(
                value: isAvailable,
                onChanged: onAvailabilityChanged,
                activeThumbColor: Colors.white,
                activeTrackColor: const Color(0xFF239B56),
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: const Color(0xFFD0CCC6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}