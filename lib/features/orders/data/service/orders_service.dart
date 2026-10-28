import 'package:restaurant_admin_dashboard/core/network/supabase_client.dart';
import 'package:restaurant_admin_dashboard/features/orders/data/model/order_model.dart';

class OrdersService {
  final SupabaseClientService _supabaseClientService;

  const OrdersService({
    required this._supabaseClientService,
  });

  Future<List<OrderModel>> getOrders() async {
    final response = await _supabaseClientService.request(
      type: SupabaseRequestType.select,
      table: 'orders',
      select: '''
        id,
        user_id,
        total_price,
        status,
        created_at,

        users (
          name
        ),

        order_items (
          id,
          order_id,
          menu_item_id,
          quantity,
          unit_price,
          created_at,

          menu_items (
            id,
            section_id,
            photo,
            name,
            price,
            category,
            is_available
          )
        )
      ''',
      orderBy: 'created_at',
      ascending: false,
    );

    final rows = List<Map<String, dynamic>>.from(
      response.data,
    );

    return rows
        .map(
          (row) => OrderModel.fromJson(row),
    )
        .toList(growable: false);
  }

  Future<void> updateStatus(String id, String status) async{
    await _supabaseClientService.request(
      type: SupabaseRequestType.update,
      table: 'orders',
      data: {
        'status': status,
      },
      column: 'id',
      value: id,
    );
  }
}