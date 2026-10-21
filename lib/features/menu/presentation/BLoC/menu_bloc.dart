import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_admin_dashboard/features/menu/domain/usecases/add_menu_item_usecase.dart';
import 'package:restaurant_admin_dashboard/features/menu/domain/usecases/delete_menu_item_usecase.dart';
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
  final DeleteMenuItemUseCase deleteMenuItemUseCase;

  MenuBloc({
    required this.getMenuItemsUseCase,
    required this.addMenuItemUseCase,
    required this.editMenuItemUseCase,
    required this.toggleMenuItemAvailabilityUseCase,
    required this.deleteMenuItemUseCase,
  }) :
       super(const MenuInitial()) {
    on<LoadMenuItems>(_onLoadMenuItems);
    on<AddMenuItem>(_onAddMenuItem);
    on<EditMenuItem>(_onEditMenuItem);
    on<DeleteMenuItem>(_onDeleteMenuItem);
    on<ToggleMenuItemAvailability>(_onToggleMenuItemAvailability);
  }

  Future<void> _onLoadMenuItems(
    LoadMenuItems event,
    Emitter<MenuState> emit,
  ) async {
    emit(MenuLoading(menuModel: state.menuModel));
    try {
      final menu = await getMenuItemsUseCase(sectionId: event.sectionId);
      emit(MenuLoaded(menuModel: menu));
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
      ));
    } catch (e) {
      emit(MenuError(
        message: e.toString(),
        menuModel: state.menuModel,
      ));
    }
  }

  Future<void> _onDeleteMenuItem(
    DeleteMenuItem event,
    Emitter<MenuState> emit,
  ) async {
    emit(MenuLoading(menuModel: state.menuModel));
    try {
      await deleteMenuItemUseCase(id: event.id);
      final menu = await getMenuItemsUseCase(sectionId: event.sectionId);
      emit(MenuActionSuccess(
        message: 'Menu item deleted successfully',
        menuModel: menu,
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
      ));
    } catch (e) {
      emit(MenuError(
        message: e.toString(),
        menuModel: state.menuModel,
      ));
    }
  }
}
