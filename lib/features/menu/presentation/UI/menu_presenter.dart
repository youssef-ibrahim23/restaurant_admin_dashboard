import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_admin_dashboard/core/di/service_locator.dart';
import 'package:restaurant_admin_dashboard/core/shared/widgets/loading.dart';
import 'package:restaurant_admin_dashboard/features/menu/data/model/menu_item_model.dart';
import 'package:restaurant_admin_dashboard/features/menu/data/model/menu_model.dart';
import 'package:restaurant_admin_dashboard/features/menu/presentation/BLoC/menu_bloc.dart';
import 'package:restaurant_admin_dashboard/features/menu/presentation/BLoC/menu_event.dart';
import 'package:restaurant_admin_dashboard/features/menu/presentation/BLoC/menu_state.dart';
import 'package:restaurant_admin_dashboard/features/menu/presentation/UI/widgets/header.dart';
import 'package:restaurant_admin_dashboard/features/menu/presentation/UI/widgets/menu_edit_panel.dart';
import 'package:restaurant_admin_dashboard/features/menu/presentation/UI/widgets/menu_list.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/data/model/section_model.dart';

class MenuPresenter extends StatefulWidget {
  final SectionModel sectionModel;
  final bool showScaffold;

  const MenuPresenter({
    super.key,
    required this.sectionModel,
    this.showScaffold = true,
  });

  @override
  State<MenuPresenter> createState() => _MenuPresenterState();
}

class _MenuPresenterState extends State<MenuPresenter> {
  void _clearForm(BuildContext context) {
    context.read<MenuBloc>().add(ClearEditor());
  }

  void _selectItem({
    required BuildContext context,
    required MenuItemModel item,
    required int index,
  }) {
    context.read<MenuBloc>().add(SelectEditorItem(
      index: index,
      category: item.category,
      isAvailable: item.isAvailable,
      photo: item.photo,
      name: item.name,
      price: item.price.toString(),
    ));
  }

