import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_admin_dashboard/features/customers/data/model/customer_model.dart';
import 'package:restaurant_admin_dashboard/features/customers/domain/usecases/get_customers_usecase.dart';

import 'customers_event.dart';
import 'customers_state.dart';

class CustomersBloc extends Bloc<CustomersEvent, CustomersState> {
  final GetCustomersUseCase _getCustomersUseCase;
  List<CustomerModel> _allCustomers = const [];

  CustomersBloc({required this._getCustomersUseCase})
    : super(const CustomersInitial(customers: [])) {
    on<LoadCustomers>(_onLoadCustomers);
    on<SearchCustomers>(_onSearchCustomers);
  }

  Future<void> _onLoadCustomers(
    LoadCustomers event,
    Emitter<CustomersState> emit,
  ) async {
    emit(CustomersLoading(customers: state.customers));

    try {
      final customers = await _getCustomersUseCase.call();
      _allCustomers = customers;

      emit(CustomersLoaded(customers: customers));
    } catch (e) {
      emit(CustomersError(customers: state.customers, message: e.toString()));
    }
  }

  Future<void> _onSearchCustomers(
    SearchCustomers event,
    Emitter<CustomersState> emit,
  ) async {
    final query = event.query.trim().toLowerCase();

    if (query.isEmpty) {
      emit(CustomersLoaded(customers: _allCustomers));
      return;
    }

    final filteredCustomers = _allCustomers.where((customer) {
      final name = customer.name.toLowerCase();
      final email = customer.email.toLowerCase();
      return name.contains(query) || email.contains(query);
    }).toList();

    emit(CustomersLoaded(customers: filteredCustomers));
  }
}
