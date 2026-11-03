import 'package:restaurant_admin_dashboard/core/network/supabase_client.dart';
import 'package:restaurant_admin_dashboard/features/promos/data/model/promos_model.dart';

class PromoService {
  final SupabaseClientService _supabaseClientService;

  const PromoService({required SupabaseClientService supabaseClientService})
      : _supabaseClientService = supabaseClientService;

  Future<List<PromoModel>> getPromo() async {
    final response = await _supabaseClientService.request(
      type: SupabaseRequestType.select,
      table: 'promos',
      orderBy: 'created_at',
      ascending: false,
    );

    return (response.data as List)
        .map((json) => PromoModel.fromJson(
              Map<String, dynamic>.from(json),
            ))
        .toList();
  }

  Future<void> addPromo(PromoModel promoModel) async {
    try {
      await _supabaseClientService.request(
        type: SupabaseRequestType.insert,
        table: 'promos',
        data: promoModel.toJson(),
      );
    } catch (e) {
      throw Exception('Failed to add promo: $e');
    }
  }

  Future<void> updatePromo(PromoModel promoModel) async {
    try {
      await _supabaseClientService.request(
        type: SupabaseRequestType.update,
        table: 'promos',
        data: {
          'code': promoModel.code,
          'discount': promoModel.discount,
          'status': promoModel.status,
        },
        column: 'id',
        value: promoModel.id,
      );
    } catch (e) {
      throw Exception('Failed to update promo: $e');
    }
  }

  Future<void> deletePromo(String id) async {
    try {
      await _supabaseClientService.request(
        type: SupabaseRequestType.delete,
        table: 'promos',
        column: 'id',
        value: id,
      );
    } catch (e) {
      throw Exception('Failed to delete promo: $e');
    }
  }
}
