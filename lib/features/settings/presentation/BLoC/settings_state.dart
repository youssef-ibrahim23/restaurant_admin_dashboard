import 'package:equatable/equatable.dart';
import '../../data/model/restaurant_settings_model.dart';

sealed class SettingsState extends Equatable {
  final RestaurantSettingsModel settings;
  final bool isLoading;

  const SettingsState({
    this.settings = RestaurantSettingsModel.defaultSettings,
    this.isLoading = false,
  });

  @override
  List<Object?> get props => [settings, isLoading];
}

final class SettingsInitial extends SettingsState {
  const SettingsInitial() : super();
}

final class SettingsLoading extends SettingsState {
  const SettingsLoading({super.settings}) : super(isLoading: true);
}

final class SettingsLoaded extends SettingsState {
  const SettingsLoaded({required super.settings});
}

final class SettingsError extends SettingsState {
  final String message;
  final bool isActionError;

  const SettingsError({
    required this.message,
    super.settings,
    this.isActionError = false,
  });

  @override
  List<Object?> get props => [...super.props, message, isActionError];
}

final class SettingsActionSuccess extends SettingsState {
  final String message;

  const SettingsActionSuccess({
    required this.message,
    required super.settings,
  });

  @override
  List<Object?> get props => [...super.props, message];
}

final class LogoutSuccess extends SettingsState {
  const LogoutSuccess({super.settings});
}
