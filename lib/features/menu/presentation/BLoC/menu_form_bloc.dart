import 'package:flutter_bloc/flutter_bloc.dart';

import 'menu_form_event.dart';
import 'menu_form_state.dart';

class MenuFormBloc extends Bloc<MenuFormEvent, MenuFormState> {
  MenuFormBloc() : super(const MenuFormState()) {
    on<MenuFormReset>((event, emit) => emit(const MenuFormState()));
    on<MenuFormItemSelected>(
      (event, emit) => emit(MenuFormState.fromItem(event.item, event.index)),
    );
    on<MenuFormCategoryChanged>(
      (event, emit) => emit(state.copyWith(selectedCategory: event.category)),
    );
    on<MenuFormAvailabilityChanged>(
      (event, emit) => emit(state.copyWith(isAvailable: event.isAvailable)),
    );
    on<MenuFormPhotoChanged>(
      (event, emit) => emit(state.copyWith(selectedPhoto: event.photo)),
    );
    on<MenuFormNameChanged>(
      (event, emit) =>
          emit(state.copyWith(name: event.name, clearNameError: true)),
    );
    on<MenuFormPriceChanged>(
      (event, emit) =>
          emit(state.copyWith(price: event.price, clearPriceError: true)),
    );
    on<MenuFormValidationFailed>(
      (event, emit) => emit(
        state.copyWith(
          nameError: event.nameError,
          priceError: event.priceError,
          clearNameError: event.nameError == null,
          clearPriceError: event.priceError == null,
        ),
      ),
    );
  }
}
