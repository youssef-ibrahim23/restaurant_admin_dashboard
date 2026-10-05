import '../../data/model/menu_model.dart';

class MenuState {}

class MenuInitial extends MenuState {}

class MenuLoading extends MenuState {
  final MenuModel? menuModel;

  MenuLoading({this.menuModel});
}

class MenuLoaded extends MenuState {
  final MenuModel menuModel;

  MenuLoaded({required this.menuModel});
}

class MenuError extends MenuState {
  final String message;

  MenuError({required this.message});
}

class MenuActionSuccess extends MenuState {
  final String message;
  final MenuModel menuModel;
  final bool shouldClearForm;

  MenuActionSuccess({
    required this.message,
    required this.menuModel,
    this.shouldClearForm = false,
  });
}
