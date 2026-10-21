import 'package:restaurant_admin_dashboard/features/restaurant_sections/domain/repositories/sections_repository.dart';

import '../model/section_model.dart';
import '../service/sections_service.dart';

class SectionsRepositoryImpl implements SectionsRepository {
  final SectionsService sectionsService;

  SectionsRepositoryImpl({required this.sectionsService});

  @override
  Future<List<SectionModel>> getSections() async {
    return await sectionsService.getSections();
  }

  @override
  Future<SectionModel> insertSection({
    required SectionModel sectionModel,
  }) async {
    return await sectionsService.insertSection(sectionModel: sectionModel);
  }

  @override
  Future<SectionModel> updateSection({
    required SectionModel sectionModel,
  }) async {
    return await sectionsService.updateSection(sectionModel: sectionModel);
  }

  @override
  Future<void> deleteSection({required int id}) async {
    await sectionsService.deleteSection(id: id);
  }
}
