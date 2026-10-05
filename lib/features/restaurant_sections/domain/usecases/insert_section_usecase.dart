import 'package:restaurant_admin_dashboard/features/restaurant_sections/data/model/section_model.dart';

import '../repositories/sections_repository.dart';

class InsertSectionUseCase {
  final SectionsRepository repository;

  InsertSectionUseCase({required this.repository});

  Future<SectionModel> call({required SectionModel sectionModel}) async {
    return await repository.insertSection(sectionModel: sectionModel);
  }
}
