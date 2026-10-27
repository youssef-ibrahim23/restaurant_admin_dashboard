import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_admin_dashboard/features/menu/data/model/menu_item_model.dart';

import 'menu_form_event.dart';
import 'menu_form_state.dart';

class MenuFormBloc extends Bloc<MenuFormEvent, MenuFormState> {
  MenuFormBloc() : super(const MenuFormState()) {
    on<MenuFormReset>((event, emit) => emit(const MenuFormState()));
    on<MenuFormItemSelected>(
      (event, emit) => emit(MenuFormState.fromItem(event.item, event.index)),
    );
    on<MenuFormCategoryChanged>(
      (event, emit) => emit(
        state.copyWith(
          selectedCategory: event.category,
          clearItemToSave: true,
          clearSubmissionError: true,
        ),
      ),
    );
    on<MenuFormAvailabilityChanged>(
      (event, emit) => emit(
        state.copyWith(
          isAvailable: event.isAvailable,
          clearItemToSave: true,
          clearSubmissionError: true,
        ),
      ),
    );
    on<MenuFormPhotoChanged>(
      (event, emit) => emit(
        state.copyWith(
          selectedPhoto: event.photo,
          clearItemToSave: true,
          clearSubmissionError: true,
        ),
      ),
    );
    on<MenuFormNameChanged>(
      (event, emit) => emit(
        state.copyWith(
          name: event.name,
          clearNameError: true,
          clearItemToSave: true,
          clearSubmissionError: true,
        ),
      ),
    );
    on<MenuFormPriceChanged>(
      (event, emit) => emit(
        state.copyWith(
          price: event.price,
          clearPriceError: true,
          clearItemToSave: true,
          clearSubmissionError: true,
        ),
      ),
    );
    on<MenuFormSaveRequested>(_onSaveRequested);
    on<MenuFormSubmissionHandled>(
      (event, emit) => emit(state.copyWith(clearItemToSave: true)),
    );
  }

  void _onSaveRequested(
    MenuFormSaveRequested event,
    Emitter<MenuFormState> emit,
  ) {
    final nameError = state.name.trim().isEmpty
        ? 'Please enter an item name'
        : null;
    final parsedPrice = double.tryParse(state.price.trim());
    final priceError =
        (parsedPrice == null || !parsedPrice.isFinite || parsedPrice < 0)
        ? 'Please enter a valid price'
        : null;

    if (nameError != null || priceError != null) {
      emit(
        state.copyWith(
          nameError: nameError,
          priceError: priceError,
          clearNameError: nameError == null,
          clearPriceError: priceError == null,
          clearItemToSave: true,
          clearSubmissionError: true,
        ),
      );
      return;
    }

    final selectedIndex = state.selectedItemIndex;
    if (selectedIndex != null &&
        (selectedIndex < 0 || selectedIndex >= event.items.length)) {
      emit(
        state.copyWith(
          clearItemToSave: true,
          submissionError: 'The selected menu item is unavailable.',
          clearNameError: true,
          clearPriceError: true,
        ),
      );
      return;
    }

    final existingItem = selectedIndex == null
        ? null
        : event.items[selectedIndex];

    emit(
      state.copyWith(
        nameError: null,
        priceError: null,
        clearNameError: true,
        clearPriceError: true,
        itemToSave: MenuItemModel(
          id: existingItem?.id,
          sectionId: event.sectionId,
          photo: state.selectedPhoto,
          name: state.name.trim(),
          price: parsedPrice!,
          category: state.selectedCategory,
          isAvailable: state.isAvailable,
        ),
        clearSubmissionError: true,
      ),
    );
  }
}
