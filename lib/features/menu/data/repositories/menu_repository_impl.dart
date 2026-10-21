import 'package:restaurant_admin_dashboard/features/menu/domain/repositories/menu_repository.dart';

import '../model/menu_item_model.dart';
import '../model/menu_model.dart';
import '../service/menu_service.dart';

class MenuRepositoryImpl implements MenuRepository {
  final MenuService menuService;

  MenuRepositoryImpl({required this.menuService});

  @override
  Future<MenuModel> getMenuItems({required int sectionId}) async {
    return await menuService.getMenuItems(sectionId: sectionId);
  }

  @override
  Future<MenuItemModel> addItem({required MenuItemModel menuItem}) async {
    return await menuService.addItem(menuItem: menuItem);
  }

  @override
  Future<MenuItemModel> editItem({required MenuItemModel menuItem}) async {
    return await menuService.editItem(menuItem: menuItem);
  }

  @override
  Future<void> toggleAvailability({
    required int id,
    required bool isAvailable,
  }) async {
    await menuService.toggleAvailability(id: id, isAvailable: isAvailable);
  }

  @override
  Future<void> deleteItem({required int id}) async {
    await menuService.deleteItem(id: id);
  }
}
