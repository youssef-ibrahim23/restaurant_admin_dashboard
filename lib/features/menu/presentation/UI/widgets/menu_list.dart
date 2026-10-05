import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_admin_dashboard/features/menu/data/model/menu_item_model.dart';

import 'menu_item.dart';

class MenuList extends StatelessWidget {
  final List<MenuItemModel> items;
  final int? selectedItemIndex;

  final void Function({
    required String name,
    required String price,
    required String category,
    required bool available,
    required int index,
    required String photo,
  })
  onItemSelected;
  final void Function(MenuItemModel item, bool isAvailable)
  onAvailabilityChanged;

  const MenuList({
    super.key,
    required this.items,
    required this.selectedItemIndex,
    required this.onItemSelected,
    required this.onAvailabilityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13.r),
      ),
      child: items.isEmpty
          ? Center(
              child: Text(
                'No menu items yet',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF8A8580),
                ),
              ),
            )
          : ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              itemCount: items.length,
              separatorBuilder: (_, _) {
                return const Divider(height: 1, color: Color(0xFFE9E6E2));
              },
              itemBuilder: (context, index) {
                final item = items[index];

                return MenuItemWidget(
                  index: index,
                  name: item.name,
                  category: item.category,
                  price: item.price.toString(),
                  image: item.photo,
                  isAvailable: item.isAvailable,
                  selected: selectedItemIndex == index,
                  onTap: () {
                    onItemSelected(
                      name: item.name,
                      price: item.price.toString(),
                      category: item.category,
                      available: item.isAvailable,
                      index: index,
                      photo: item.photo,
                    );
                  },
                  onAvailabilityChanged: (isAvailable) {
                    onAvailabilityChanged(item, isAvailable);
                  },
                );
              },
            ),
    );
  }
}
