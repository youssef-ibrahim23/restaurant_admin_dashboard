import '../repositories/sections_repository.dart';

class DeleteSectionUseCase {
  final SectionsRepository repository;

  DeleteSectionUseCase({required this.repository});

  Future<void> call({required int id}) async {
    await repository.deleteSection(id: id);
  }
}
