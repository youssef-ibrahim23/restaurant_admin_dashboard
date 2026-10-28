import 'package:equatable/equatable.dart';

sealed class OrdersEvent extends Equatable {}

final class LoadOrders extends OrdersEvent{

  @override
  List<Object?> get props => [];
}

final class SelectOrder extends OrdersEvent {
  final String orderId;

   SelectOrder({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

final class UpdateStatus extends OrdersEvent {
  final String orderId;
  final String status;

  UpdateStatus({required this.orderId, required this.status});

  @override
  List<Object?> get props => [orderId, status];
}
