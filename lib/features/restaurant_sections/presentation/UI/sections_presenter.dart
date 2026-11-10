import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_admin_dashboard/core/di/service_locator.dart';
import 'package:restaurant_admin_dashboard/core/shared/widgets/loading.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/presentation/BLoC/sections_bloc.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/presentation/BLoC/sections_event.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/presentation/BLoC/sections_state.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/presentation/UI/widgets/header.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/presentation/UI/widgets/table.dart';
import 'package:restaurant_admin_dashboard/features/menu/presentation/UI/menu_presenter.dart';

class RestaurantsPresenter extends StatelessWidget {
  const RestaurantsPresenter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SectionsBloc>()..add(LoadSections()),
      child: BlocListener<SectionsBloc, SectionsState>(
        listener: (context, state){
          if (state is SectionActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: const Color(0xFF239B56),
                duration: const Duration(seconds: 2),
              ),
            );
            context.read<SectionsBloc>().add(LoadSections());
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
            buildWhen: (previous, current) {
              return previous.isLoading != current.isLoading ||
                  previous.sections.length != current.sections.length;
            },
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
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => Scaffold(
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
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ),
                                    body: MenuPresenter(
                                      sectionModel: section,
                                      showScaffold: false,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (state is SectionsLoading && state.sections.isEmpty) Loading(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
