import 'package:restaurant_admin_dashboard/features/restaurant_sections/data/model/section_model.dart';

import '../repositories/sections_repository.dart';

class GetSectionsUseCase {
  final SectionsRepository repository;

  GetSectionsUseCase({required this.repository});

  Future<List<SectionModel>> call() async {
    return await repository.getSections();
  }
}
