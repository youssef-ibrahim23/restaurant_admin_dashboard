import 'package:restaurant_admin_dashboard/features/drivers/data/service/driver_service.dart';
import 'package:restaurant_admin_dashboard/features/drivers/domain/repositories/drivers_repository.dart';

import '../model/driver_model.dart';

class DriversRepositoryImpl implements DriversRepository{

  final DriversService _driversService;

  const DriversRepositoryImpl({
    required this._driversService,
  });

  @override
  Future<List<DriverModel>> getDrivers() {
    return _driversService.getDrivers();
  }
}