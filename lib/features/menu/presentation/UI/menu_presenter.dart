import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_admin_dashboard/core/di/service_locator.dart';
import 'package:restaurant_admin_dashboard/core/shared/widgets/loading.dart';
import 'package:restaurant_admin_dashboard/core/utils/responsive.dart';
import 'package:restaurant_admin_dashboard/features/menu/data/model/menu_model.dart';
import 'package:restaurant_admin_dashboard/features/menu/presentation/BLoC/menu_bloc.dart';
import 'package:restaurant_admin_dashboard/features/menu/presentation/BLoC/menu_event.dart';
import 'package:restaurant_admin_dashboard/features/menu/presentation/BLoC/menu_form_bloc.dart';
import 'package:restaurant_admin_dashboard/features/menu/presentation/BLoC/menu_form_event.dart';
import 'package:restaurant_admin_dashboard/features/menu/presentation/BLoC/menu_state.dart';
import 'package:restaurant_admin_dashboard/features/menu/presentation/UI/widgets/desktop_view.dart';
import 'package:restaurant_admin_dashboard/features/menu/presentation/UI/widgets/mobile_view.dart';
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
                          LoadMenuItems(sectionId: sectionModel.id),
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
                  AdaptiveView(
                    desktop: MenuDesktopView(
                      section: sectionModel,
                      menuModel: menuModel,
                    ),
                    mobile: MenuMobileView(
                      section: sectionModel,
                      menuModel: menuModel,
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
        ),
      ),
    );
  }
}
