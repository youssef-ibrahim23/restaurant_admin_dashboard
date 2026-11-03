import 'package:equatable/equatable.dart';

class RestaurantSettingsModel extends Equatable {
  final String restaurantName;
  final String email;
  final String phone;
  final String address;
  final String openingHours;
  final String currency;

  // Operational preferences
  final bool autoAcceptOrders;
  final bool soundNotifications;
  final bool pushNotifications;
  final bool deliveryServiceActive;
  final bool dineInActive;

  const RestaurantSettingsModel({
    required this.restaurantName,
    required this.email,
    required this.phone,
    required this.address,
    required this.openingHours,
    required this.currency,
    required this.autoAcceptOrders,
    required this.soundNotifications,
    required this.pushNotifications,
    required this.deliveryServiceActive,
    required this.dineInActive,
  });

  static const defaultSettings = RestaurantSettingsModel(
    restaurantName: 'Burger Lab',
    email: 'admin@burgerlab.com',
    phone: '+20 100 123 4567',
    address: 'Road 90, New Cairo, Egypt',
    openingHours: '10:00 AM - 02:00 AM',
    currency: 'EGP',
    autoAcceptOrders: true,
    soundNotifications: true,
    pushNotifications: true,
    deliveryServiceActive: true,
    dineInActive: true,
  );

  RestaurantSettingsModel copyWith({
    String? restaurantName,
    String? email,
    String? phone,
    String? address,
    String? openingHours,
    String? currency,
    double? taxRate,
    bool? autoAcceptOrders,
    bool? soundNotifications,
    bool? pushNotifications,
    bool? deliveryServiceActive,
    bool? dineInActive,
  }) {
    return RestaurantSettingsModel(
      restaurantName: restaurantName ?? this.restaurantName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      openingHours: openingHours ?? this.openingHours,
      currency: currency ?? this.currency,
      autoAcceptOrders: autoAcceptOrders ?? this.autoAcceptOrders,
      soundNotifications: soundNotifications ?? this.soundNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      deliveryServiceActive:
          deliveryServiceActive ?? this.deliveryServiceActive,
      dineInActive: dineInActive ?? this.dineInActive,
    );
  }

  factory RestaurantSettingsModel.fromJson(Map<String, dynamic> json) {
    return RestaurantSettingsModel(
      restaurantName: json['restaurant_name']?.toString() ?? 'Burger Lab',
      email: json['email']?.toString() ?? 'admin@burgerlab.com',
      phone: json['phone']?.toString() ?? '+20 100 123 4567',
      address: json['address']?.toString() ?? 'Road 90, New Cairo, Egypt',
      openingHours:
          json['opening_hours']?.toString() ?? '10:00 AM - 02:00 AM',
      currency: json['currency']?.toString() ?? 'EGP',
      autoAcceptOrders: json['auto_accept_orders'] as bool? ?? true,
      soundNotifications: json['sound_notifications'] as bool? ?? true,
      pushNotifications: json['push_notifications'] as bool? ?? true,
      deliveryServiceActive:
          json['delivery_service_active'] as bool? ?? true,
      dineInActive: json['dine_in_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'restaurant_name': restaurantName,
      'email': email,
      'phone': phone,
      'address': address,
      'opening_hours': openingHours,
      'currency': currency,
      'auto_accept_orders': autoAcceptOrders,
      'sound_notifications': soundNotifications,
      'push_notifications': pushNotifications,
      'delivery_service_active': deliveryServiceActive,
      'dine_in_active': dineInActive,
    };
  }

  @override
  List<Object?> get props => [
        restaurantName,
        email,
        phone,
        address,
        openingHours,
        currency,
        autoAcceptOrders,
        soundNotifications,
        pushNotifications,
        deliveryServiceActive,
        dineInActive,
      ];
}
