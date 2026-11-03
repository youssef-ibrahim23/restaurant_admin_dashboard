import 'package:restaurant_admin_dashboard/features/promos/domain/repositories/promos_repository.dart';
import '../../data/model/promos_model.dart';

class AddPromoUseCase {
  final PromosRepository promosRepository;

  const AddPromoUseCase({required this.promosRepository});

  Future<void> call(PromoModel promo) {
    return promosRepository.addPromo(promo);
  }
}
