import 'package:restaurant_admin_dashboard/core/network/supabase_client.dart';
import 'package:restaurant_admin_dashboard/features/customers/data/model/customer_model.dart';

class CustomersService {
  final SupabaseClientService _supabaseClientService;

  const CustomersService({required this._supabaseClientService});

  Future<List<CustomerModel>> getCustomers() async {
    final response = await _supabaseClientService.request(
      type: SupabaseRequestType.select,
      table: 'users',
      filters: {'role': 'CUSTOMER'},
    );

    final rows = List<Map<String, dynamic>>.from(response.data);
    return rows
        .map((row) => CustomerModel.fromJson(row))
        .toList(growable: false);
  }
}
