import 'package:restaurant_admin_dashboard/features/menu/data/model/menu_item_model.dart';
import 'package:restaurant_admin_dashboard/features/menu/data/model/menu_model.dart';

abstract class MenuRepository {

  Future<MenuModel> getMenuItems({required int sectionId});

  Future<MenuItemModel> addItem({required MenuItemModel menuItem});

  Future<MenuItemModel> editItem({required MenuItemModel menuItem});

  Future<void> toggleAvailability({required int id, required bool isAvailable});

  Future<void> deleteItem({required int id});

}