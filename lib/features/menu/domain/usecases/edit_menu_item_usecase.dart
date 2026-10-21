import 'package:restaurant_admin_dashboard/features/menu/data/model/menu_item_model.dart';

import '../repositories/menu_repository.dart';

class EditMenuItemUseCase {
  final MenuRepository repository;

  EditMenuItemUseCase({required this.repository});

  Future<MenuItemModel> call({required MenuItemModel menuItem}) async {
    return await repository.editItem(menuItem: menuItem);
  }
}
