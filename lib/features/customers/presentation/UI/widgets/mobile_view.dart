import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_admin_dashboard/features/customers/data/model/customer_model.dart';

class CustomersMobileView extends StatelessWidget {
  final List<CustomerModel> customers;
  final ValueChanged<String> onSearchChanged;

  const CustomersMobileView({
    super.key,
    required this.customers,
    required this.onSearchChanged,
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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: _MobileSearchField(onChanged: onSearchChanged),
        ),
        SizedBox(height: 16.h),
        Expanded(
          child: customers.isEmpty
              ? Center(
                  child: Text(
                    'No customers found',
                    style: TextStyle(
                      fontSize: 28.sp,
                      color: const Color(0xFF8A8580),
                    ),
                  ),
                )
              : ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemCount: customers.length,
                  separatorBuilder: (_, _) => SizedBox(height: 10.h),
                  itemBuilder: (context, index) {
                    return _CustomerCard(customer: customers[index]);
                  },
                ),
        ),
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
          'Restaurant Customers',
          style: TextStyle(
            fontSize: 56.sp,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF211E1C),
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          'Explore your restaurant customers information',
          style: TextStyle(
            fontSize: 28.sp,
            color: const Color(0xFF8A8580),
          ),
        ),
      ],
    );
  }
}

class _MobileSearchField extends StatefulWidget {
  final ValueChanged<String>? onChanged;

  const _MobileSearchField({
    this.onChanged,
  });

  @override
  State<_MobileSearchField> createState() => _MobileSearchFieldState();
}

class _MobileSearchFieldState extends State<_MobileSearchField> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  void _onChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () {
      widget.onChanged?.call(query);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 112.h,
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32.r),
        border: Border.all(color: const Color(0xFFE8E4DF)),
      ),
      child: Row(
        children: [
          Icon(Icons.search, size: 40.sp, color: const Color(0xFF8A8580)),
          SizedBox(width: 24.w),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: _onChanged,
              decoration: InputDecoration(
                hintText: 'Search customers',
                hintStyle: TextStyle(
                  fontSize: 28.sp,
                  color: const Color(0xFF8A8580),
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: TextStyle(fontSize: 28.sp, color: const Color(0xFF211E1C)),
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomerCard extends StatelessWidget {
  final CustomerModel customer;

  const _CustomerCard({required this.customer});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(28.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(color: const Color(0xFFE8E4DF)),
      ),
      child: Row(
        children: [
          Container(
            width: 88.w,
            height: 88.w,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFFFFF0E9),
              shape: BoxShape.circle,
            ),
            child: Text(
              customer.id,
              style: TextStyle(
                color: const Color(0xFFFF5A1F),
                fontSize: 30.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(width: 24.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customer.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF211E1C),
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  customer.phone,
                  style: TextStyle(
                    fontSize: 24.sp,
                    color: const Color(0xFF6F6964),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  customer.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 22.sp,
                    color: const Color(0xFF8A8580),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
