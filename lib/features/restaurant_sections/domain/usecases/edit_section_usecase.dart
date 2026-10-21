import 'package:restaurant_admin_dashboard/features/restaurant_sections/data/model/section_model.dart';

import '../repositories/sections_repository.dart';

class EditSectionUseCase {
  final SectionsRepository repository;

  EditSectionUseCase({required this.repository});

  Future<SectionModel> call({required SectionModel sectionModel}) async {
    return await repository.updateSection(sectionModel: sectionModel);
  }
}
