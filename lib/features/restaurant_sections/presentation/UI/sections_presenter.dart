import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_admin_dashboard/core/di/service_locator.dart';
import 'package:restaurant_admin_dashboard/core/shared/widgets/loading.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/data/model/section_model.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/presentation/BLoC/sections_bloc.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/presentation/BLoC/sections_event.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/presentation/BLoC/sections_state.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/presentation/UI/widgets/header.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/presentation/UI/widgets/table.dart';
import 'package:restaurant_admin_dashboard/features/menu/presentation/UI/menu_presenter.dart';
import 'package:restaurant_admin_dashboard/features/sidebar/presentation/BLoC/sidebar_bloc.dart';
import 'package:restaurant_admin_dashboard/features/sidebar/presentation/BLoC/sidebar_event.dart';
import 'package:restaurant_admin_dashboard/features/sidebar/presentation/BLoC/sidebar_state.dart';

class RestaurantsPresenter extends StatelessWidget {
  const RestaurantsPresenter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SectionsBloc>()..add(LoadSections()),
      child: BlocSelector<SidebarBloc, SidebarState, SectionModel?>(
        selector: (state) => state.selectedSection,
        builder: (context, selectedSection) {
          if (selectedSection != null) {
            return Scaffold(
              backgroundColor: const Color(0xFFF7F4EF),
              appBar: AppBar(
                surfaceTintColor: const Color(0xFFF7F4EF),
                backgroundColor: const Color(0xFFF7F4EF),
                elevation: 0,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: 20.sp,
                    color: const Color(0xFF211E1C),
                  ),
                  onPressed: () {
                    context.read<SidebarBloc>().add(SectionMenuBack());
                  },
                ),
              ),
              body: MenuPresenter(
                sectionModel: selectedSection,
                showScaffold: false,
              ),
            );
          }

          return BlocListener<SectionsBloc, SectionsState>(
            listener: (context, state){
              if (state is SectionActionSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: const Color(0xFF239B56),
                    duration: const Duration(seconds: 2),
                  ),
                );
              } else if (state is SectionsError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: const Color(0xFFD64545),
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
            },
            child: Scaffold(
              backgroundColor: const Color(0xFFF7F5F1),
              body: BlocBuilder<SectionsBloc, SectionsState>(
                builder: (context, state) {
                  return Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(32.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Header(),
                            SizedBox(height: 28.h),
                            Expanded(
                              child: RestaurantsTable(
                                onManageMenu: (section) {
                                  context.read<SidebarBloc>().add(
                                    SectionMenuSelected(section),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Only show loading spinner on initial load (when sections is empty)
                      if (state is SectionsLoading && state.sections.isEmpty) Loading(),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
