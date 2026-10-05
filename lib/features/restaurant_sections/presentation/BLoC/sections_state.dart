import 'package:restaurant_admin_dashboard/features/restaurant_sections/data/model/section_model.dart';

sealed class SectionsState {}

final class SectionsInitial extends SectionsState {}

final class SectionsLoading extends SectionsState {}

final class SectionsLoaded extends SectionsState {
  final List<SectionModel> sections;

  SectionsLoaded({required this.sections});
}

final class SectionsError extends SectionsState {
  final String message;

  SectionsError({required this.message});
}

final class SectionActionSuccess extends SectionsState {
  final String message;
  final List<SectionModel> sections;

  SectionActionSuccess({required this.message, required this.sections});
}
