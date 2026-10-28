import 'package:restaurant_admin_dashboard/features/dashboard/data/service/dashboard_service.dart';
import 'package:restaurant_admin_dashboard/features/dashboard/domain/repositories/dashboard_repository.dart';

import '../model/dashboard_model.dart';

class DashboardRepositoryImpl implements DashboardRepository {

  final DashboardService _dashboardService;

  const DashboardRepositoryImpl({
    required this._dashboardService,
  });

  @override
  Future<DashboardModel> getDashboard() {
    return _dashboardService.getDashboardData();
  }
}