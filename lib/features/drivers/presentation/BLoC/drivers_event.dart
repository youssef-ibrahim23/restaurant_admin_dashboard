import 'package:equatable/equatable.dart';

sealed class DriversEvent extends Equatable {
  const DriversEvent();
}

final class LoadDrivers extends DriversEvent {
  const LoadDrivers();

  @override
  List<Object?> get props => [];
}
