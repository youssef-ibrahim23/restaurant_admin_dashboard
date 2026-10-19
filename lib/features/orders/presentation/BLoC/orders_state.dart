import 'package:equatable/equatable.dart';

import '../../data/model/order_model.dart';

sealed class OrdersState extends Equatable {

  final List<OrderModel> orders;
  final String? selectedOrderId;

  const OrdersState({
    required this.orders,
    this.selectedOrderId,
  });

  @override
  List<Object?> get props => [orders, selectedOrderId];

}

final class OrdersInitial extends OrdersState {
  const OrdersInitial({required super.orders, super.selectedOrderId});
}

final class OrdersLoading extends OrdersState {
  const OrdersLoading({required super.orders, super.selectedOrderId});
}

final class OrdersLoaded extends OrdersState{
  const OrdersLoaded({required super.orders, super.selectedOrderId});

  OrdersLoaded copyWith({
    List<OrderModel>? orders,
    String? selectedOrderId,
  }) {
    return OrdersLoaded(
      orders: orders ?? this.orders,
      selectedOrderId: selectedOrderId ?? this.selectedOrderId,
    );
  }
}

final class OrdersError extends OrdersState {
  final String message;

  const OrdersError({required super.orders, required this.message, super.selectedOrderId});

  @override
  List<Object?> get props => [...super.props, message];

}

final class UpdateStatusLoading extends OrdersState {
  const UpdateStatusLoading({required super.orders, super.selectedOrderId});
}

final class UpdateStatusSuccess extends OrdersState {
  const UpdateStatusSuccess({required super.orders, super.selectedOrderId});
}

final class UpdateStatusError extends OrdersState {
  final String message;
  const UpdateStatusError({required super.orders, required this.message, super.selectedOrderId});
}
