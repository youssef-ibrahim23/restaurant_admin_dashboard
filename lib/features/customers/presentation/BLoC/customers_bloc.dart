import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_admin_dashboard/features/customers/domain/usecases/get_customers_usecase.dart';

import 'customers_event.dart';
import 'customers_state.dart';

class CustomersBloc extends Bloc<CustomersEvent, CustomersState> {
  final GetCustomersUseCase _getCustomersUseCase;

  CustomersBloc({required this._getCustomersUseCase})
    : super(const CustomersInitial(customers: [], allCustomers: [])) {
    on<LoadCustomers>(_onLoadCustomers);
    on<SearchCustomers>(_onSearchCustomers);
  }

  Future<void> _onLoadCustomers(
    LoadCustomers event,
    Emitter<CustomersState> emit,
  ) async {
    emit(
      CustomersLoading(
        customers: state.customers,
        allCustomers: state.allCustomers,
      ),
    );

    try {
      final customers = await _getCustomersUseCase.call();
      emit(CustomersLoaded(customers: customers, allCustomers: customers));
    } catch (e) {
      emit(
        CustomersError(
          customers: state.customers,
          allCustomers: state.allCustomers,
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> _onSearchCustomers(
    SearchCustomers event,
    Emitter<CustomersState> emit,
  ) async {
    final query = event.query.trim().toLowerCase();

    if (query.isEmpty) {
      emit(
        CustomersLoaded(customers: state.allCustomers, allCustomers: state.allCustomers),
      );
      return;
    }

    final filteredCustomers = state.allCustomers.where((customer) {
      final name = customer.name.toLowerCase();
      final email = customer.email.toLowerCase();
      final phone = customer.phone.toLowerCase();
      return name.contains(query) ||
          email.contains(query) ||
          phone.contains(query);
    }).toList();

    emit(
      CustomersLoaded(customers: filteredCustomers, allCustomers: state.allCustomers),
    );
  }
}
