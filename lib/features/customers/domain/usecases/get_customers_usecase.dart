import 'package:restaurant_admin_dashboard/features/customers/data/model/customer_model.dart';
import 'package:restaurant_admin_dashboard/features/customers/domain/repositories/customers_repository.dart';

class GetCustomersUseCase {

  final CustomersRepository _customersRepository;

  const GetCustomersUseCase({required this._customersRepository});

  Future<List<CustomerModel>> call() {
    return _customersRepository.getCustomers();
  }

}