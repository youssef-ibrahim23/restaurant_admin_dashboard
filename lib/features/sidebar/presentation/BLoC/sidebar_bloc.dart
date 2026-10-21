import 'package:flutter_bloc/flutter_bloc.dart';

import 'sidebar_event.dart';
import 'sidebar_state.dart';

class SidebarBloc extends Bloc<SidebarEvent, SidebarState> {
  SidebarBloc() : super(const SidebarState()) {
    on<SidebarItemSelected>(_onSidebarItemSelected);
  }

  void _onSidebarItemSelected(
    SidebarItemSelected event,
    Emitter<SidebarState> emit,
  ) {
    emit(state.copyWith(selectedIndex: event.index));
  }
}
