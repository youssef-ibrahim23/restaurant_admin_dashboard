import 'package:restaurant_admin_dashboard/features/dashboard/domain/repositories/dashboard_repository.dart';

import '../../data/model/dashboard_model.dart';

class DashboardUseCase {

  final DashboardRepository _dashboardRepository;

  const DashboardUseCase({
    required this._dashboardRepository,
  });

  Future<DashboardModel> call() {
    return _dashboardRepository.getDashboard();
  }
}
