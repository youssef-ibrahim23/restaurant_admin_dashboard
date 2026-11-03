import '../repositories/promos_repository.dart';

class DeletePromoUseCase {
  final PromosRepository promosRepository;

  const DeletePromoUseCase({required this.promosRepository});

  Future<void> call(String promoId) {
    return promosRepository.deletePromo(promoId);
  }
}
