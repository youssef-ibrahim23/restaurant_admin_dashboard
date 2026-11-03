import '../../data/model/promos_model.dart';

abstract class PromosRepository {
  Future<List<PromoModel>> getPromos();

  Future<void> addPromo(PromoModel promo);

  Future<void> editPromo(PromoModel promo);

  Future<void> deletePromo(String promoId);
}
