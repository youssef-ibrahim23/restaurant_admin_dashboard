import 'package:restaurant_admin_dashboard/features/dashboard/data/model/dashboard_model.dart';

abstract class DashboardRepository {

  Future<DashboardModel> getDashboard();
}