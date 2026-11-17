import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_admin_dashboard/features/menu/data/model/menu_item_model.dart';
import 'package:restaurant_admin_dashboard/features/menu/data/model/menu_model.dart';
import 'package:restaurant_admin_dashboard/features/menu/presentation/BLoC/menu_bloc.dart';
import 'package:restaurant_admin_dashboard/features/menu/presentation/BLoC/menu_event.dart';
import 'package:restaurant_admin_dashboard/features/menu/presentation/BLoC/menu_form_bloc.dart';
import 'package:restaurant_admin_dashboard/features/menu/presentation/BLoC/menu_form_event.dart';
import 'package:restaurant_admin_dashboard/features/menu/presentation/UI/widgets/header.dart';
import 'package:restaurant_admin_dashboard/features/menu/presentation/UI/widgets/menu_edit_panel.dart';
import 'package:restaurant_admin_dashboard/features/menu/presentation/UI/widgets/menu_list.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/data/model/section_model.dart';

import '../../BLoC/menu_form_state.dart';

class MenuDesktopView extends StatelessWidget {
  final SectionModel section;
  final MenuModel menuModel;

  const MenuDesktopView({
    super.key,
    required this.section,
    required this.menuModel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(25.w),
      child: Column(
        children: [
          MenuHeader(
            sectionName: section.name,
            onClick: () =>
                context.read<MenuFormBloc>().add(const MenuFormReset()),
          ),
          SizedBox(height: 28.h),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 3,
                  child: MenuItemsList(
                    items: menuModel.items,
                    sectionId: section.id,
                  ),
                ),
                SizedBox(width: 18.w),
                Expanded(
                  flex: 2,
                  child: MenuEditFormPanel(
                    sectionId: section.id,
                    items: menuModel.items,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// List of menu items wired to [MenuFormBloc] selection and
/// [MenuBloc] availability toggling.
class MenuItemsList extends StatelessWidget {
  final List<MenuItemModel> items;
  final int sectionId;

  const MenuItemsList({
    super.key,
    required this.items,
    required this.sectionId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<MenuFormBloc, MenuFormState, int?>(
      selector: (formState) => formState.selectedItemIndex,
      builder: (context, selectedItemIndex) {
        return MenuList(
          items: items,
          selectedItemIndex: selectedItemIndex,
          onItemSelected: ({
            required name,
            required price,
            required category,
            required available,
            required index,
            required photo,
          }) {
            context.read<MenuFormBloc>().add(
              MenuFormItemSelected(
                item: items[index],
                index: index,
              ),
            );
          },
          onAvailabilityChanged: (item, available) {
            context.read<MenuBloc>().add(
              ToggleMenuItemAvailability(
                id: item.id!,
                sectionId: sectionId,
                isAvailable: available,
              ),
            );
          },
        );
      },
    );
  }
}

/// The add/edit form panel wired to [MenuFormBloc].
class MenuEditFormPanel extends StatelessWidget {
  final int sectionId;
  final List<MenuItemModel> items;

  const MenuEditFormPanel({
    super.key,
    required this.sectionId,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuFormBloc, MenuFormState>(
      builder: (context, formState) {
        return MenuEditPanel(
          editing: formState.selectedItemIndex != null,
          name: formState.name,
          price: formState.price,
          selectedCategory: formState.selectedCategory,
          isAvailable: formState.isAvailable,
          selectedPhoto: formState.selectedPhoto,
          nameError: formState.nameError,
          priceError: formState.priceError,
          onCategoryChanged: (category) {
            context.read<MenuFormBloc>().add(
              MenuFormCategoryChanged(category),
            );
          },
          onAvailabilityChanged: (available) {
            context.read<MenuFormBloc>().add(
              MenuFormAvailabilityChanged(available),
            );
          },
          onPhotoChanged: (photo) {
            context.read<MenuFormBloc>().add(MenuFormPhotoChanged(photo));
          },
          onNameChanged: (name) {
            context.read<MenuFormBloc>().add(MenuFormNameChanged(name));
          },
          onPriceChanged: (price) {
            context.read<MenuFormBloc>().add(MenuFormPriceChanged(price));
          },
          onSave: () => context.read<MenuFormBloc>().add(
            MenuFormSaveRequested(sectionId: sectionId, items: items),
          ),
          onCancel: () =>
              context.read<MenuFormBloc>().add(const MenuFormReset()),
        );
      },
    );
  }
}
