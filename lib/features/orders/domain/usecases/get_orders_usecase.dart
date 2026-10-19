import 'package:restaurant_admin_dashboard/features/orders/domain/repositories/orders_repository.dart';

import '../../data/model/order_model.dart';

class GetOrdersUseCase {

  final OrdersRepository _ordersRepository;

  const GetOrdersUseCase({required this._ordersRepository});

  Future<List<OrderModel>> call() async {
    return await _ordersRepository.getOrders();
  }

}
