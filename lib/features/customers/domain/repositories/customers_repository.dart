import 'package:restaurant_admin_dashboard/features/customers/data/model/customer_model.dart';

abstract class CustomersRepository {

  Future<List<CustomerModel>> getCustomers();
  
}