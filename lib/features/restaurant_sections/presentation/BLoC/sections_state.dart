import 'package:restaurant_admin_dashboard/features/restaurant_sections/data/model/section_model.dart';

// TODO: Implement Equatable across all SectionsState subclasses so Bloc can determine value equality.
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

// TODO: Avoid state pollution by separating transient side-effects (e.g. action success toast message) from persistent data state (SectionsLoaded), preventing redundant duplicate data classes.
final class SectionActionSuccess extends SectionsState {
  final String message;
  final List<SectionModel> sections;

  SectionActionSuccess({required this.message, required this.sections});
}
