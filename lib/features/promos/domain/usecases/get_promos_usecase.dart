import '../../data/model/promos_model.dart';
import '../repositories/promos_repository.dart';

class GetPromosUseCase {
  final PromosRepository promosRepository;

  const GetPromosUseCase({required this.promosRepository});

  Future<List<PromoModel>> call() {
    return promosRepository.getPromos();
  }
}
