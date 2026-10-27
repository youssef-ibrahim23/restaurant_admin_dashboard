import 'package:equatable/equatable.dart';
import 'package:restaurant_admin_dashboard/features/customers/data/model/customer_model.dart';

sealed class CustomersState extends Equatable {
  final List<CustomerModel> customers;
  final List<CustomerModel> allCustomers;

  const CustomersState({required this.customers, required this.allCustomers});

  @override
  List<Object?> get props => [customers, allCustomers];
}

final class CustomersInitial extends CustomersState {
  const CustomersInitial({
    required super.customers,
    required super.allCustomers,
  });
}

final class CustomersLoading extends CustomersState {
  const CustomersLoading({
    required super.customers,
    required super.allCustomers,
  });
}

final class CustomersLoaded extends CustomersState {
  const CustomersLoaded({
    required super.customers,
    required super.allCustomers,
  });
}

final class CustomersError extends CustomersState {
  final String message;

  const CustomersError({
    required super.customers,
    required super.allCustomers,
    required this.message,
  });

  @override
  List<Object?> get props => [...super.props, message];
}
