import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_admin_dashboard/features/customers/data/model/customer_model.dart';

class CustomersTable extends StatelessWidget {
  final List<CustomerModel> customers;

  const CustomersTable({
    super.key,
    required this.customers,
  });

  @override
  Widget build(BuildContext context) {
    if (customers.isEmpty) {
      return Center(
        child: Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: const Color(0xFFE8E4DF),
            ),
          ),
          child: Text(
            'No customers found',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF8A8580),
            ),
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
            border: Border.all(
              color: const Color(0xFFE8E4DF),
            ),
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
                    _column('Customer'),
                    _column('Phone Number'),
                    _column('Email address'),
                  ],

                  rows: customers.map((customer) {
                    return DataRow(
                      cells: [
                        // Customer
                        DataCell(
                          Row(
                            children: [
                              Container(
                                width: 40.w,
                                height: 40.w,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFFF0E9),
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  customer.id,
                                  style: TextStyle(
                                    color: const Color(0xFFFF5A1F),
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),

                              SizedBox(width: 12.w),

                              Text(
                                customer.name,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF211E1C),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Phone Number
                        DataCell(
                          Text(
                            customer.phone,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: const Color(0xFF6F6964),
                            ),
                          ),
                        ),

                        // Email
                        DataCell(
                          Text(
                            customer.email,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: const Color(0xFF8A8580),
                            ),
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
}



  DataColumn _column(String label) {
    return DataColumn(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF6F6964),
        ),
      ),
    );
  }
