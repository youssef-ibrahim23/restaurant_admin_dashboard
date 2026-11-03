import '../../data/model/restaurant_settings_model.dart';
import '../../data/service/settings_service.dart';
import '../../domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsService _settingsService;

  SettingsRepositoryImpl({required SettingsService settingsService})
      : _settingsService = settingsService;

  @override
  Future<RestaurantSettingsModel> getSettings() {
    return _settingsService.getSettings();
  }

  @override
  Future<RestaurantSettingsModel> updateSettings(
      RestaurantSettingsModel settings) {
    return _settingsService.updateSettings(settings);
  }

  @override
  Future<void> changePassword(String newPassword) {
    return _settingsService.changePassword(newPassword);
  }

  @override
  Future<void> logout() {
    return _settingsService.logout();
  }
}
