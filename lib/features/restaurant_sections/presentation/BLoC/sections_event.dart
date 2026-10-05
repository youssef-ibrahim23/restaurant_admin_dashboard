
import '../../data/model/section_model.dart';

sealed class SectionsEvent {}

final class LoadSections extends SectionsEvent {}

final class AddSection extends SectionsEvent {
  final SectionModel sectionModel;

  AddSection({required this.sectionModel });
}

final class EditSection extends SectionsEvent {
  final SectionModel sectionModel;

  EditSection({required this.sectionModel});
}

final class DeleteSection extends SectionsEvent {
  final int id;

  DeleteSection({required this.id});
}

final class ToggleAvailability extends SectionsEvent {
  final SectionModel sectionModel;

  ToggleAvailability({required this.sectionModel});
}
