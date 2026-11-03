import 'package:equatable/equatable.dart';

import '../../data/model/order_model.dart';

sealed class OrdersState extends Equatable {
  final List<OrderModel> orders;
  final String? selectedOrderId;
  final String selectedFilter;

  const OrdersState({
    required this.orders,
    this.selectedOrderId,
    this.selectedFilter = 'All',
  });

  List<OrderModel> get filteredOrders {
    if (selectedFilter.toLowerCase() == 'all') {
      return orders;
    }
    return orders
        .where((order) => matchesFilter(order.status, selectedFilter))
        .toList();
  }

  static bool matchesFilter(String status, String filter) {
    final cleanFilter = filter.trim().toLowerCase();
    if (cleanFilter == 'all') return true;

    final cleanStatus = status.trim().toLowerCase();

    switch (cleanFilter) {
      case 'pending':
        return cleanStatus == 'pending';
      case 'preparing':
        return cleanStatus == 'preparing' || cleanStatus == 'processing';
      case 'on the way':
        return cleanStatus == 'on the way' ||
            cleanStatus == 'on_the_way' ||
            cleanStatus == 'ontheway';
      case 'delivered':
        return cleanStatus == 'delivered' || cleanStatus == 'completed';
      case 'cancelled':
      case 'canceled':
        return cleanStatus == 'cancelled' || cleanStatus == 'canceled';
      default:
        return cleanStatus == cleanFilter;
    }
  }

  @override
  List<Object?> get props => [orders, selectedOrderId, selectedFilter];
}

final class OrdersInitial extends OrdersState {
  const OrdersInitial({
    required super.orders,
    super.selectedOrderId,
    super.selectedFilter = 'All',
  });
}

final class OrdersLoading extends OrdersState {
  const OrdersLoading({
    required super.orders,
    super.selectedOrderId,
    super.selectedFilter = 'All',
  });
}

final class OrdersLoaded extends OrdersState {
  const OrdersLoaded({
    required super.orders,
    super.selectedOrderId,
    super.selectedFilter = 'All',
  });

  OrdersLoaded copyWith({
    List<OrderModel>? orders,
    String? selectedOrderId,
    String? selectedFilter,
  }) {
    return OrdersLoaded(
      orders: orders ?? this.orders,
      selectedOrderId: selectedOrderId ?? this.selectedOrderId,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }
}

final class OrdersError extends OrdersState {
  final String message;

  const OrdersError({
    required super.orders,
    required this.message,
    super.selectedOrderId,
    super.selectedFilter = 'All',
  });

  @override
  List<Object?> get props => [...super.props, message];
}

final class UpdateStatusLoading extends OrdersState {
  const UpdateStatusLoading({
    required super.orders,
    super.selectedOrderId,
    super.selectedFilter = 'All',
  });
}

final class UpdateStatusSuccess extends OrdersState {
  const UpdateStatusSuccess({
    required super.orders,
    super.selectedOrderId,
    super.selectedFilter = 'All',
  });
}

final class UpdateStatusError extends OrdersState {
  final String message;

  const UpdateStatusError({
    required super.orders,
    required this.message,
    super.selectedOrderId,
    super.selectedFilter = 'All',
  });

  @override
  List<Object?> get props => [...super.props, message];
}
