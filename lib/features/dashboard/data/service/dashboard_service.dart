import '../../../../core/network/supabase_client.dart';
import '../model/dashboard_model.dart';

class DashboardService {
  final SupabaseClientService _supabaseClientService;

  const DashboardService({
    required this._supabaseClientService,
  });

  Future<DashboardModel> getDashboardData() async {

    // Fetch all orders
    final ordersResponse = await _supabaseClientService.client
        .from('orders')
        .select('id, total_price, status, created_at');

    final orders = List<Map<String, dynamic>>.from(ordersResponse);

    // Calculate total revenue
    final double revenue = orders.fold<double>(
      0.0,
          (sum, order) {
        final status = order['status']?.toString().toLowerCase();

        // Exclude cancelled orders from revenue
        if (status == 'cancelled') return sum;

        return sum + ((order['total_price'] as num?)?.toDouble() ?? 0.0);
      },
    );

    // Total number of orders
    final int totalOrders = orders.length;

    // Calculate revenue for the current week
    final now = DateTime.now();
    final startOfWeek = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday % 7));

    final Map<String, double> currentWeekDaysRevenue = {
      'Sun': 0.0,
      'Mon': 0.0,
      'Tue': 0.0,
      'Wed': 0.0,
      'Thu': 0.0,
      'Fri': 0.0,
      'Sat': 0.0,
    };

    for (final order in orders) {
      final createdAt = DateTime.tryParse(
        order['created_at']?.toString() ?? '',
      );

      if (createdAt == null ||
          createdAt.isBefore(startOfWeek) ||
          createdAt.isAfter(now)) {
        continue;
      }

      final status = order['status']?.toString().toLowerCase();
      if (status == 'cancelled') continue;

      final dayName = _dayName(createdAt.weekday);

      currentWeekDaysRevenue[dayName] =
          currentWeekDaysRevenue[dayName]! +
              ((order['total_price'] as num?)?.toDouble() ?? 0.0);
    }

    // Fetch live orders (exclude delivered and cancelled orders)
    final liveOrdersResponse = await _supabaseClientService.client
        .from('orders')
        .select('id, status')
        .neq('status', 'Cancelled')
        .neq('status', 'Delivered')
        .order('created_at', ascending: false);

    final liveOrdersList =
    List<Map<String, dynamic>>.from(liveOrdersResponse);

    final Map<int, String> liveOrders = {
      for (final order in liveOrdersList)
        (order['id'] as num).toInt(): order['status'].toString(),
    };

    return DashboardModel(
      revenue: revenue,
      totalOrders: totalOrders,
      currentWeekDaysRevenue: currentWeekDaysRevenue,
      liveOrders: liveOrders,
    );
  }

  String _dayName(int weekday) {
    const days = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];

    return days[weekday - 1];
  }
}