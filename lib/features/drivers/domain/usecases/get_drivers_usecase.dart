import 'package:restaurant_admin_dashboard/features/drivers/domain/repositories/drivers_repository.dart';

import '../../data/model/driver_model.dart';

class GetDriversUseCase {

  final DriversRepository _driversRepository;

  const GetDriversUseCase({
    required this._driversRepository,
  });

  Future<List<DriverModel>> call() async {
    return await _driversRepository.getDrivers();
  }
}