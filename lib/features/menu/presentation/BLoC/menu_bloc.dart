import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_admin_dashboard/features/menu/data/model/menu_model.dart';
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
       super(MenuInitial()) {
    on<LoadMenuItems>(_onLoadMenuItems);
    on<AddMenuItem>(_onAddMenuItem);
    on<EditMenuItem>(_onEditMenuItem);
    on<ToggleMenuItemAvailability>(_onToggleMenuItemAvailability);
  }

  Future<void> _onLoadMenuItems(
    LoadMenuItems event,
    Emitter<MenuState> emit,
  ) async {
    emit(MenuLoading(menuModel: _currentMenuModel));
    try {
      final menu = await getMenuItemsUseCase(sectionId: event.sectionId);
      emit(MenuLoaded(menuModel: menu));
    } catch (e) {
      emit(MenuError(message: e.toString()));
    }
  }

  Future<void> _onAddMenuItem(
    AddMenuItem event,
    Emitter<MenuState> emit,
  ) async {
    emit(MenuLoading(menuModel: _currentMenuModel));
    try {
      await addMenuItemUseCase(menuItem: event.menuItem);
      final menu = await getMenuItemsUseCase(
        sectionId: event.menuItem.sectionId,
      );
      emit(
        MenuActionSuccess(
          message: 'Menu item added successfully',
          menuModel: menu,
          shouldClearForm: true,
        ),
      );
    } catch (e) {
      emit(MenuError(message: e.toString()));
    }
  }

  Future<void> _onEditMenuItem(
    EditMenuItem event,
    Emitter<MenuState> emit,
  ) async {
    emit(MenuLoading(menuModel: _currentMenuModel));
    try {
      await editMenuItemUseCase(menuItem: event.menuItem);
      final menu = await getMenuItemsUseCase(
        sectionId: event.menuItem.sectionId,
      );
      emit(
        MenuActionSuccess(
          message: 'Menu item updated successfully',
          menuModel: menu,
          shouldClearForm: true,
        ),
      );
    } catch (e) {
      emit(MenuError(message: e.toString()));
    }
  }

  Future<void> _onToggleMenuItemAvailability(
    ToggleMenuItemAvailability event,
    Emitter<MenuState> emit,
  ) async {
    emit(MenuLoading(menuModel: _currentMenuModel));

    try {
      await toggleMenuItemAvailabilityUseCase(
        id: event.id,
        isAvailable: event.isAvailable,
      );

      final menu = await getMenuItemsUseCase(sectionId: event.sectionId);

      emit(
        MenuActionSuccess(
          message: 'Menu item availability updated',
          menuModel: menu,
        ),
      );
    } catch (e) {
      emit(MenuError(message: e.toString()));
    }
  }

  // TODO: Eliminate helper getter '_currentMenuModel' once state hierarchy is refactored to maintain persistent menuModel state.
  MenuModel? get _currentMenuModel {
    final currentState = state;
    if (currentState is MenuLoaded) return currentState.menuModel;
    if (currentState is MenuActionSuccess) return currentState.menuModel;
    if (currentState is MenuLoading) return currentState.menuModel;
    return null;
  }
}
