
import 'package:equatable/equatable.dart';

class DriverModel extends Equatable {
  final int id;
  final String name;

  final double rate;
  final int totalTrips;
  final String status;

  // Driver location
  final double? latitude;
  final double? longitude;
  final double? heading;

  const DriverModel({
    required this.id,
    required this.name,
    required this.rate,
    required this.totalTrips,
    required this.status,
    this.latitude,
    this.longitude,
    this.heading,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    final user = json['users'];

    return DriverModel(
      id: json['id'] as int,

      name: user?['name'] as String? ?? 'Unknown Driver',

      rate: (json['rate'] as num?)?.toDouble() ?? 0.0,

      totalTrips: json['total_trips'] as int? ?? 0,

      status: json['status'] as String,

      latitude: (json['latitude'] as num?)?.toDouble(),

      longitude: (json['longitude'] as num?)?.toDouble(),

      heading: (json['heading'] as num?)?.toDouble(),
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    rate,
    totalTrips,
    status,
    latitude,
    longitude,
    heading,
  ];
}
