import 'package:equatable/equatable.dart';
import 'package:restaurant_admin_dashboard/features/dashboard/data/model/dashboard_model.dart';

sealed class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

final class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

final class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

final class DashboardLoaded extends DashboardState {
  final DashboardModel dashboardModel;

  const DashboardLoaded({
    required this.dashboardModel,
  });

  @override
  List<Object?> get props => [dashboardModel];
}

final class DashboardError extends DashboardState {
  final String message;

  const DashboardError({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}