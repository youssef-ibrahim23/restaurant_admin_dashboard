import '../../data/model/restaurant_settings_model.dart';
import '../repositories/settings_repository.dart';

class UpdateSettingsUseCase {
  final SettingsRepository repository;

  const UpdateSettingsUseCase({required this.repository});

  Future<RestaurantSettingsModel> call(RestaurantSettingsModel settings) {
    return repository.updateSettings(settings);
  }
}
