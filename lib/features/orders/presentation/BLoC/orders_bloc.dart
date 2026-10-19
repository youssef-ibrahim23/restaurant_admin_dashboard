import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_orders_usecase.dart';
import '../../domain/usecases/update_status_usecase.dart';
import 'orders_event.dart';
import 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final GetOrdersUseCase _getOrdersUseCase;

  final UpdateStatusUseCase _updateStatusUseCase;

  OrdersBloc({required this._getOrdersUseCase, required this._updateStatusUseCase})
    : super(OrdersInitial(orders: [])) {
    on<LoadOrders>((event, emit) async {
      emit(OrdersLoading(orders: state.orders, selectedOrderId: state.selectedOrderId));
      try {
        final orders = await _getOrdersUseCase.call();
        final selectedOrderId = state.selectedOrderId ?? (orders.isNotEmpty ? orders.first.id : null);
        emit(OrdersLoaded(orders: orders, selectedOrderId: selectedOrderId));
      } catch (e) {
        print('error loading orders: $e');
        emit(OrdersError(orders: state.orders, message: e.toString(), selectedOrderId: state.selectedOrderId));
      }
    });

    on<SelectOrder>((event, emit) {
      emit(OrdersLoaded(
        orders: state.orders,
        selectedOrderId: event.orderId,
      ));
    });

    on<UpdateStatus>((event, emit) async{
      emit(UpdateStatusLoading(orders: state.orders, selectedOrderId: state.selectedOrderId));
      try{
        await _updateStatusUseCase.call(event.orderId, event.status);

        final updatedOrders = state.orders.map((order) {
          if (order.id == event.orderId) {
            return order.copyWith(status: event.status);
          }

          return order;
        }).toList();

        emit(
          UpdateStatusSuccess(
            orders: updatedOrders,
            selectedOrderId: event.orderId,
          ),
        );

      }catch(e){
        print('UpdateStatus error: $e');
        emit(UpdateStatusError(orders: state.orders, message: e.toString(), selectedOrderId: state.selectedOrderId));
      }
    });
  }
}
