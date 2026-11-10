import 'package:equatable/equatable.dart';
import 'package:restaurant_admin_dashboard/features/drivers/data/model/driver_model.dart';

sealed class DriversState extends Equatable {
  final List<DriverModel> drivers;

  const DriversState({
    required this.drivers,
  });

  int get onlineCount => drivers
      .where((driver) {
        final status = driver.status.toLowerCase();
        return status == 'available' || status == 'delivering';
      })
      .length;

  int get offlineCount => drivers
      .where((driver) => driver.status.toLowerCase() == 'offline')
      .length;

  @override
  List<Object?> get props => [drivers];
}

final class DriversInitial extends DriversState {
  const DriversInitial({
    required super.drivers,
  });
}

final class DriversLoading extends DriversState {
  const DriversLoading({
    required super.drivers,
  });
}

final class DriversLoaded extends DriversState {
  const DriversLoaded({
    required super.drivers,
  });
}

final class DriversError extends DriversState {
  final String message;

  const DriversError({
    required super.drivers,
    required this.message,
  });

  @override
  List<Object?> get props => [...super.props, message];
}
