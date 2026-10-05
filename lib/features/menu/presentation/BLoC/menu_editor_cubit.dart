import 'package:flutter_bloc/flutter_bloc.dart';

import 'menu_editor_state.dart';

class MenuEditorCubit extends Cubit<MenuEditorState> {
  MenuEditorCubit() : super(const MenuEditorState());

  void selectItem({
    required int index,
    required String category,
    required bool isAvailable,
    required String photo,
  }) {
    emit(
      state.copyWith(
        selectedItemIndex: index,
        selectedCategory: category,
        isAvailable: isAvailable,
        selectedPhoto: photo,
      ),
    );
  }

  void selectCategory(String category) {
    emit(state.copyWith(selectedCategory: category));
  }

  void setAvailability(bool isAvailable) {
    emit(state.copyWith(isAvailable: isAvailable));
  }

  void selectPhoto(String photo) {
    emit(state.copyWith(selectedPhoto: photo));
  }

  void clear() {
    emit(const MenuEditorState());
  }
}
