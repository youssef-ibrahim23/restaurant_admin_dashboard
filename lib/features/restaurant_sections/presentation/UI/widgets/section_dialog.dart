import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:restaurant_admin_dashboard/core/utils/responsive.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/data/model/section_model.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/presentation/BLoC/sections_bloc.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/presentation/BLoC/sections_event.dart';

class SectionDialog {
  static void showAddDialog(BuildContext context) {
    final nameController = TextEditingController();
    bool isAvailable = true;
    String? nameError;
    StateSetter? dialogSetState;

    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.scale,
      title: 'Add New Section',
      desc: 'Create a new menu section for your restaurant',
      width: context.adaptiveDialogWidth(500.w),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      body: StatefulBuilder(
        builder: (context, setState) {
          dialogSetState = setState;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  onChanged: (value) {
                    setState(() {
                      nameError = null;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Section Name',
                    hintText: 'e.g., Appetizers, Main Course',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(color: Color(0xFFE8E4DF)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(color: Color(0xFFE8E4DF)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(color: Color(0xFFFF5A1F), width: 2),
                    ),
                    errorText: nameError,
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Text(
                      'Available:',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF211E1C),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Switch(
                      value: isAvailable,
                      onChanged: (value) {
                        setState(() {
                          isAvailable = value;
                        });
                      },
                      activeColor: const Color(0xFFFF5A1F),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      isAvailable ? 'Open' : 'Closed',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: isAvailable
                            ? const Color(0xFF239B56)
                            : const Color(0xFF777777),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      btnOk: Container(
        height: 44.h,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF5A1F), Color(0xFFFF8C42)],
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: ElevatedButton(
          onPressed: () {
            final name = nameController.text.trim();
            if (name.isEmpty) {
              dialogSetState?.call(() {
                nameError = 'Section name is required';
              });
              return;
            }
            if (name.length < 2) {
              dialogSetState?.call(() {
                nameError = 'Name must be at least 2 characters';
              });
              return;
            }
            context.read<SectionsBloc>().add(
                  AddSection(
                    sectionModel: SectionModel(
                      id: 0,
                      name: name,
                      isOpen: isAvailable,
                    ),
                  ),
                );
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          child: Text(
            'Add Section',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      btnCancel: Container(
        height: 44.h,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F1F1),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: const Color(0xFF211E1C),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          child: Text(
            'Cancel',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      buttonsBorderRadius: BorderRadius.circular(12.r),
    ).show();
  }

  static void showEditDialog(BuildContext context, SectionModel section) {
    final nameController = TextEditingController(text: section.name);
    bool isAvailable = section.isOpen;
    String? nameError;
    StateSetter? dialogSetState;

    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.scale,
      title: 'Edit Section',
      desc: 'Update section details',
      width: context.adaptiveDialogWidth(500.w),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      body: StatefulBuilder(
        builder: (context, setState) {
          dialogSetState = setState;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  onChanged: (value) {
                    setState(() {
                      nameError = null;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Section Name',
                    hintText: 'e.g., Appetizers, Main Course',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(color: Color(0xFFE8E4DF)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(color: Color(0xFFE8E4DF)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(color: Color(0xFFFF5A1F), width: 2),
                    ),
                    errorText: nameError,
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Text(
                      'Available:',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF211E1C),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Switch(
                      value: isAvailable,
                      onChanged: (value) {
                        setState(() {
                          isAvailable = value;
                        });
                      },
                      activeColor: const Color(0xFFFF5A1F),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      isAvailable ? 'Open' : 'Closed',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: isAvailable
                            ? const Color(0xFF239B56)
                            : const Color(0xFF777777),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      btnOk: Container(
        height: 44.h,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF5A1F), Color(0xFFFF8C42)],
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: ElevatedButton(
          onPressed: () {
            final name = nameController.text.trim();
            if (name.isEmpty) {
              dialogSetState?.call(() {
                nameError = 'Section name is required';
              });
              return;
            }
            if (name.length < 2) {
              dialogSetState?.call(() {
                nameError = 'Name must be at least 2 characters';
              });
              return;
            }
            context.read<SectionsBloc>().add(
                  EditSection(
                    sectionModel: SectionModel(
                      id: section.id,
                      name: name,
                      isOpen: isAvailable,
                    ),
                  ),
                );
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          child: Text(
            'Save Changes',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      btnCancel: Container(
        height: 44.h,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F1F1),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: const Color(0xFF211E1C),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          child: Text(
            'Cancel',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      buttonsBorderRadius: BorderRadius.circular(12.r),
    ).show();
  }
}
