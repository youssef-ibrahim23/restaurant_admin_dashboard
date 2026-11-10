import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_admin_dashboard/features/promos/presentation/BLoC/promos_bloc.dart';
import 'package:restaurant_admin_dashboard/features/promos/presentation/BLoC/promos_event.dart';
import 'package:restaurant_admin_dashboard/features/promos/presentation/BLoC/promos_state.dart';
import 'delete_confirmation_dialog.dart';
import 'promo_dialog.dart';

class PromosTable extends StatelessWidget {
  const PromosTable({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PromosBloc, PromosState>(
      builder: (context, state) {
        if (state is PromosError && state.promos.isEmpty && !state.isActionError) {
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
                    context.read<PromosBloc>().add(LoadPromos());
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final promos = state.promos;

        if (promos.isEmpty) {
          return Center(
            child: Text(
              'No promos found',
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
                            'Promo Code',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF6F6964),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Discount',
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
                            'Created Date',
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
                      rows: promos.map((promo) {
                        return DataRow(
                          cells: [
                            DataCell(
                              Row(
                                children: [
                                  Container(
                                    width: 42.w,
                                    height: 42.w,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFF0E9),
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      '🏷️',
                                      style: TextStyle(
                                        fontSize: 22.sp,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Text(
                                    promo.code,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF211E1C),
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            DataCell(
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF0E9),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Text(
                                  '${promo.discount.toStringAsFixed(0)}% OFF',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFFF5A1F),
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              InkWell(
                                onTap: () {
                                  final newStatus = promo.isActive ? 'Inactive' : 'Active';
                                  context.read<PromosBloc>().add(
                                        TogglePromoStatus(
                                          promoModel: promo.copyWith(status: newStatus),
                                        ),
                                      );
                                },
                                borderRadius: BorderRadius.circular(20.r),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 6.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: promo.isActive
                                        ? const Color(0xFFE7F7ED)
                                        : Colors.red.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: Text(
                                    promo.isActive ? 'Active' : 'Inactive',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w700,
                                      color: promo.isActive
                                          ? const Color(0xFF239B56)
                                          : const Color(0xFFD64545),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                _formatDate(promo.createdAt),
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: const Color(0xFF6F6964),
                                ),
                              ),
                            ),
                            DataCell(
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    tooltip: 'Edit',
                                    onPressed: () {
                                      PromoDialog.showEditDialog(
                                        context,
                                        promo,
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
                                      DeletePromoConfirmationDialog.show(
                                        context,
                                        promo.id,
                                        promo.code,
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
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
