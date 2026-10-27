import 'package:equatable/equatable.dart';

sealed class CustomersEvent extends Equatable {}

// TODO: Declare event constructors as const (e.g., const LoadCustomers()) for immutability and performance.
final class LoadCustomers extends CustomersEvent {
  @override
  List<Object?> get props => [];
}

// TODO: Declare event constructors as const (e.g., const SearchCustomers(this.query)).
final class SearchCustomers extends CustomersEvent {
  final String query;

  SearchCustomers(this.query);

  @override
  List<Object?> get props => [query];
}
