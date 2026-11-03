import '../../data/model/restaurant_settings_model.dart';

abstract class SettingsRepository {
  Future<RestaurantSettingsModel> getSettings();
  Future<RestaurantSettingsModel> updateSettings(RestaurantSettingsModel settings);
  Future<void> changePassword(String newPassword);
  Future<void> logout();
}
