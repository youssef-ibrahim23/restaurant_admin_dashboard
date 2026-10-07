import 'package:equatable/equatable.dart';

sealed class CustomersEvent extends Equatable {}

final class LoadCustomers extends CustomersEvent {
  @override
  List<Object?> get props => [];
}

final class SearchCustomers extends CustomersEvent {
  final String query;

  SearchCustomers(this.query);

  @override
  List<Object?> get props => [query];
}
