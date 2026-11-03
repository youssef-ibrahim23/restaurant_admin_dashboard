
import 'package:equatable/equatable.dart';
import 'order_item_model.dart';

class OrderModel extends Equatable {
  final String id;
  final String userId;
  final String userName;
  final double totalPrice;
  final String status;
  final DateTime createdAt;
  final List<OrderItemModel> orderItems;

  const OrderModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    required this.orderItems,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final user = json['users'];
    final orderItemsJson = json['order_items'] as List? ?? [];

    return OrderModel(
      id: json['id'].toString(),
      userId: json['user_id'].toString(),
      userName: user is Map
          ? user['name']?.toString() ?? 'Unknown'
          : 'Unknown',
      totalPrice: (json['total_price'] as num).toDouble(),
      status: json['status']?.toString() ?? '',
      createdAt: DateTime.parse(json['created_at'].toString()),
      orderItems: orderItemsJson
          .map(
            (item) => OrderItemModel.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'total_price': totalPrice,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }

  OrderModel copyWith({
    String? id,
    String? userId,
    String? userName,
    double? totalPrice,
    String? status,
    DateTime? createdAt,
    List<OrderItemModel>? orderItems,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      orderItems: orderItems ?? this.orderItems,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        userName,
        totalPrice,
        status,
        createdAt,
        orderItems,
      ];
}
