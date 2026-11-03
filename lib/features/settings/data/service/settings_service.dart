import 'package:restaurant_admin_dashboard/core/network/supabase_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/restaurant_settings_model.dart';

class SettingsService {
  final SupabaseClientService _supabaseClientService;
  RestaurantSettingsModel _cachedSettings =
      RestaurantSettingsModel.defaultSettings;

  SettingsService({required SupabaseClientService supabaseClientService})
      : _supabaseClientService = supabaseClientService;

  Future<RestaurantSettingsModel> getSettings() async {
    try {
      final response = await _supabaseClientService.request(
        type: SupabaseRequestType.select,
        table: 'settings',
        orderBy: 'id',
        ascending: true,
      );

      final list = response.data as List;
      if (list.isNotEmpty) {
        _cachedSettings = RestaurantSettingsModel.fromJson(
          Map<String, dynamic>.from(list.first),
        );
      }
    } catch (_) {
    }
    return _cachedSettings;
  }

  Future<RestaurantSettingsModel> updateSettings(
      RestaurantSettingsModel settings) async {
    _cachedSettings = settings;
    try {
      await _supabaseClientService.request(
        type: SupabaseRequestType.update,
        table: 'settings',
        data: settings.toJson(),
        column: 'id',
        value: 1,
      );
    } catch (_) {
      // Local state is preserved in _cachedSettings
    }
    return _cachedSettings;
  }

  Future<void> changePassword(String newPassword) async {
    try {
      await _supabaseClientService.client.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } catch (e) {
      throw Exception('Failed to update password: $e');
    }
  }

  Future<void> logout() async {
    try {
      await _supabaseClientService.client.auth.signOut();
    } catch (e) {
      throw Exception('Failed to logout: $e');
    }
  }
}
