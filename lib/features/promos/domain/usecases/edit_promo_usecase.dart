import 'package:restaurant_admin_dashboard/features/promos/domain/repositories/promos_repository.dart';
import '../../data/model/promos_model.dart';

class EditPromoUseCase {
  final PromosRepository promosRepository;

  const EditPromoUseCase({required this.promosRepository});

  Future<void> call(PromoModel promo) {
    return promosRepository.editPromo(promo);
  }
}
