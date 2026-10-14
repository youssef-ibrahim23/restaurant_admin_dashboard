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
      price: item.price.toStringAsFixed(2),
    ));
  }

  void _saveItem(
    BuildContext context,
    List<MenuItemModel> items,
    ({
      int? selectedItemIndex,
      String selectedCategory,
      bool isAvailable,
      String selectedPhoto,
      String name,
      String price,
      String? nameError,
      String? priceError,
    }) editor,
  ) {
    final nameError = editor.name.trim().isEmpty ? 'Please enter an item name' : null;
    final priceParsed = double.tryParse(editor.price.trim());
    final priceError = (priceParsed == null || !priceParsed.isFinite || priceParsed < 0)
        ? 'Please enter a valid price'
        : null;

    if (nameError != null || priceError != null) {
      context.read<MenuBloc>().add(ValidateEditorForm());
      return;
    }

    final MenuItemModel? existingItem;

    if (editor.selectedItemIndex == null) {
      existingItem = null;
    } else if (editor.selectedItemIndex! < items.length) {
      existingItem = items[editor.selectedItemIndex!];
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('The selected menu item is unavailable.')),
      );
      return;
    }

    final menuItem = MenuItemModel(
      id: existingItem?.id,
      sectionId: widget.sectionModel.id,
      photo: editor.selectedPhoto,
      name: editor.name.trim(),
      price: priceParsed!,
      category: editor.selectedCategory,
      isAvailable: editor.isAvailable,
    );

    final menuBloc = context.read<MenuBloc>();
    if (existingItem == null) {
      menuBloc.add(AddMenuItem(menuItem: menuItem));
    } else {
      menuBloc.add(EditMenuItem(menuItem: menuItem));
    }
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
            _clearForm(context);
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
          buildWhen: (previous, current) {
            return previous.menuModel != current.menuModel ||
                previous is MenuLoading != current is MenuLoading ||
                (previous is MenuError && previous.menuModel == null) !=
                    (current is MenuError && current.menuModel == null);
          },
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
                                      ({
                                        int? selectedItemIndex,
                                        String selectedCategory,
                                        bool isAvailable,
                                        String selectedPhoto,
                                        String name,
                                        String price,
                                        String? nameError,
                                        String? priceError,
                                      })
                                    >(
                                      selector: (state) => (
                                        selectedItemIndex: state.selectedItemIndex,
                                        selectedCategory: state.selectedCategory,
                                        isAvailable: state.isAvailable,
                                        selectedPhoto: state.selectedPhoto,
                                        name: state.name,
                                        price: state.price,
                                        nameError: state.nameError,
                                        priceError: state.priceError,
                                      ),
                                      builder: (context, editor) {
                                        return MenuEditPanel(
                                          editing:
                                              editor.selectedItemIndex !=
                                              null,
                                          name: editor.name,
                                          price: editor.price,
                                          selectedCategory:
                                              editor.selectedCategory,
                                          isAvailable: editor.isAvailable,
                                          selectedPhoto:
                                              editor.selectedPhoto,
                                          nameError: editor.nameError,
                                          priceError: editor.priceError,
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
                                            editor,
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
