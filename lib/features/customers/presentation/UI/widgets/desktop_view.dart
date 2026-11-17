import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_admin_dashboard/features/customers/data/model/customer_model.dart';
import 'package:restaurant_admin_dashboard/features/customers/presentation/UI/widgets/header.dart';
import 'package:restaurant_admin_dashboard/features/customers/presentation/UI/widgets/search_field.dart';
import 'package:restaurant_admin_dashboard/features/customers/presentation/UI/widgets/table.dart';

class CustomersDesktopView extends StatelessWidget {
  final List<CustomerModel> customers;
  final ValueChanged<String> onSearchChanged;

  const CustomersDesktopView({
    super.key,
    required this.customers,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(32.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Header(),
          SizedBox(height: 28.h),
          SearchField(onChanged: onSearchChanged),
          SizedBox(height: 28.h),
          Expanded(
            child: SingleChildScrollView(
              child: CustomersTable(customers: customers),
            ),
          ),
        ],
      ),
    );
  }
}
