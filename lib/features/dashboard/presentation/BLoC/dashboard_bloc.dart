

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_admin_dashboard/features/dashboard/domain/usecases/dashboard_usecase.dart';

import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {

  final DashboardUseCase _dashboardUseCase;

  DashboardBloc({required this._dashboardUseCase}) : super(DashboardInitial()) {
    on<GetDashboardData>((event, emit) async {
      emit(DashboardLoading());
      try{
        final dashboardData = await _dashboardUseCase.call();
        emit(DashboardLoaded(dashboardModel: dashboardData));
      }catch(e){
        print(e.toString());
        emit(DashboardError(message: e.toString()));
      }
    });
  }
}
