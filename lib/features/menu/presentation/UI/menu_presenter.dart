import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_admin_dashboard/core/di/service_locator.dart';
import 'package:restaurant_admin_dashboard/core/shared/widgets/loading.dart';
import 'package:restaurant_admin_dashboard/features/menu/data/model/menu_model.dart';
import 'package:restaurant_admin_dashboard/features/menu/presentation/BLoC/menu_bloc.dart';
import 'package:restaurant_admin_dashboard/features/menu/presentation/BLoC/menu_event.dart';
import 'package:restaurant_admin_dashboard/features/menu/presentation/BLoC/menu_form_bloc.dart';
import 'package:restaurant_admin_dashboard/features/menu/presentation/BLoC/menu_form_event.dart';
import 'package:restaurant_admin_dashboard/features/menu/presentation/BLoC/menu_state.dart';
import 'package:restaurant_admin_dashboard/features/menu/presentation/UI/widgets/header.dart';
import 'package:restaurant_admin_dashboard/features/menu/presentation/UI/widgets/menu_edit_panel.dart';
import 'package:restaurant_admin_dashboard/features/menu/presentation/UI/widgets/menu_list.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/data/model/section_model.dart';

import '../BLoC/menu_form_state.dart';

class MenuPresenter extends StatelessWidget {
  final SectionModel sectionModel;
  final bool showScaffold;

  const MenuPresenter({
    super.key,
    required this.sectionModel,
    this.showScaffold = true,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              sl<MenuBloc>()..add(LoadMenuItems(sectionId: sectionModel.id)),
        ),
        BlocProvider(create: (_) => MenuFormBloc()),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<MenuBloc, MenuState>(
            listener: (context, state) {
              if (state is MenuActionSuccess) {
                context.read<MenuFormBloc>().add(const MenuFormReset());
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
          ),
          BlocListener<MenuFormBloc, MenuFormState>(
            listener: (context, state) {
              if (state.submissionError != null) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.submissionError!)));
              }

              final itemToSave = state.itemToSave;
              if (itemToSave != null) {
                if (state.selectedItemIndex == null) {
                  context.read<MenuBloc>().add(
                    AddMenuItem(menuItem: itemToSave),
                  );
                } else {
                  context.read<MenuBloc>().add(
                    EditMenuItem(menuItem: itemToSave),
                  );
                }
                context.read<MenuFormBloc>().add(
                  const MenuFormSubmissionHandled(),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<MenuFormBloc, MenuFormState>(
          builder: (context, formState) {
            return BlocBuilder<MenuBloc, MenuState>(
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
                              LoadMenuItems(sectionId: sectionModel.id),
                            );
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                } else {
                  final menuModel =
                      state.menuModel ?? const MenuModel(items: []);

                  content = Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(25.w),
                        child: Column(
                          children: [
                            MenuHeader(
                              sectionName: sectionModel.name,
                              onClick: () => context.read<MenuFormBloc>().add(
                                const MenuFormReset(),
                              ),
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
                                          formState.selectedItemIndex,
                                      onItemSelected:
                                          ({
                                            required name,
                                            required price,
                                            required category,
                                            required available,
                                            required index,
                                            required photo,
                                          }) {
                                            context.read<MenuFormBloc>().add(
                                              MenuFormItemSelected(
                                                item: menuModel.items[index],
                                                index: index,
                                              ),
                                            );
                                          },
                                      onAvailabilityChanged: (item, available) {
                                        context.read<MenuBloc>().add(
                                          ToggleMenuItemAvailability(
                                            id: item.id!,
                                            sectionId: sectionModel.id,
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
                                      editing:
                                          formState.selectedItemIndex != null,
                                      name: formState.name,
                                      price: formState.price,
                                      selectedCategory:
                                          formState.selectedCategory,
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
                                          MenuFormAvailabilityChanged(
                                            available,
                                          ),
                                        );
                                      },
                                      onPhotoChanged: (photo) {
                                        context.read<MenuFormBloc>().add(
                                          MenuFormPhotoChanged(photo),
                                        );
                                      },
                                      onNameChanged: (name) {
                                        context.read<MenuFormBloc>().add(
                                          MenuFormNameChanged(name),
                                        );
                                      },
                                      onPriceChanged: (price) {
                                        context.read<MenuFormBloc>().add(
                                          MenuFormPriceChanged(price),
                                        );
                                      },
                                      onSave: () =>
                                          context.read<MenuFormBloc>().add(
                                            MenuFormSaveRequested(
                                              sectionId: sectionModel.id,
                                              items: menuModel.items,
                                            ),
                                          ),
                                      onCancel: () => context
                                          .read<MenuFormBloc>()
                                          .add(const MenuFormReset()),
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

                if (showScaffold) {
                  return Scaffold(
                    backgroundColor: const Color(0xFFF7F4EF),
                    body: content,
                  );
                }

                return content;
              },
            );
          },
        ),
      ),
    );
  }
}
