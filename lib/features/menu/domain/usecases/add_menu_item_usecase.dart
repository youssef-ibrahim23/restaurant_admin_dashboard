import 'package:restaurant_admin_dashboard/features/menu/data/model/menu_item_model.dart';

import '../repositories/menu_repository.dart';

class AddMenuItemUseCase {
  final MenuRepository repository;

  AddMenuItemUseCase({required this.repository});

  Future<MenuItemModel> call({required MenuItemModel menuItem}) async {
    return await repository.addItem(menuItem: menuItem);
  }
}
