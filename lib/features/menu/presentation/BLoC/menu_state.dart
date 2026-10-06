import 'package:equatable/equatable.dart';
import '../../data/model/menu_model.dart';

// Base class containing persistent data state (menuModel and editor fields)
sealed class MenuState extends Equatable {
  final MenuModel? menuModel;
  final int? selectedItemIndex;
  final String selectedCategory;
  final bool isAvailable;
  final String selectedPhoto;
  final String name;
  final String price;
  final String? nameError;
  final String? priceError;

  const MenuState({
    this.menuModel,
    this.selectedItemIndex,
    this.selectedCategory = 'Burger',
    this.isAvailable = true,
    this.selectedPhoto = '🍔',
    this.name = '',
    this.price = '',
    this.nameError,
    this.priceError,
  });

  @override
  List<Object?> get props => [
        menuModel,
        selectedItemIndex,
        selectedCategory,
        isAvailable,
        selectedPhoto,
        name,
        price,
        nameError,
        priceError,
      ];
}

final class MenuInitial extends MenuState {
  const MenuInitial();
}

final class MenuLoading extends MenuState {
  const MenuLoading({
    super.menuModel,
    super.selectedItemIndex,
    super.selectedCategory,
    super.isAvailable,
    super.selectedPhoto,
    super.name,
    super.price,
    super.nameError,
    super.priceError,
  });
}

final class MenuLoaded extends MenuState {
  const MenuLoaded({
    required super.menuModel,
    super.selectedItemIndex,
    super.selectedCategory,
    super.isAvailable,
    super.selectedPhoto,
    super.name,
    super.price,
    super.nameError,
    super.priceError,
  });
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
  final bool shouldClearForm;

  const MenuActionSuccess({
    required this.message,
    required super.menuModel,
    this.shouldClearForm = false,
    super.selectedItemIndex,
    super.selectedCategory,
    super.isAvailable,
    super.selectedPhoto,
    super.name,
    super.price,
    super.nameError,
    super.priceError,
  });

  @override
  List<Object?> get props => [...super.props, message, shouldClearForm];
}
