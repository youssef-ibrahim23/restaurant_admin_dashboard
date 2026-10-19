import '../../data/model/order_model.dart';

abstract class OrdersRepository {
  Future<List<OrderModel>> getOrders();
  Future<void> updateStatus(String id, String status);
}