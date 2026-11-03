import 'package:equatable/equatable.dart';
import '../../data/model/restaurant_settings_model.dart';

sealed class SettingsEvent extends Equatable {}

final class LoadSettings extends SettingsEvent {
  @override
  List<Object?> get props => [];
}

final class UpdateSettings extends SettingsEvent {
  final RestaurantSettingsModel settings;

  UpdateSettings({required this.settings});

  @override
  List<Object?> get props => [settings];
}

final class ToggleAutoAcceptOrders extends SettingsEvent {
  final bool value;
  ToggleAutoAcceptOrders({required this.value});
  @override
  List<Object?> get props => [value];
}

final class ToggleSoundNotifications extends SettingsEvent {
  final bool value;
  ToggleSoundNotifications({required this.value});
  @override
  List<Object?> get props => [value];
}

final class TogglePushNotifications extends SettingsEvent {
  final bool value;
  TogglePushNotifications({required this.value});
  @override
  List<Object?> get props => [value];
}

final class ToggleDeliveryService extends SettingsEvent {
  final bool value;
  ToggleDeliveryService({required this.value});
  @override
  List<Object?> get props => [value];
}

final class ToggleDineInService extends SettingsEvent {
  final bool value;
  ToggleDineInService({required this.value});
  @override
  List<Object?> get props => [value];
}

final class ChangePasswordEvent extends SettingsEvent {
  final String newPassword;
  ChangePasswordEvent({required this.newPassword});
  @override
  List<Object?> get props => [newPassword];
}

final class LogoutEvent extends SettingsEvent {
  @override
  List<Object?> get props => [];
}
