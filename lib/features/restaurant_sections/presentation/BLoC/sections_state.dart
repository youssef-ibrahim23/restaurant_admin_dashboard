import 'package:equatable/equatable.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/data/model/section_model.dart';

// Base class containing persistent data state (sections list)
sealed class SectionsState extends Equatable {
  final List<SectionModel> sections;
  final bool isLoading;

  const SectionsState({
    this.sections = const [],
    this.isLoading = false,
  });

  @override
  List<Object?> get props => [sections, isLoading];
}

final class SectionsInitial extends SectionsState {
  const SectionsInitial();
}

final class SectionsLoading extends SectionsState {
  const SectionsLoading({
    super.sections,
  }) : super(isLoading: true);
}

final class SectionsLoaded extends SectionsState {
  const SectionsLoaded({
    required super.sections,
  });
}

final class SectionsError extends SectionsState {
  final String message;

  const SectionsError({
    required this.message,
    super.sections,
  });

  @override
  List<Object?> get props => [...super.props, message];
}

final class SectionActionSuccess extends SectionsState {
  final String message;

  const SectionActionSuccess({
    required this.message,
    required super.sections,
  });

  @override
  List<Object?> get props => [...super.props, message];
}
