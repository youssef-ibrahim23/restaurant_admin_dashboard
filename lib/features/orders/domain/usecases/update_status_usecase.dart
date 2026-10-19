import 'package:restaurant_admin_dashboard/features/orders/domain/repositories/orders_repository.dart';

class UpdateStatusUseCase {

  final OrdersRepository _ordersRepository;

  const UpdateStatusUseCase({required this._ordersRepository});

  Future<void> call(String id, String status) async {
    await _ordersRepository.updateStatus(id, status);
  }

}