import '../repositories/menu_repository.dart';

class DeleteMenuItemUseCase {
  final MenuRepository repository;

  DeleteMenuItemUseCase({required this.repository});

  Future<void> call({required int id}) async {
    await repository.deleteItem(id: id);
  }
}
