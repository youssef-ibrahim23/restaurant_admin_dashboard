import '../../../menu/data/model/menu_item_model.dart';

class OrderItemModel {
  final String id;
  final String orderId;
  final String menuItemId;
  final int quantity;
  final double unitPrice;
  final DateTime createdAt;
  final MenuItemModel menuItem;

  const OrderItemModel({
    required this.id,
    required this.orderId,
    required this.menuItemId,
    required this.quantity,
    required this.unitPrice,
    required this.createdAt,
    required this.menuItem,
  });

  factory OrderItemModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final menuItem = json['menu_items'];

    return OrderItemModel(
      id: json['id'].toString(),

      orderId: json['order_id'].toString(),

      menuItemId: json['menu_item_id'].toString(),

      quantity: (json['quantity'] as num).toInt(),

      unitPrice: (json['unit_price'] as num).toDouble(),

      createdAt: DateTime.parse(
        json['created_at'].toString(),
      ),

      menuItem: menuItem is Map
          ? MenuItemModel.fromJson(
        Map<String, dynamic>.from(menuItem),
      )
          : throw const FormatException(
        'Menu item data is missing from order item.',
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'menu_item_id': menuItemId,
      'quantity': quantity,
      'unit_price': unitPrice,
      'created_at': createdAt.toIso8601String(),
    };
  }
}