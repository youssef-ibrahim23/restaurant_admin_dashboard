import 'package:restaurant_admin_dashboard/features/customers/data/service/customers_service.dart';
import 'package:restaurant_admin_dashboard/features/customers/domain/repositories/customers_repository.dart';

import '../model/customer_model.dart';

class CustomersRepositoryImpl implements CustomersRepository{

  final CustomersService _customersService;

  const CustomersRepositoryImpl({required this._customersService});

  @override
  Future<List<CustomerModel>> getCustomers() {
    return _customersService.getCustomers();
  }
}