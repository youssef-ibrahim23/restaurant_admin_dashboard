import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/domain/usecases/delete_section_usecase.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/domain/usecases/edit_section_usecase.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/domain/usecases/get_sections_usecase.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/domain/usecases/insert_section_usecase.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/presentation/BLoC/sections_event.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/presentation/BLoC/sections_state.dart';

class SectionsBloc extends Bloc<SectionsEvent, SectionsState> {
  final GetSectionsUseCase getSectionsUseCase;
  final InsertSectionUseCase insertSectionUseCase;
  final EditSectionUseCase editSectionUseCase;
  final DeleteSectionUseCase deleteSectionUseCase;

  SectionsBloc({
    required this.getSectionsUseCase,
    required this.insertSectionUseCase,
    required this.editSectionUseCase,
    required this.deleteSectionUseCase,
  }) :
       super(const SectionsInitial()) {
    on<LoadSections>(_onLoadSections);
    on<AddSection>(_onAddSection);
    on<EditSection>(_onEditSection);
    on<DeleteSection>(_onDeleteSection);
    on<ToggleAvailability>(_onToggleAvailability);
  }

  Future<void> _onLoadSections(
    LoadSections event,
    Emitter<SectionsState> emit,
  ) async {
    emit(const SectionsLoading());
    try {
      final sections = await getSectionsUseCase();
      emit(SectionsLoaded(sections: sections));
    } catch (e) {
      emit(SectionsError(message: e.toString(), sections: state.sections));
    }
  }

  Future<void> _onAddSection(
    AddSection event,
    Emitter<SectionsState> emit,
  ) async {
    final currentSections = state.sections;

    try {
      final createdSection = await insertSectionUseCase(sectionModel: event.sectionModel);
      final sections = [...currentSections, createdSection];
      emit(
        SectionActionSuccess(
          message: 'Section added successfully',
          sections: sections,
        ),
      );
    } catch (e) {
      emit(SectionsError(message: e.toString(), sections: currentSections, isActionError: true));
    }
  }

  Future<void> _onEditSection(
    EditSection event,
    Emitter<SectionsState> emit,
  ) async {
    final currentSections = state.sections;

    try {
      await editSectionUseCase(sectionModel: event.sectionModel);
      final sections = currentSections.map((section) {
        return section.id == event.sectionModel.id ? event.sectionModel : section;
      }).toList();
      emit(
        SectionActionSuccess(
          message: 'Section updated successfully',
          sections: sections,
        ),
      );
    } catch (e) {
      emit(SectionsError(message: e.toString(), sections: currentSections, isActionError: true));
    }
  }

  Future<void> _onDeleteSection(
    DeleteSection event,
    Emitter<SectionsState> emit,
  ) async {
    final currentSections = state.sections;

    try {
      await deleteSectionUseCase(id: event.id);
      final sections = currentSections.where((section) => section.id != event.id).toList();
      emit(
        SectionActionSuccess(
          message: 'Section deleted successfully',
          sections: sections,
        ),
      );
    } catch (e) {
      emit(SectionsError(message: e.toString(), sections: currentSections, isActionError: true));
    }
  }

  Future<void> _onToggleAvailability(
    ToggleAvailability event,
    Emitter<SectionsState> emit,
  ) async {
    final currentSections = state.sections;

    try {
      await editSectionUseCase(sectionModel: event.sectionModel);
      final updatedSections = currentSections.map((section) {
        return section.id == event.sectionModel.id ? event.sectionModel : section;
      }).toList();
      emit(
        SectionActionSuccess(
          message: 'Section availability updated',
          sections: updatedSections,
        ),
      );
    } catch (e) {
      emit(SectionsError(message: e.toString(), sections: currentSections, isActionError: true));
    }
  }
}
