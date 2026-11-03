import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_orders_usecase.dart';
import '../../domain/usecases/update_status_usecase.dart';
import 'orders_event.dart';
import 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final GetOrdersUseCase _getOrdersUseCase;
  final UpdateStatusUseCase _updateStatusUseCase;

  OrdersBloc({
    required GetOrdersUseCase getOrdersUseCase,
    required UpdateStatusUseCase updateStatusUseCase,
  })  : _getOrdersUseCase = getOrdersUseCase,
        _updateStatusUseCase = updateStatusUseCase,
        super(const OrdersInitial(orders: [])) {
    on<LoadOrders>((event, emit) async {
      emit(OrdersLoading(
        orders: state.orders,
        selectedOrderId: state.selectedOrderId,
        selectedFilter: state.selectedFilter,
      ));
      try {
        final orders = await _getOrdersUseCase.call();
        final filtered = orders
            .where((o) => OrdersState.matchesFilter(o.status, state.selectedFilter))
            .toList();

        final selectedOrderId = state.selectedOrderId != null &&
                filtered.any((o) => o.id == state.selectedOrderId)
            ? state.selectedOrderId
            : (filtered.isNotEmpty
                ? filtered.first.id
                : (orders.isNotEmpty ? orders.first.id : null));

        emit(OrdersLoaded(
          orders: orders,
          selectedOrderId: selectedOrderId,
          selectedFilter: state.selectedFilter,
        ));
      } catch (e) {
        print('error loading orders: $e');
        emit(OrdersError(
          orders: state.orders,
          message: e.toString(),
          selectedOrderId: state.selectedOrderId,
          selectedFilter: state.selectedFilter,
        ));
      }
    });

    on<SelectOrder>((event, emit) {
      emit(OrdersLoaded(
        orders: state.orders,
        selectedOrderId: event.orderId,
        selectedFilter: state.selectedFilter,
      ));
    });

    on<FilterOrders>((event, emit) {
      final filtered = state.orders
          .where((order) => OrdersState.matchesFilter(order.status, event.status))
          .toList();

      final isCurrentSelectedValid = filtered.any(
        (order) => order.id == state.selectedOrderId,
      );

      final newSelectedOrderId = isCurrentSelectedValid
          ? state.selectedOrderId
          : (filtered.isNotEmpty ? filtered.first.id : null);

      emit(OrdersLoaded(
        orders: state.orders,
        selectedOrderId: newSelectedOrderId,
        selectedFilter: event.status,
      ));
    });

    on<UpdateStatus>((event, emit) async {
      emit(UpdateStatusLoading(
        orders: state.orders,
        selectedOrderId: state.selectedOrderId,
        selectedFilter: state.selectedFilter,
      ));
      try {
        await _updateStatusUseCase.call(event.orderId, event.status);

        final updatedOrders = state.orders.map((order) {
          if (order.id == event.orderId) {
            return order.copyWith(status: event.status);
          }
          return order;
        }).toList();

        final filtered = updatedOrders
            .where((o) => OrdersState.matchesFilter(o.status, state.selectedFilter))
            .toList();

        final isStillValid = filtered.any((o) => o.id == state.selectedOrderId);
        final nextSelectedId = isStillValid
            ? state.selectedOrderId
            : (filtered.isNotEmpty ? filtered.first.id : null);

        emit(
          UpdateStatusSuccess(
            orders: updatedOrders,
            selectedOrderId: nextSelectedId,
            selectedFilter: state.selectedFilter,
          ),
        );
      } catch (e) {
        print('UpdateStatus error: $e');
        emit(UpdateStatusError(
          orders: state.orders,
          message: e.toString(),
          selectedOrderId: state.selectedOrderId,
          selectedFilter: state.selectedFilter,
        ));
      }
    });
  }
}
