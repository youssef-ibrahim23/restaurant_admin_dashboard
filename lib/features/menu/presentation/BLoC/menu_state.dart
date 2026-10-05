import '../../data/model/menu_model.dart';

// TODO: Change 'class MenuState' to 'sealed class MenuState' for Dart 3 exhaustive pattern matching and implement Equatable across all state classes.
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

// TODO: Decouple one-shot side-effect parameters (message, shouldClearForm) from persistent data state (menuModel) to prevent state duplication across MenuLoaded, MenuLoading, and MenuActionSuccess.
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
