import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/data/model/section_model.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/presentation/BLoC/sections_bloc.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/presentation/BLoC/sections_event.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/presentation/BLoC/sections_state.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/presentation/UI/helpers/section_background.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/presentation/UI/helpers/section_icon.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/presentation/UI/widgets/delete_confirmation_dialog.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/presentation/UI/widgets/section_dialog.dart';

class SectionsMobileView extends StatelessWidget {
  final Function(SectionModel) onManageMenu;

  const SectionsMobileView({
    super.key,
    required this.onManageMenu,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
          child: _MobileHeader(),
        ),
        SizedBox(height: 16.h),
        Expanded(child: _SectionsMobileList(onManageMenu: onManageMenu)),
      ],
    );
  }
}

class _MobileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Menu Sections',
          style: TextStyle(
            fontSize: 44.sp,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF211E1C),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Manage your restaurant menu sections',
          style: TextStyle(fontSize: 24.sp, color: const Color(0xFF8A8580)),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          width: double.infinity,
          height: 44.h,
          child: ElevatedButton.icon(
            onPressed: () => SectionDialog.showAddDialog(context),
            icon: Icon(Icons.add, size: 40.sp),
            label: Text(
              'Add Section',
              style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w700),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF5A1F),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionsMobileList extends StatelessWidget {
  final Function(SectionModel) onManageMenu;

  const _SectionsMobileList({required this.onManageMenu});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SectionsBloc, SectionsState>(
      builder: (context, state) {
        if (state is SectionsError &&
            state.sections.isEmpty &&
            !state.isActionError) {
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
                  onPressed: () =>
                      context.read<SectionsBloc>().add(LoadSections()),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final sections = state.sections;

        if (sections.isEmpty) {
          return Center(
            child: Text(
              'No sections found',
              style: TextStyle(
                fontSize: 28.sp,
                color: const Color(0xFF8A8580),
              ),
            ),
          );
        }

        return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: sections.length,
          separatorBuilder: (_, _) => SizedBox(height: 10.h),
          itemBuilder: (context, index) =>
              _SectionCard(section: sections[index], onManageMenu: onManageMenu),
        );
      },
    );
  }
}

class _SectionCard extends StatelessWidget {
  final SectionModel section;
  final Function(SectionModel) onManageMenu;

  const _SectionCard({required this.section, required this.onManageMenu});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(28.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(color: const Color(0xFFE8E4DF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 84.w,
                height: 84.w,
                decoration: BoxDecoration(
                  color: SectionBackground.get(section.name),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                alignment: Alignment.center,
                child: Text(
                  SectionIcon.get(section.name),
                  style: TextStyle(fontSize: 44.sp),
                ),
              ),
              SizedBox(width: 24.w),
              Expanded(
                child: Text(
                  section.name,
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF211E1C),
                  ),
                ),
              ),
              _StatusBadge(section: section),
            ],
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => onManageMenu(section),
                  icon: Icon(Icons.restaurant_menu, size: 34.sp),
                  label: const Text('Manage Menu'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFFF5A1F),
                    side: const BorderSide(color: Color(0xFFFF5A1F)),
                    padding: EdgeInsets.symmetric(
                      horizontal: 28.w,
                      vertical: 20.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Edit',
                onPressed: () =>
                    SectionDialog.showEditDialog(context, section),
                icon: Icon(
                  Icons.edit_outlined,
                  size: 38.sp,
                  color: const Color(0xFF55504C),
                ),
              ),
              IconButton(
                tooltip: 'Delete',
                onPressed: () => DeleteConfirmationDialog.show(
                  context,
                  section.id,
                  section.name,
                ),
                icon: Icon(
                  Icons.delete_outline,
                  size: 38.sp,
                  color: const Color(0xFFD64545),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final SectionModel section;

  const _StatusBadge({required this.section});

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: section.isOpen
              ? const Color(0xFFE7F7ED)
              : Colors.red.withOpacity(0.2),
          borderRadius: BorderRadius.circular(40.r),
        ),
        child: Text(
          section.isOpen ? 'Open' : 'Closed',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: section.isOpen
                ? const Color(0xFF239B56)
                : Colors.black,
          ),
        ),
      ),
    );
  }
}
