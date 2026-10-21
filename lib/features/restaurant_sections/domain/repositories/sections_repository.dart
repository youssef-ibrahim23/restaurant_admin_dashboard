
import 'package:restaurant_admin_dashboard/features/restaurant_sections/data/model/section_model.dart';

abstract class SectionsRepository {
  Future<List<SectionModel>> getSections();

  Future<SectionModel> insertSection({
    required SectionModel sectionModel
  });

  Future<SectionModel> updateSection({
    required SectionModel sectionModel
  });

  Future<void> deleteSection({
    required int id,
  });
}