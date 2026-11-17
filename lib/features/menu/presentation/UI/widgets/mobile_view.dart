import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_admin_dashboard/features/menu/data/model/menu_item_model.dart';
import 'package:restaurant_admin_dashboard/features/menu/data/model/menu_model.dart';
import 'package:restaurant_admin_dashboard/features/menu/presentation/BLoC/menu_bloc.dart';
import 'package:restaurant_admin_dashboard/features/menu/presentation/BLoC/menu_event.dart';
import 'package:restaurant_admin_dashboard/features/menu/presentation/BLoC/menu_form_bloc.dart';
import 'package:restaurant_admin_dashboard/features/menu/presentation/BLoC/menu_form_event.dart';
import 'package:restaurant_admin_dashboard/features/menu/presentation/BLoC/menu_form_state.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/data/model/section_model.dart';

class MenuMobileView extends StatelessWidget {
  final SectionModel section;
  final MenuModel menuModel;

  const MenuMobileView({
    super.key,
    required this.section,
    required this.menuModel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          _MobileMenuHeader(
            sectionName: section.name,
            onClick: () =>
                context.read<MenuFormBloc>().add(const MenuFormAddNew()),
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: BlocSelector<MenuFormBloc, MenuFormState, bool>(
              selector: (formState) =>
                  formState.isCreating || formState.selectedItemIndex != null,
              builder: (context, showForm) {
                if (!showForm) {
                  return _MobileMenuItemsList(
                    items: menuModel.items,
                    sectionId: section.id,
                  );
                }

                return Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () => context.read<MenuFormBloc>().add(
                          const MenuFormReset(),
                        ),
                        icon: Icon(Icons.arrow_back, size: 36.sp),
                        label: Text(
                          'Back to items',
                          style: TextStyle(fontSize: 26.sp),
                        ),
                      ),
                    ),
                    Expanded(
                      child: _MobileMenuEditFormPanel(
                        sectionId: section.id,
                        items: menuModel.items,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileMenuHeader extends StatelessWidget {
  final String sectionName;
  final VoidCallback onClick;

  const _MobileMenuHeader({
    required this.sectionName,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          sectionName,
          style: TextStyle(
            fontSize: 52.sp,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF211E1C),
          ),
        ),
        SizedBox(height: 14.h),
        Row(
          children: [
            Icon(
              Icons.star_rounded,
              color: const Color(0xFFF4C542),
              size: 34.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              '4.7',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF77716B),
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              '•',
              style: TextStyle(
                fontSize: 24.sp,
                color: const Color(0xFFAAA49E),
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              '42 menu items',
              style: TextStyle(
                fontSize: 24.sp,
                color: const Color(0xFF8A8580),
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              '•',
              style: TextStyle(
                fontSize: 24.sp,
                color: const Color(0xFFAAA49E),
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              'Open now',
              style: TextStyle(
                fontSize: 24.sp,
                color: const Color(0xFF8A8580),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        SizedBox(
          width: double.infinity,
          height: 84.h,
          child: ElevatedButton.icon(
            onPressed: onClick,
            icon: Icon(
              Icons.add_circle_outline,
              size: 36.sp,
            ),
            label: Text(
              'Add Item',
              style: TextStyle(
                fontSize: 26.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF5A1F),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: EdgeInsets.symmetric(
                horizontal: 34.w,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.r),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MobileMenuItemsList extends StatelessWidget {
  final List<MenuItemModel> items;
  final int sectionId;

  const _MobileMenuItemsList({
    required this.items,
    required this.sectionId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<MenuFormBloc, MenuFormState, int?>(
      selector: (formState) => formState.selectedItemIndex,
      builder: (context, selectedItemIndex) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(26.r),
          ),
          child: items.isEmpty
              ? Center(
                  child: Text(
                    'No menu items yet',
                    style: TextStyle(
                      fontSize: 28.sp,
                      color: const Color(0xFF8A8580),
                    ),
                  ),
                )
              : ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                  itemCount: items.length,
                  separatorBuilder: (_, _) {
                    return const Divider(height: 1, color: Color(0xFFE9E6E2));
                  },
                  itemBuilder: (context, index) {
                    final item = items[index];

                    return _MobileMenuItemWidget(
                      index: index,
                      name: item.name,
                      category: item.category,
                      price: item.price.toString(),
                      image: item.photo,
                      isAvailable: item.isAvailable,
                      selected: selectedItemIndex == index,
                      onTap: () {
                        context.read<MenuFormBloc>().add(
                          MenuFormItemSelected(
                            item: items[index],
                            index: index,
                          ),
                        );
                      },
                      onAvailabilityChanged: (isAvailable) {
                        context.read<MenuBloc>().add(
                          ToggleMenuItemAvailability(
                            id: item.id!,
                            sectionId: sectionId,
                            isAvailable: isAvailable,
                          ),
                        );
                      },
                    );
                  },
                ),
        );
      },
    );
  }
}

class _MobileMenuItemWidget extends StatelessWidget {
  final int index;
  final String name;
  final String category;
  final String price;
  final String? image;
  final bool isAvailable;
  final bool selected;
  final VoidCallback onTap;
  final ValueChanged<bool> onAvailabilityChanged;

  const _MobileMenuItemWidget({
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
      width: 96.w,
      height: 96.w,
      decoration: BoxDecoration(
        color: _getIconBackground(),
        borderRadius: BorderRadius.circular(20.r),
      ),
      alignment: Alignment.center,
      child: Text(
        image == null || image!.isEmpty ? _getIcon() : image!,
        style: TextStyle(
          fontSize: 46.sp,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        height: 140.h,
        padding: EdgeInsets.symmetric(
          horizontal: 8.w,
          vertical: 16.h,
        ),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFFFF4EF)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: _buildEmojiIcon(),
            ),
            SizedBox(width: 20.w),
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
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF211E1C),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    category,
                    style: TextStyle(
                      fontSize: 22.sp,
                      color: const Color(0xFF8A8580),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            Text(
              'EGP $price',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF38332F),
              ),
            ),
            SizedBox(width: 18.w),
            Transform.scale(
              scale: 1.2,
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

class _MobileMenuEditFormPanel extends StatefulWidget {
  final int sectionId;
  final List<MenuItemModel> items;

  const _MobileMenuEditFormPanel({
    required this.sectionId,
    required this.items,
  });

  @override
  State<_MobileMenuEditFormPanel> createState() =>
      _MobileMenuEditFormPanelState();
}

class _MobileMenuEditFormPanelState extends State<_MobileMenuEditFormPanel> {
  late TextEditingController nameController;
  late TextEditingController priceController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    priceController = TextEditingController();
  }

  @override
  void didUpdateWidget(_MobileMenuEditFormPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuFormBloc, MenuFormState>(
      builder: (context, formState) {
        _syncControllers(formState);
        return Container(
          padding: EdgeInsets.all(32.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(26.r),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text(
                formState.selectedItemIndex != null ? 'Edit item' : 'Add item',
                style: TextStyle(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF211E1C),
                ),
              ),
              SizedBox(height: 24.h),
              _MobileMenuPhotoPicker(
                selectedIcon: formState.selectedPhoto,
                onIconChanged: (photo) {
                  context.read<MenuFormBloc>().add(MenuFormPhotoChanged(photo));
                },
              ),
              SizedBox(height: 20.h),
              const _MenuFieldLabel(text: 'Name'),
              SizedBox(height: 10.h),
              _MobileMenuTextField(
                controller: nameController,
                hint: 'Double Smash',
                errorText: formState.nameError,
                onChanged: (name) {
                  context.read<MenuFormBloc>().add(MenuFormNameChanged(name));
                },
              ),
              SizedBox(height: 18.h),
              const _MenuFieldLabel(text: 'Price (EGP)'),
              SizedBox(height: 10.h),
              _MobileMenuTextField(
                controller: priceController,
                hint: '145',
                keyboardType: TextInputType.number,
                errorText: formState.priceError,
                onChanged: (price) {
                  context.read<MenuFormBloc>().add(MenuFormPriceChanged(price));
                },
              ),
              SizedBox(height: 18.h),
              const _MenuFieldLabel(text: 'Category'),
              SizedBox(height: 10.h),
              _MobileMenuCategoryDropdown(
                value: formState.selectedCategory,
                onChanged: (category) {
                  context.read<MenuFormBloc>().add(
                    MenuFormCategoryChanged(category),
                  );
                },
              ),
              SizedBox(height: 18.h),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 96.h,
                      child: ElevatedButton(
                        onPressed: () => context.read<MenuFormBloc>().add(
                          MenuFormSaveRequested(
                            sectionId: widget.sectionId,
                            items: widget.items,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF5A1F),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                        child: Text(
                          'Save',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: SizedBox(
                      height: 96.h,
                      child: OutlinedButton(
                        onPressed: () =>
                            context.read<MenuFormBloc>().add(const MenuFormReset()),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF38332F),
                          side: const BorderSide(
                            color: Color(0xFFE3DED8),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
            ],
          ),
          ),
        );
      },
    );
  }

  void _syncControllers(MenuFormState formState) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (nameController.text != formState.name) {
        nameController.text = formState.name;
      }
      if (priceController.text != formState.price) {
        priceController.text = formState.price;
      }
    });
  }
}

class _MenuFieldLabel extends StatelessWidget {
  final String text;

  const _MenuFieldLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF38332F),
      ),
    );
  }
}

class _MobileMenuPhotoPicker extends StatelessWidget {
  final String selectedIcon;
  final ValueChanged<String> onIconChanged;

  const _MobileMenuPhotoPicker({
    required this.selectedIcon,
    required this.onIconChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160.h,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F1ED),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: GridView.count(
        crossAxisCount: 4,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        children: [
          '🍔', '🍟', '🍋', '🍗', '🍕', '🌭', '🥤', '🍦',
        ].map((emoji) {
          final isSelected = selectedIcon == emoji;
          return InkWell(
            onTap: () => onIconChanged(emoji),
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFFF5A1F) : Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isSelected ? const Color(0xFFFF5A1F) : const Color(0xFFE8E4DF),
                ),
              ),
              child: Center(
                child: Text(
                  emoji,
                  style: TextStyle(fontSize: 40.sp),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _MobileMenuTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  const _MobileMenuTextField({
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(
            fontSize: 28.sp,
            color: const Color(0xFF38332F),
          ),
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 28.sp,
              color: const Color(0xFF9D9791),
            ),
            filled: true,
            fillColor: const Color(0xFFF4F1ED),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 24.w,
              vertical: 20.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(
                color: Color(0xFFFF5A1F),
                width: 1,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(
                color: Color(0xFFD64545),
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(
                color: Color(0xFFD64545),
                width: 1,
              ),
            ),
            errorText: errorText,
            errorStyle: TextStyle(
              fontSize: 24.sp,
              color: const Color(0xFFD64545),
            ),
          ),
        ),
      ],
    );
  }
}

class _MobileMenuCategoryDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const _MobileMenuCategoryDropdown({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final categories = ['Burger', 'Sides', 'Drinks', 'Chicken', 'Pizza'];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F1ED),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value.isEmpty ? categories.first : value,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down, size: 32.sp),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          style: TextStyle(
            fontSize: 24.sp,
            color: const Color(0xFF38332F),
          ),
          items: categories.map((category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Text(category),
            );
          }).toList(),
          onChanged: (newValue) {
            if (newValue != null) {
              onChanged(newValue);
            }
          },
        ),
      ),
    );
  }
}
