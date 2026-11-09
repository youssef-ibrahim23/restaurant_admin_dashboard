import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_admin_dashboard/features/drivers/domain/usecases/get_drivers_usecase.dart';

import 'drivers_event.dart';
import 'drivers_state.dart';

class DriversBloc extends Bloc<DriversEvent, DriversState> {

  final GetDriversUseCase _getDriversUseCase;

  DriversBloc({required this._getDriversUseCase}) : super(const DriversInitial(drivers: [], allDrivers: [])) {
    on<LoadDrivers>(_onLoadDrivers);
  }

  Future<void> _onLoadDrivers(
    LoadDrivers event,
    Emitter<DriversState> emit,
  ) async {
    emit(
      DriversLoading(
        drivers: state.drivers,
        allDrivers: state.allDrivers,
      ),
    );

    try {
      final drivers = await _getDriversUseCase.call();
      emit(DriversLoaded(drivers: drivers, allDrivers: drivers));
    } catch (e) {
      emit(
        DriversError(
          drivers: state.drivers,
          allDrivers: state.allDrivers,
          message: e.toString(),
        ),
      );
    }
  }
}
