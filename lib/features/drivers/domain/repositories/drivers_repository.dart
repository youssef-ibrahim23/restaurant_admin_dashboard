import 'package:restaurant_admin_dashboard/features/drivers/data/model/driver_model.dart';

abstract class DriversRepository {
  Future<List<DriverModel>> getDrivers();
}
