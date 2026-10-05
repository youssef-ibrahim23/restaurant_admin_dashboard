import 'package:flutter_bloc/flutter_bloc.dart';

import 'sidebar_event.dart';
import 'sidebar_state.dart';

class SidebarBloc extends Bloc<SidebarEvent, SidebarState> {
  SidebarBloc() : super(const SidebarState()) {

    on<SidebarItemSelected>((_onSidebarItemSelected));

    on<SectionMenuSelected>(_onSectionMenuSelected);

    on<SectionMenuBack>(_onSectionMenuBack);

  }

  void _onSidebarItemSelected(
    SidebarItemSelected event,
    Emitter<SidebarState> emit,
  ) {
    emit(state.copyWith(selectedIndex: event.index));
  }

  void _onSectionMenuSelected(
    SectionMenuSelected event,
    Emitter<SidebarState> emit,
  ) {
    emit(state.copyWith(selectedSection: event.section));
  }

  void _onSectionMenuBack(SectionMenuBack event, Emitter<SidebarState> emit) {
    emit(state.copyWith(clearSelectedSection: true));
  }
}
