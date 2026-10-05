import '../repositories/menu_repository.dart';

class ToggleMenuItemAvailabilityUseCase {
  final MenuRepository repository;

  ToggleMenuItemAvailabilityUseCase({required this.repository});

  Future<void> call({required int id, required bool isAvailable}) async {
    await repository.toggleAvailability(id: id, isAvailable: isAvailable);
  }
}
