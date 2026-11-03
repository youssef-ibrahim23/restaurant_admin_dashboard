import 'package:restaurant_admin_dashboard/features/promos/data/model/promos_model.dart';
import 'package:restaurant_admin_dashboard/features/promos/data/service/promo_service.dart';
import 'package:restaurant_admin_dashboard/features/promos/domain/repositories/promos_repository.dart';

class PromoRepositoryImpl implements PromosRepository {
  final PromoService _promoService;

  const PromoRepositoryImpl({required PromoService promoService})
      : _promoService = promoService;

  @override
  Future<void> addPromo(PromoModel promo) async {
    await _promoService.addPromo(promo);
  }

  @override
  Future<void> deletePromo(String promoId) async {
    await _promoService.deletePromo(promoId);
  }

  @override
  Future<void> editPromo(PromoModel promo) async {
    await _promoService.updatePromo(promo);
  }

  @override
  Future<List<PromoModel>> getPromos() async {
    return await _promoService.getPromo();
  }
}
