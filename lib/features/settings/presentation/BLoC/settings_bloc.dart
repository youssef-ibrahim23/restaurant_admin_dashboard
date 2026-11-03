import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/change_password_usecase.dart';
import '../../domain/usecases/get_settings_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/update_settings_usecase.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetSettingsUseCase getSettingsUseCase;
  final UpdateSettingsUseCase updateSettingsUseCase;
  final ChangePasswordUseCase changePasswordUseCase;
  final LogoutUseCase logoutUseCase;

  SettingsBloc({
    required this.getSettingsUseCase,
    required this.updateSettingsUseCase,
    required this.changePasswordUseCase,
    required this.logoutUseCase,
  }) : super(const SettingsInitial()) {
    on<LoadSettings>(_onLoadSettings);
    on<UpdateSettings>(_onUpdateSettings);
    on<ToggleAutoAcceptOrders>(_onToggleAutoAccept);
    on<ToggleSoundNotifications>(_onToggleSound);
    on<TogglePushNotifications>(_onTogglePush);
    on<ToggleDeliveryService>(_onToggleDelivery);
    on<ToggleDineInService>(_onToggleDineIn);
    on<ChangePasswordEvent>(_onChangePassword);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onLoadSettings(
    LoadSettings event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading(settings: state.settings));
    try {
      final settings = await getSettingsUseCase();
      emit(SettingsLoaded(settings: settings));
    } catch (e) {
      emit(SettingsError(message: e.toString(), settings: state.settings));
    }
  }

  Future<void> _onUpdateSettings(
    UpdateSettings event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      final updated = await updateSettingsUseCase(event.settings);
      emit(SettingsActionSuccess(
        message: 'Settings updated successfully',
        settings: updated,
      ));
    } catch (e) {
      emit(SettingsError(
        message: e.toString(),
        settings: state.settings,
        isActionError: true,
      ));
    }
  }

  Future<void> _onToggleAutoAccept(
    ToggleAutoAcceptOrders event,
    Emitter<SettingsState> emit,
  ) async {
    final newSettings =
        state.settings.copyWith(autoAcceptOrders: event.value);
    await _saveToggle(newSettings, 'Auto-accept orders updated', emit);
  }

  Future<void> _onToggleSound(
    ToggleSoundNotifications event,
    Emitter<SettingsState> emit,
  ) async {
    final newSettings =
        state.settings.copyWith(soundNotifications: event.value);
    await _saveToggle(newSettings, 'Sound notifications updated', emit);
  }

  Future<void> _onTogglePush(
    TogglePushNotifications event,
    Emitter<SettingsState> emit,
  ) async {
    final newSettings =
        state.settings.copyWith(pushNotifications: event.value);
    await _saveToggle(newSettings, 'Push notifications updated', emit);
  }

  Future<void> _onToggleDelivery(
    ToggleDeliveryService event,
    Emitter<SettingsState> emit,
  ) async {
    final newSettings =
        state.settings.copyWith(deliveryServiceActive: event.value);
    await _saveToggle(newSettings, 'Delivery service updated', emit);
  }

  Future<void> _onToggleDineIn(
    ToggleDineInService event,
    Emitter<SettingsState> emit,
  ) async {
    final newSettings = state.settings.copyWith(dineInActive: event.value);
    await _saveToggle(newSettings, 'Dine-in status updated', emit);
  }

  Future<void> _saveToggle(
    dynamic newSettings,
    String message,
    Emitter<SettingsState> emit,
  ) async {
    try {
      final updated = await updateSettingsUseCase(newSettings);
      emit(SettingsActionSuccess(message: message, settings: updated));
    } catch (e) {
      emit(SettingsError(
        message: e.toString(),
        settings: state.settings,
        isActionError: true,
      ));
    }
  }

  Future<void> _onChangePassword(
    ChangePasswordEvent event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      await changePasswordUseCase(event.newPassword);
      emit(SettingsActionSuccess(
        message: 'Password changed successfully',
        settings: state.settings,
      ));
    } catch (e) {
      emit(SettingsError(
        message: e.toString(),
        settings: state.settings,
        isActionError: true,
      ));
    }
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      await logoutUseCase();
      emit(LogoutSuccess(settings: state.settings));
    } catch (e) {
      emit(SettingsError(
        message: e.toString(),
        settings: state.settings,
        isActionError: true,
      ));
    }
  }
}
