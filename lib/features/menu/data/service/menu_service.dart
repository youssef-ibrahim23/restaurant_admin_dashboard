import '../../../../core/network/supabase_client.dart';
import '../model/menu_item_model.dart';
import '../model/menu_model.dart';

class MenuService {
  final SupabaseClientService supabaseClientService;

  MenuService({required this.supabaseClientService,});

  static const String _table = 'menu_items';

  Future<MenuModel> getMenuItems({
    required int sectionId,
  }) async {
    final response = await supabaseClientService.request(
      type: SupabaseRequestType.select,
      table: _table,
      filters: {
        'section_id': sectionId,
      },
      orderBy: 'id',
      ascending: true,
    );

    return MenuModel.fromJson(response.data);
  }

  Future<MenuItemModel> addItem({
    required MenuItemModel menuItem,
  }) async {
    final response = await supabaseClientService.request(
      type: SupabaseRequestType.insert,
      table: _table,
      data: menuItem.toJson(),
    );

    return MenuItemModel.fromJson(response.data);
  }

  Future<MenuItemModel> editItem({
    required MenuItemModel menuItem,
  }) async {
    if (menuItem.id == null) {
      throw ArgumentError(
        'MenuItem id cannot be null for edit operation',
      );
    }

    final response = await supabaseClientService.request(
      type: SupabaseRequestType.update,
      table: _table,
      data: menuItem.toJson(),
      column: 'id',
      value: menuItem.id,
    );

    return MenuItemModel.fromJson(response.data);
  }

  Future<void> toggleAvailability({
    required int id,
    required bool isAvailable,
  }) async {
    await supabaseClientService.request(
      type: SupabaseRequestType.update,
      table: _table,
      data: {
        'is_available': isAvailable,
      },
      column: 'id',
      value: id,
    );
  }

  Future<void> deleteItem({
    required int id,
  }) async {
    await supabaseClientService.request(
      type: SupabaseRequestType.delete,
      table: _table,
      column: 'id',
      value: id,
    );
  }
}