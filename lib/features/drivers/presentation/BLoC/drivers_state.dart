import 'package:equatable/equatable.dart';
import 'package:restaurant_admin_dashboard/features/drivers/data/model/driver_model.dart';

sealed class DriversState extends Equatable {
  final List<DriverModel> drivers;
  final List<DriverModel> allDrivers;

  const DriversState({
    required this.drivers,
    required this.allDrivers,
  });

  @override
  List<Object?> get props => [drivers, allDrivers];
}

final class DriversInitial extends DriversState {
  const DriversInitial({
    required super.drivers,
    required super.allDrivers,
  });
}

final class DriversLoading extends DriversState {
  const DriversLoading({
    required super.drivers,
    required super.allDrivers,
  });
}

final class DriversLoaded extends DriversState {
  const DriversLoaded({
    required super.drivers,
    required super.allDrivers,
  });
}

final class DriversError extends DriversState {
  final String message;

  const DriversError({
    required super.drivers,
    required super.allDrivers,
    required this.message,
  });

  @override
  List<Object?> get props => [...super.props, message];
}
