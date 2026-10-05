import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_admin_dashboard/core/di/service_locator.dart';
import 'package:restaurant_admin_dashboard/core/shared/widgets/loading.dart';
import 'package:restaurant_admin_dashboard/features/menu/data/model/menu_item_model.dart';
import 'package:restaurant_admin_dashboard/features/menu/data/model/menu_model.dart';
import 'package:restaurant_admin_dashboard/features/menu/presentation/BLoC/menu_bloc.dart';
import 'package:restaurant_admin_dashboard/features/menu/presentation/BLoC/menu_editor_cubit.dart';
import 'package:restaurant_admin_dashboard/features/menu/presentation/BLoC/menu_editor_state.dart';
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
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  String? _nameError;
  String? _priceError;

  @override
  void initState() {
    super.initState();
    nameController.addListener(_onNameChanged);
    priceController.addListener(_onPriceChanged);
  }

  void _onNameChanged() {
    if (_nameError != null && nameController.text.trim().isNotEmpty) {
      setState(() {
        _nameError = null;
      });
    }
  }

  void _onPriceChanged() {
    if (_priceError != null && priceController.text.trim().isNotEmpty) {
      setState(() {
        _priceError = null;
      });
    }
  }

  @override
  void dispose() {
    nameController.removeListener(_onNameChanged);
    priceController.removeListener(_onPriceChanged);
    nameController.dispose();
    priceController.dispose();
    super.dispose();
  }

  void _clearForm(BuildContext context) {
    nameController.clear();
    priceController.clear();
    context.read<MenuEditorCubit>().clear();
    setState(() {
      _nameError = null;
      _priceError = null;
    });
  }

  void _selectItem({
    required BuildContext context,
    required MenuItemModel item,
    required int index,
  }) {
    nameController.text = item.name;
    priceController.text = item.price.toString();
    context.read<MenuEditorCubit>().selectItem(
      index: index,
      category: item.category,
      isAvailable: item.isAvailable,
      photo: item.photo,
    );
  }

  void _saveItem(
    BuildContext context,
    List<MenuItemModel> items,
    MenuEditorState editorState,
  ) {
    final name = nameController.text.trim();
    final price = double.tryParse(priceController.text.trim());

    // TODO: Consolidate form editing state (split between StatefulWidget controllers and MenuEditorCubit) and move validation logic out of UI into domain/Cubit.
    // Clear previous errors
    setState(() {
      _nameError = null;
      _priceError = null;
    });

    // Validate name
    if (name.isEmpty) {
      setState(() {
        _nameError = 'Please enter an item name';
      });
      return;
    }

    // Validate price
    if (price == null || !price.isFinite || price < 0) {
      setState(() {
        _priceError = 'Please enter a valid price';
      });
      return;
    }

    final MenuItemModel? existingItem;

    if (editorState.selectedItemIndex == null) {
      existingItem = null;
    } else if (editorState.selectedItemIndex! < items.length) {
      existingItem = items[editorState.selectedItemIndex!];
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('The selected menu item is unavailable.')),
      );
      return;
    }

    final menuItem = MenuItemModel(
      id: existingItem?.id,
      sectionId: widget.sectionModel.id,
      photo: editorState.selectedPhoto,
      name: name,
      price: price,
      category: editorState.selectedCategory,
      isAvailable: editorState.isAvailable,
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              sl<MenuBloc>()
                ..add(LoadMenuItems(sectionId: widget.sectionModel.id)),
        ),
        BlocProvider(create: (_) => sl<MenuEditorCubit>()),
      ],
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

            if (state is MenuError) {
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
              // TODO: Simplify 'switch (state)' menuModel extraction once MenuState handles data state consistently without duplicating menuModel across state types.
              final menuModel = switch (state) {
                MenuLoaded() => state.menuModel,
                MenuActionSuccess() => state.menuModel,
                MenuLoading(:final menuModel) =>
                  menuModel ?? const MenuModel(items: []),
                _ => const MenuModel(items: []),
              };

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
                                      MenuEditorCubit,
                                      MenuEditorState,
                                      int?
                                    >(
                                      selector: (editorState) =>
                                          editorState.selectedItemIndex,
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
                                      MenuEditorCubit,
                                      MenuEditorState,
                                      MenuEditorState
                                    >(
                                      selector: (editorState) => editorState,
                                      builder: (context, editorState) {
                                        return MenuEditPanel(
                                          editing:
                                              editorState.selectedItemIndex !=
                                              null,
                                          nameController: nameController,
                                          priceController: priceController,
                                          selectedCategory:
                                              editorState.selectedCategory,
                                          isAvailable: editorState.isAvailable,
                                          selectedPhoto:
                                              editorState.selectedPhoto,
                                          nameError: _nameError,
                                          priceError: _priceError,
                                          onCategoryChanged: context
                                              .read<MenuEditorCubit>()
                                              .selectCategory,
                                          onAvailabilityChanged: context
                                              .read<MenuEditorCubit>()
                                              .setAvailability,
                                          onPhotoChanged: context
                                              .read<MenuEditorCubit>()
                                              .selectPhoto,
                                          onSave: () => _saveItem(
                                            context,
                                            menuModel.items,
                                            editorState,
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
