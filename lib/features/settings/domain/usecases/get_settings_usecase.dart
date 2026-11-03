import '../../data/model/restaurant_settings_model.dart';
import '../repositories/settings_repository.dart';

class GetSettingsUseCase {
  final SettingsRepository repository;

  const GetSettingsUseCase({required this.repository});

  Future<RestaurantSettingsModel> call() {
    return repository.getSettings();
  }
}
