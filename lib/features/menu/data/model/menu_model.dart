import 'package:restaurant_admin_dashboard/features/menu/data/model/menu_item_model.dart';

class MenuModel {
  final List<MenuItemModel> items;

  const MenuModel({
    required this.items,
  });

  factory MenuModel.fromJson(List<dynamic> json) {
    return MenuModel(
      items: json
          .map(
            (item) => MenuItemModel.fromJson(
          Map<String, dynamic>.from(item),
        ),
      )
          .toList(),
    );
  }

  List<Map<String, dynamic>> toJson() {
    return items
        .map((item) => item.toJson())
        .toList();
  }
}