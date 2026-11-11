import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_admin_dashboard/features/promos/data/model/promos_model.dart';
import 'package:restaurant_admin_dashboard/features/promos/presentation/BLoC/promos_bloc.dart';
import 'package:restaurant_admin_dashboard/features/promos/presentation/BLoC/promos_event.dart';
import 'package:restaurant_admin_dashboard/features/promos/presentation/BLoC/promos_state.dart';
import 'package:restaurant_admin_dashboard/features/promos/presentation/UI/widgets/delete_confirmation_dialog.dart';
import 'package:restaurant_admin_dashboard/features/promos/presentation/UI/widgets/promo_dialog.dart';

class PromosMobileView extends StatelessWidget {
  const PromosMobileView({super.key});

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
        Expanded(child: _PromosMobileList()),
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
          'Promotions & Discounts',
          style: TextStyle(
            fontSize: 44.sp,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF211E1C),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'Manage your restaurant promo codes and offers',
          style: TextStyle(fontSize: 24.sp, color: const Color(0xFF8A8580)),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          width: double.infinity,
          height: 44.h,
          child: ElevatedButton.icon(
            onPressed: () => PromoDialog.showAddDialog(context),
            icon: Icon(Icons.add, size: 40.sp),
            label: Text(
              'Add Promo',
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

class _PromosMobileList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PromosBloc, PromosState>(
      builder: (context, state) {
        if (state is PromosError &&
            state.promos.isEmpty &&
            !state.isActionError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: ${state.message}',
                  style: TextStyle(color: Colors.red, fontSize: 28.sp),
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () =>
                      context.read<PromosBloc>().add(LoadPromos()),
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
                fontSize: 28.sp,
                color: const Color(0xFF8A8580),
              ),
            ),
          );
        }

        return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: promos.length,
          separatorBuilder: (_, _) => SizedBox(height: 10.h),
          itemBuilder: (context, index) =>
              _PromoCard(promo: promos[index]),
        );
      },
    );
  }
}

class _PromoCard extends StatelessWidget {
  final PromoModel promo;

  const _PromoCard({required this.promo});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFE8E4DF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                child: Text('🏷️', style: TextStyle(fontSize: 40.sp)),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      promo.code,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF211E1C),
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      '${promo.discount.toStringAsFixed(0)}% OFF • ${_formatDate(promo.createdAt)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 24.sp,
                        color: const Color(0xFF6F6964),
                      ),
                    ),
                  ],
                ),
              ),
              _StatusToggle(promo: promo),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                tooltip: 'Edit',
                onPressed: () =>
                    PromoDialog.showEditDialog(context, promo),
                icon: Icon(
                  Icons.edit_outlined,
                  size: 38.sp,
                  color: const Color(0xFF55504C),
                ),
              ),
              IconButton(
                tooltip: 'Delete',
                onPressed: () => DeletePromoConfirmationDialog.show(
                  context,
                  promo.id,
                  promo.code,
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

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

class _StatusToggle extends StatelessWidget {
  final PromoModel promo;

  const _StatusToggle({required this.promo});

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: promo.isActive
              ? const Color(0xFFE7F7ED)
              : Colors.red.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          promo.isActive ? 'Active' : 'Inactive',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: promo.isActive
                ? const Color(0xFF239B56)
                : const Color(0xFFD64545),
          ),
        ),
      ),
    );
  }
}
