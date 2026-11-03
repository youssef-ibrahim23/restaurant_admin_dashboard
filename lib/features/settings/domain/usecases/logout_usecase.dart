import '../repositories/settings_repository.dart';

class LogoutUseCase {
  final SettingsRepository repository;

  const LogoutUseCase({required this.repository});

  Future<void> call() {
    return repository.logout();
  }
}
