import 'package:restaurant_admin_dashboard/features/orders/data/service/orders_service.dart';

import '../../domain/repositories/orders_repository.dart';
import '../model/order_model.dart';

class OrdersRepositoryImpl implements OrdersRepository {

  final OrdersService _ordersService;

  const OrdersRepositoryImpl({required this._ordersService});

  @override
  Future<List<OrderModel>> getOrders() async {
    return await _ordersService.getOrders();
  }

  @override
  Future<void> updateStatus(String id, String status) async {
    await _ordersService.updateStatus(id, status);
  }
}