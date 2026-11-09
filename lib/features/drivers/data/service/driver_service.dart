
import 'package:restaurant_admin_dashboard/core/network/supabase_client.dart';
import 'package:restaurant_admin_dashboard/features/drivers/data/model/driver_model.dart';

class DriversService {
  final SupabaseClientService _supabaseClientService;

  const DriversService({
    required this._supabaseClientService,
  });

  Future<List<DriverModel>> getDrivers() async {
    final response = await _supabaseClientService.request(
      type: SupabaseRequestType.select,
      table: 'drivers',
      select: '''
        id,
        status,
        rate,
        total_trips,
        latitude,
        longitude,
        heading,
        users!drivers_driver_id_fkey (
          name
        )
      ''',
    );

    final drivers = response.data as List<Map<String, dynamic>>;

    if (drivers.isEmpty) {
      throw Exception('Driver not found.');
    }

    return drivers.map(DriverModel.fromJson).toList();
  }
}
