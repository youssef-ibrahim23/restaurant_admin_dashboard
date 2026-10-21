
import 'package:equatable/equatable.dart';
import '../../data/model/section_model.dart';

sealed class SectionsEvent extends Equatable {}

final class LoadSections extends SectionsEvent {
  @override
  List<Object?> get props => [];
}

final class AddSection extends SectionsEvent {
  final SectionModel sectionModel;

  AddSection({required this.sectionModel});

  @override
  List<Object?> get props => [sectionModel];
}

final class EditSection extends SectionsEvent {
  final SectionModel sectionModel;

  EditSection({required this.sectionModel});

  @override
  List<Object?> get props => [sectionModel];
}

final class DeleteSection extends SectionsEvent {
  final int id;

  DeleteSection({required this.id});

  @override
  List<Object?> get props => [id];
}

final class ToggleAvailability extends SectionsEvent {
  final SectionModel sectionModel;

  ToggleAvailability({required this.sectionModel});

  @override
  List<Object?> get props => [sectionModel];
}
