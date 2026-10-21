import 'package:equatable/equatable.dart';
import '../../data/model/menu_model.dart';

sealed class MenuState extends Equatable {
  final MenuModel? menuModel;

  const MenuState({this.menuModel});

  @override
  List<Object?> get props => [menuModel];
}

final class MenuInitial extends MenuState {
  const MenuInitial();
}

final class MenuLoading extends MenuState {
  const MenuLoading({super.menuModel});
}

final class MenuLoaded extends MenuState {
  const MenuLoaded({required super.menuModel});
}

final class MenuError extends MenuState {
  final String message;

  const MenuError({
    required this.message,
    super.menuModel,
  });

  @override
  List<Object?> get props => [...super.props, message];
}

final class MenuActionSuccess extends MenuState {
  final String message;

  const MenuActionSuccess({
    required this.message,
    required super.menuModel,
  });

  @override
  List<Object?> get props => [...super.props, message];
}