  void _saveItem(
    BuildContext context,
    List<MenuItemModel> items,
    MenuState state,
  ) {
    context.read<MenuBloc>().add(ValidateEditorForm());
    
    // We need to check the state after validation, but BlocListener will handle errors
    // For now, we'll validate inline and only proceed if valid
    final nameError = _validateName(state.name);
    final priceError = _validatePrice(state.price);

    if (nameError != null || priceError != null) {
      return;
    }

    final price = double.tryParse(state.price.trim())!;

    final MenuItemModel? existingItem;

    if (state.selectedItemIndex == null) {
      existingItem = null;
    } else if (state.selectedItemIndex! < items.length) {
      existingItem = items[state.selectedItemIndex!];
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('The selected menu item is unavailable.')),
      );
      return;
    }

    final menuItem = MenuItemModel(
      id: existingItem?.id,
      sectionId: widget.sectionModel.id,
      photo: state.selectedPhoto,
      name: state.name.trim(),
      price: price,
      category: state.selectedCategory,
      isAvailable: state.isAvailable,
    );

    final menuBloc = context.read<MenuBloc>();
    if (existingItem == null) {
      menuBloc.add(AddMenuItem(menuItem: menuItem));
    } else {
      menuBloc.add(EditMenuItem(menuItem: menuItem));
    }
  }

  String? _validateName(String name) {
    if (name.trim().isEmpty) {
      return 'Please enter an item name';
    }
    return null;
  }

  String? _validatePrice(String price) {
    final parsedPrice = double.tryParse(price.trim());
    if (parsedPrice == null || !parsedPrice.isFinite || parsedPrice < 0) {
      return 'Please enter a valid price';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<MenuBloc>()
            ..add(LoadMenuItems(sectionId: widget.sectionModel.id)),
      child: BlocListener<MenuBloc, MenuState>(
        listener: (context, state) {
          if (state is MenuActionSuccess) {
            if (state.shouldClearForm) {
              _clearForm(context);
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: const Color(0xFF239B56),
                duration: const Duration(seconds: 2),
              ),
            );
          } else if (state is MenuError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: const Color(0xFFD64545),
              ),
            );
          }
        },
        child: BlocBuilder<MenuBloc, MenuState>(
          builder: (context, state) {
            Widget content;

            if (state is MenuError && state.menuModel == null) {
              content = Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Unable to load menu items.',
                      style: TextStyle(
                        color: const Color(0xFF211E1C),
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    ElevatedButton(
                      onPressed: () {
                        context.read<MenuBloc>().add(
                          LoadMenuItems(sectionId: widget.sectionModel.id),
                        );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else {
              final menuModel = state.menuModel ?? const MenuModel(items: []);

              content = Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.all(25.w),
                    child: Column(
                      children: [
                        MenuHeader(
                          sectionName: widget.sectionModel.name,
                          onClick: () => _clearForm(context),
                        ),
                        SizedBox(height: 28.h),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                flex: 3,
                                child:
                                    BlocSelector<
                                      MenuBloc,
                                      MenuState,
                                      int?
                                    >(
                                      selector: (state) =>
                                          state.selectedItemIndex,
                                      builder: (context, selectedItemIndex) {
                                        return MenuList(
                                          items: menuModel.items,
                                          selectedItemIndex: selectedItemIndex,
                                          onItemSelected:
                                              ({
                                                required name,
                                                required price,
                                                required category,
                                                required available,
                                                required index,
                                                required photo,
                                              }) {
                                                _selectItem(
                                                  context: context,
                                                  item: menuModel.items[index],
                                                  index: index,
                                                );
                                              },
                                          onAvailabilityChanged:
                                              (item, available) {
                                                context.read<MenuBloc>().add(
                                                  ToggleMenuItemAvailability(
                                                    id: item.id!,
                                                    sectionId:
                                                        widget.sectionModel.id,
                                                    isAvailable: available,
                                                  ),
                                                );
                                              },
                                        );
                                      },
                                    ),
                              ),
                              SizedBox(width: 18.w),
                              Expanded(
                                flex: 2,
                                child:
                                    BlocSelector<
                                      MenuBloc,
                                      MenuState,
                                      MenuState
                                    >(
                                      selector: (state) => state,
                                      builder: (context, state) {
                                        return MenuEditPanel(
                                          editing:
                                              state.selectedItemIndex !=
                                              null,
                                          name: state.name,
                                          price: state.price,
                                          selectedCategory:
                                              state.selectedCategory,
                                          isAvailable: state.isAvailable,
                                          selectedPhoto:
                                              state.selectedPhoto,
                                          nameError: state.nameError,
                                          priceError: state.priceError,
                                          onCategoryChanged: (category) =>
                                              context.read<MenuBloc>().add(
                                                SelectEditorCategory(
                                                  category: category,
                                                ),
                                              ),
                                          onAvailabilityChanged: (available) =>
                                              context.read<MenuBloc>().add(
                                                SetEditorAvailability(
                                                  isAvailable: available,
                                                ),
                                              ),
                                          onPhotoChanged: (photo) =>
                                              context.read<MenuBloc>().add(
                                                SelectEditorPhoto(photo: photo),
                                              ),
                                          onNameChanged: (name) =>
                                              context.read<MenuBloc>().add(
                                                UpdateEditorName(name: name),
                                              ),
                                          onPriceChanged: (price) =>
                                              context.read<MenuBloc>().add(
                                                UpdateEditorPrice(price: price),
                                              ),
                                          onSave: () => _saveItem(
                                            context,
                                            menuModel.items,
                                            state,
                                          ),
                                          onCancel: () => _clearForm(context),
                                        );
                                      },
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (state is MenuLoading) Loading(),
                ],
              );
            }

            if (widget.showScaffold) {
              return Scaffold(
                backgroundColor: const Color(0xFFF7F4EF),
                body: content,
              );
            }

            return content;
          },
        ),
      ),
    );
  }
}
