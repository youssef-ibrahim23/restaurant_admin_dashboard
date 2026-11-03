import '../repositories/settings_repository.dart';

class ChangePasswordUseCase {
  final SettingsRepository repository;

  const ChangePasswordUseCase({required this.repository});

  Future<void> call(String newPassword) {
    return repository.changePassword(newPassword);
  }
}
