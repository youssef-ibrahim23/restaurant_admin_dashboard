class DashboardModel {
  final double revenue;
  final int? totalOrders;
  final Map<String, double> currentWeekDaysRevenue;
  final Map<int, String> liveOrders;

  const DashboardModel({
    required this.revenue,
    this.totalOrders,
    required this.currentWeekDaysRevenue,
    required this.liveOrders,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      revenue: (json['revenue'] as num).toDouble(),
      totalOrders: json['totalOrders'] as int?,
      currentWeekDaysRevenue:
      (json['currentWeekDaysRevenue'] as Map<String, dynamic>).map(
            (key, value) => MapEntry(key, (value as num).toDouble()),
      ),
      liveOrders: (json['liveOrders'] as Map<String, dynamic>).map(
            (key, value) => MapEntry(int.parse(key), value as String),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'revenue': revenue,
      'totalOrders': totalOrders,
      'currentWeekDaysRevenue': currentWeekDaysRevenue,
      'liveOrders': liveOrders.map(
            (key, value) => MapEntry(key.toString(), value),
      ),
    };
  }
}