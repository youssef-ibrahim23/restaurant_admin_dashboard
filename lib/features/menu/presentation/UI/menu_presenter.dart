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

class _MenuFormState {
  final int? selectedItemIndex;
  final String selectedCategory;
  final bool isAvailable;
  final String selectedPhoto;
  final String name;
  final String price;
  final String? nameError;
  final String? priceError;

  const _MenuFormState({
    this.selectedItemIndex,
    this.selectedCategory = 'Burger',
    this.isAvailable = true,
    this.selectedPhoto = '🍔',
    this.name = '',
    this.price = '',
    this.nameError,
    this.priceError,
  });

  _MenuFormState copyWith({
    int? selectedItemIndex,
    String? selectedCategory,
    bool? isAvailable,
    String? selectedPhoto,
    String? name,
    String? price,
    String? nameError,
    String? priceError,
    bool clear = false,
  }) {
    return _MenuFormState(
      selectedItemIndex: clear
          ? null
          : selectedItemIndex ?? this.selectedItemIndex,
      selectedCategory: clear
          ? 'Burger'
          : selectedCategory ?? this.selectedCategory,
      isAvailable: clear ? true : isAvailable ?? this.isAvailable,
      selectedPhoto: clear ? '🍔' : selectedPhoto ?? this.selectedPhoto,
      name: clear ? '' : name ?? this.name,
      price: clear ? '' : price ?? this.price,
      nameError: clear ? null : nameError ?? this.nameError,
      priceError: clear ? null : priceError ?? this.priceError,
    );
  }
}

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
  _MenuFormState _formState = const _MenuFormState();

  void _clearForm() {
    setState(() {
      _formState = _formState.copyWith(clear: true);
    });
  }

  void _selectItem(MenuItemModel item, int index) {
    setState(() {
      _formState = _MenuFormState(
        selectedItemIndex: index,
        selectedCategory: item.category,
        isAvailable: item.isAvailable,
        selectedPhoto: item.photo,
        name: item.name,
        price: item.price.toStringAsFixed(2),
      );
    });
  }

  void _saveItem(List<MenuItemModel> items) {
    final nameError = _formState.name.trim().isEmpty
        ? 'Please enter an item name'
        : null;
    final priceParsed = double.tryParse(_formState.price.trim());
    final priceError =
        (priceParsed == null || !priceParsed.isFinite || priceParsed < 0)
        ? 'Please enter a valid price'
        : null;

    if (nameError != null || priceError != null) {
      setState(() {
        _formState = _formState.copyWith(
          nameError: nameError,
          priceError: priceError,
        );
      });
      return;
    }

    final MenuItemModel? existingItem;

    if (_formState.selectedItemIndex == null) {
      existingItem = null;
    } else if (_formState.selectedItemIndex! < items.length) {
      existingItem = items[_formState.selectedItemIndex!];
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('The selected menu item is unavailable.')),
      );
      return;
    }

    final menuItem = MenuItemModel(
      id: existingItem?.id,
      sectionId: widget.sectionModel.id,
      photo: _formState.selectedPhoto,
      name: _formState.name.trim(),
      price: priceParsed!,
      category: _formState.selectedCategory,
      isAvailable: _formState.isAvailable,
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
          sl<MenuBloc>()..add(LoadMenuItems(sectionId: widget.sectionModel.id)),
      child: BlocListener<MenuBloc, MenuState>(
        listener: (context, state) {
          if (state is MenuActionSuccess) {
            _clearForm();
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
                          onClick: () => _clearForm(),
                        ),
                        SizedBox(height: 28.h),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                flex: 3,
                                child: MenuList(
                                  items: menuModel.items,
                                  selectedItemIndex:
                                      _formState.selectedItemIndex,
                                  onItemSelected: ({
                                    required name,
                                    required price,
                                    required category,
                                    required available,
                                    required index,
                                    required photo,
                                  }) {
                                    _selectItem(menuModel.items[index], index);
                                  },
                                  onAvailabilityChanged: (item, available) {
                                    context.read<MenuBloc>().add(
                                      ToggleMenuItemAvailability(
                                        id: item.id!,
                                        sectionId: widget.sectionModel.id,
                                        isAvailable: available,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: 18.w),
                              Expanded(
                                flex: 2,
                                child: MenuEditPanel(
                                  editing: _formState.selectedItemIndex != null,
                                  name: _formState.name,
                                  price: _formState.price,
                                  selectedCategory: _formState.selectedCategory,
                                  isAvailable: _formState.isAvailable,
                                  selectedPhoto: _formState.selectedPhoto,
                                  nameError: _formState.nameError,
                                  priceError: _formState.priceError,
                                  onCategoryChanged: (category) {
                                    setState(() {
                                      _formState = _formState.copyWith(
                                        selectedCategory: category,
                                      );
                                    });
                                  },
                                  onAvailabilityChanged: (available) {
                                    setState(() {
                                      _formState = _formState.copyWith(
                                        isAvailable: available,
                                      );
                                    });
                                  },
                                  onPhotoChanged: (photo) {
                                    setState(() {
                                      _formState = _formState.copyWith(
                                        selectedPhoto: photo,
                                      );
                                    });
                                  },
                                  onNameChanged: (name) {
                                    setState(() {
                                      _formState = _formState.copyWith(
                                        name: name,
                                        nameError: null,
                                      );
                                    });
                                  },
                                  onPriceChanged: (price) {
                                    setState(() {
                                      _formState = _formState.copyWith(
                                        price: price,
                                        priceError: null,
                                      );
                                    });
                                  },
                                  onSave: () => _saveItem(menuModel.items),
                                  onCancel: () => _clearForm(),
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
