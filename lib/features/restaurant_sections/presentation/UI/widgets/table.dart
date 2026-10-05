import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/data/model/section_model.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/presentation/BLoC/sections_bloc.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/presentation/BLoC/sections_event.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/presentation/BLoC/sections_state.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/presentation/UI/helpers/section_background.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/presentation/UI/widgets/section_dialog.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/presentation/UI/widgets/delete_confirmation_dialog.dart';

import '../helpers/section_icon.dart';

class RestaurantsTable extends StatelessWidget {
  final Function(SectionModel) onManageMenu;

  const RestaurantsTable({
    super.key,
    required this.onManageMenu,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SectionsBloc, SectionsState>(
      builder: (context, state) {
        if (state is SectionsError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: ${state.message}',
                  style: TextStyle(color: Colors.red, fontSize: 14.sp),
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () {
                    context.read<SectionsBloc>().add(LoadSections());
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // TODO: Refactor state checking once SectionActionSuccess is decoupled from data state; avoid conditional casting (state is SectionsLoaded vs SectionActionSuccess).
        if (state is SectionsLoaded || state is SectionActionSuccess) {
          final sections = state is SectionsLoaded
              ? state.sections
              : (state as SectionActionSuccess).sections;

          if (sections.isEmpty) {
            return Center(
              child: Text(
                'No sections found',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: const Color(0xFF8A8580),
                ),
              ),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: const Color(0xFFE8E4DF)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: constraints.maxWidth,
                      ),
                      child: DataTable(
                        headingRowHeight: 56.h,
                        dataRowMinHeight: 70.h,
                        dataRowMaxHeight: 70.h,
                        columnSpacing: 40.w,
                        horizontalMargin: 24.w,
                        headingRowColor: WidgetStateProperty.all(
                          const Color(0xFFFAF9F7),
                        ),
                        columns: [
                          DataColumn(
                            label: Text(
                              'Section',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF6F6964),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Status',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF6F6964),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Actions',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF6F6964),
                              ),
                            ),
                          ),
                        ],
                        rows: sections.map((section) {
                          return DataRow(
                            cells: [
                              DataCell(
                                Row(
                                  children: [
                                    Container(
                                      width: 42.w,
                                      height: 42.w,
                                      decoration: BoxDecoration(
                                        color: SectionBackground.get(section.name),
                                        borderRadius: BorderRadius.circular(
                                          10.r,
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        SectionIcon.get(section.name),
                                        style: TextStyle(
                                          fontSize: 23.sp,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Text(
                                      section.name,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF211E1C),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              DataCell(
                                InkWell(
                                  onTap: () {
                                    context.read<SectionsBloc>().add(
                                      ToggleAvailability(
                                        sectionModel: SectionModel(
                                          id: section.id,
                                          name: section.name,
                                          isOpen: !section.isOpen,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                      vertical: 6.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: section.isOpen
                                          ? const Color(0xFFE7F7ED)
                                          : Colors.red.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    child: Text(
                                      section.isOpen ? 'Open' : 'Closed',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w700,
                                        color: section.isOpen
                                            ? const Color(0xFF239B56)
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    OutlinedButton.icon(
                                      onPressed: () {
                                        onManageMenu(section);
                                      },
                                      icon: Icon(
                                        Icons.restaurant_menu,
                                        size: 17.sp,
                                      ),
                                      label: const Text('Manage Menu'),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: const Color(
                                          0xFFFF5A1F,
                                        ),
                                        side: const BorderSide(
                                          color: Color(0xFFFF5A1F),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 14.w,
                                          vertical: 10.h,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    IconButton(
                                      tooltip: 'Edit',
                                      onPressed: () {
                                        SectionDialog.showEditDialog(
                                          context,
                                          section,
                                        );
                                      },
                                      icon: Icon(
                                        Icons.edit_outlined,
                                        size: 19.sp,
                                        color: const Color(0xFF55504C),
                                      ),
                                    ),
                                    IconButton(
                                      tooltip: 'Delete',
                                      onPressed: () {
                                        DeleteConfirmationDialog.show(
                                          context,
                                          section.id,
                                          section.name,
                                        );
                                      },
                                      icon: Icon(
                                        Icons.delete_outline,
                                        size: 19.sp,
                                        color: const Color(0xFFD64545),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
