import 'package:equatable/equatable.dart';
import 'package:restaurant_admin_dashboard/features/customers/data/model/customer_model.dart';

sealed class CustomersState extends Equatable {
  final List<CustomerModel> customers;

  const CustomersState({
    required this.customers,
  });

  @override
  List<Object?> get props => [customers];
}

final class CustomersInitial extends CustomersState {
  const CustomersInitial({
    required super.customers,
  });
}

final class CustomersLoading extends CustomersState {
  const CustomersLoading({
    required super.customers,
  });
}

final class CustomersLoaded extends CustomersState {
  const CustomersLoaded({
    required super.customers,
  });
}

final class CustomersError extends CustomersState {
  final String message;

  const CustomersError({
    required super.customers,
    required this.message,
  });

  @override
  List<Object?> get props => [
    customers,
    message,
  ];
}