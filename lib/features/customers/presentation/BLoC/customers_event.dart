import 'package:equatable/equatable.dart';

sealed class CustomersEvent extends Equatable {
  const CustomersEvent();
}

final class LoadCustomers extends CustomersEvent {

  const LoadCustomers();

  @override
  List<Object?> get props => [];
}

final class SearchCustomers extends CustomersEvent {
  final String query;

  const SearchCustomers(this.query);

  @override
  List<Object?> get props => [query];
}
