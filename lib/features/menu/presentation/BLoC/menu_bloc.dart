import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_admin_dashboard/features/menu/domain/usecases/add_menu_item_usecase.dart';
import 'package:restaurant_admin_dashboard/features/menu/domain/usecases/edit_menu_item_usecase.dart';
import 'package:restaurant_admin_dashboard/features/menu/domain/usecases/get_menu_items_usecase.dart';
import 'package:restaurant_admin_dashboard/features/menu/domain/usecases/toggle_menu_item_availability_usecase.dart';

import 'menu_event.dart';
import 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final GetMenuItemsUseCase getMenuItemsUseCase;
  final AddMenuItemUseCase addMenuItemUseCase;
  final EditMenuItemUseCase editMenuItemUseCase;
  final ToggleMenuItemAvailabilityUseCase toggleMenuItemAvailabilityUseCase;

  MenuBloc({
    required this.getMenuItemsUseCase,
    required this.addMenuItemUseCase,
    required this.editMenuItemUseCase,
    required this.toggleMenuItemAvailabilityUseCase,
  }) :
       super(const MenuInitial()) {
    on<LoadMenuItems>(_onLoadMenuItems);
    on<AddMenuItem>(_onAddMenuItem);
    on<EditMenuItem>(_onEditMenuItem);
    on<ToggleMenuItemAvailability>(_onToggleMenuItemAvailability);
    on<SelectEditorItem>(_onSelectEditorItem);
    on<SelectEditorCategory>(_onSelectEditorCategory);
    on<SetEditorAvailability>(_onSetEditorAvailability);
    on<SelectEditorPhoto>(_onSelectEditorPhoto);
    on<UpdateEditorName>(_onUpdateEditorName);
    on<UpdateEditorPrice>(_onUpdateEditorPrice);
    on<ClearEditor>(_onClearEditor);
    on<ValidateEditorForm>(_onValidateEditorForm);
  }

  Future<void> _onLoadMenuItems(
    LoadMenuItems event,
    Emitter<MenuState> emit,
  ) async {
    emit(MenuLoading(menuModel: state.menuModel));
    try {
      final menu = await getMenuItemsUseCase(sectionId: event.sectionId);
      emit(MenuLoaded(
        menuModel: menu,
        selectedItemIndex: state.selectedItemIndex,
        selectedCategory: state.selectedCategory,
        isAvailable: state.isAvailable,
        selectedPhoto: state.selectedPhoto,
        name: state.name,
        price: state.price,
        nameError: state.nameError,
        priceError: state.priceError,
      ));
    } catch (e) {
      emit(MenuError(
        message: e.toString(),
        menuModel: state.menuModel,
      ));
    }
  }

  Future<void> _onAddMenuItem(
    AddMenuItem event,
    Emitter<MenuState> emit,
  ) async {
    emit(MenuLoading(menuModel: state.menuModel));
    try {
      await addMenuItemUseCase(menuItem: event.menuItem);
      final menu = await getMenuItemsUseCase(
        sectionId: event.menuItem.sectionId,
      );
      emit(MenuActionSuccess(
        message: 'Menu item added successfully',
        menuModel: menu,
        shouldClearForm: true,
        selectedItemIndex: state.selectedItemIndex,
        selectedCategory: state.selectedCategory,
        isAvailable: state.isAvailable,
        selectedPhoto: state.selectedPhoto,
        name: state.name,
        price: state.price,
        nameError: state.nameError,
        priceError: state.priceError,
      ));
    } catch (e) {
      emit(MenuError(
        message: e.toString(),
        menuModel: state.menuModel,
      ));
    }
  }

  Future<void> _onEditMenuItem(
    EditMenuItem event,
    Emitter<MenuState> emit,
  ) async {
    emit(MenuLoading(menuModel: state.menuModel));
    try {
      await editMenuItemUseCase(menuItem: event.menuItem);
      final menu = await getMenuItemsUseCase(
        sectionId: event.menuItem.sectionId,
      );
      emit(MenuActionSuccess(
        message: 'Menu item updated successfully',
        menuModel: menu,
        shouldClearForm: true,
        selectedItemIndex: state.selectedItemIndex,
        selectedCategory: state.selectedCategory,
        isAvailable: state.isAvailable,
        selectedPhoto: state.selectedPhoto,
        name: state.name,
        price: state.price,
        nameError: state.nameError,
        priceError: state.priceError,
      ));
    } catch (e) {
      emit(MenuError(
        message: e.toString(),
        menuModel: state.menuModel,
      ));
    }
  }

  Future<void> _onToggleMenuItemAvailability(
    ToggleMenuItemAvailability event,
    Emitter<MenuState> emit,
  ) async {
    emit(MenuLoading(menuModel: state.menuModel));

    try {
      await toggleMenuItemAvailabilityUseCase(
        id: event.id,
        isAvailable: event.isAvailable,
      );

      final menu = await getMenuItemsUseCase(sectionId: event.sectionId);

      emit(MenuActionSuccess(
        message: 'Menu item availability updated',
        menuModel: menu,
        selectedItemIndex: state.selectedItemIndex,
        selectedCategory: state.selectedCategory,
        isAvailable: state.isAvailable,
        selectedPhoto: state.selectedPhoto,
        name: state.name,
        price: state.price,
        nameError: state.nameError,
        priceError: state.priceError,
      ));
    } catch (e) {
      emit(MenuError(
        message: e.toString(),
        menuModel: state.menuModel,
      ));
    }
  }

  void _onSelectEditorItem(
    SelectEditorItem event,
    Emitter<MenuState> emit,
  ) {
    final currentState = state;
    emit(currentState is MenuActionSuccess
        ? MenuActionSuccess(
            message: currentState.message,
            menuModel: currentState.menuModel,
            shouldClearForm: currentState.shouldClearForm,
            selectedItemIndex: event.index,
            selectedCategory: event.category,
            isAvailable: event.isAvailable,
            selectedPhoto: event.photo,
            name: event.name,
            price: event.price,
          )
        : MenuLoaded(
            menuModel: currentState.menuModel,
            selectedItemIndex: event.index,
            selectedCategory: event.category,
            isAvailable: event.isAvailable,
            selectedPhoto: event.photo,
            name: event.name,
            price: event.price,
          ));
  }

  void _onSelectEditorCategory(
    SelectEditorCategory event,
    Emitter<MenuState> emit,
  ) {
    _emitWithUpdatedEditor(emit, selectedCategory: event.category);
  }

  void _onSetEditorAvailability(
    SetEditorAvailability event,
    Emitter<MenuState> emit,
  ) {
    _emitWithUpdatedEditor(emit, isAvailable: event.isAvailable);
  }

  void _onSelectEditorPhoto(
    SelectEditorPhoto event,
    Emitter<MenuState> emit,
  ) {
    _emitWithUpdatedEditor(emit, selectedPhoto: event.photo);
  }

  void _onUpdateEditorName(
    UpdateEditorName event,
    Emitter<MenuState> emit,
  ) {
    _emitWithUpdatedEditor(emit, name: event.name, nameError: null);
  }

  void _onUpdateEditorPrice(
    UpdateEditorPrice event,
    Emitter<MenuState> emit,
  ) {
    _emitWithUpdatedEditor(emit, price: event.price, priceError: null);
  }

  void _onClearEditor(
    ClearEditor event,
    Emitter<MenuState> emit,
  ) {
    final currentState = state;
    if (currentState.menuModel != null) {
      emit(MenuLoaded(
        menuModel: currentState.menuModel,
      ));
    } else {
      emit(const MenuInitial());
    }
  }

  void _onValidateEditorForm(
    ValidateEditorForm event,
    Emitter<MenuState> emit,
  ) {
    final nameError = _validateName(state.name);
    final priceError = _validatePrice(state.price);

    _emitWithUpdatedEditor(
      emit,
      nameError: nameError,
      priceError: priceError,
    );
  }

  void _emitWithUpdatedEditor(
    Emitter<MenuState> emit, {
    int? selectedItemIndex,
    String? selectedCategory,
    bool? isAvailable,
    String? selectedPhoto,
    String? name,
    String? price,
    String? nameError,
    String? priceError,
  }) {
    final currentState = state;
    final newState = currentState is MenuActionSuccess
        ? MenuActionSuccess(
            message: currentState.message,
            menuModel: currentState.menuModel,
            shouldClearForm: currentState.shouldClearForm,
            selectedItemIndex: selectedItemIndex ?? currentState.selectedItemIndex,
            selectedCategory: selectedCategory ?? currentState.selectedCategory,
            isAvailable: isAvailable ?? currentState.isAvailable,
            selectedPhoto: selectedPhoto ?? currentState.selectedPhoto,
            name: name ?? currentState.name,
            price: price ?? currentState.price,
            nameError: nameError ?? currentState.nameError,
            priceError: priceError ?? currentState.priceError,
          )
        : MenuLoaded(
            menuModel: currentState.menuModel,
            selectedItemIndex: selectedItemIndex ?? currentState.selectedItemIndex,
            selectedCategory: selectedCategory ?? currentState.selectedCategory,
            isAvailable: isAvailable ?? currentState.isAvailable,
            selectedPhoto: selectedPhoto ?? currentState.selectedPhoto,
            name: name ?? currentState.name,
            price: price ?? currentState.price,
            nameError: nameError ?? currentState.nameError,
            priceError: priceError ?? currentState.priceError,
          );
    emit(newState);
  }

  String? _validateName(String name) {
    if (name.trim().isEmpty) {
      return 'Please enter an item name';
    }
    return null;
  }

  String? _validatePrice(String price) {
    final parsedPrice = double.tryParse(price.trim());
    if (parsedPrice == null || !parsedPrice.isFinite || parsedPrice < 0) {
      return 'Please enter a valid price';
    }
    return null;
  }
}
