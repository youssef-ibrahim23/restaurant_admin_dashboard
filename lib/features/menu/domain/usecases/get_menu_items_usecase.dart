import 'package:restaurant_admin_dashboard/features/menu/data/model/menu_model.dart';

import '../repositories/menu_repository.dart';

class GetMenuItemsUseCase {
  final MenuRepository repository;

  GetMenuItemsUseCase({required this.repository});

  Future<MenuModel> call({required int sectionId}) async {
    return await repository.getMenuItems(sectionId: sectionId);
  }
}
