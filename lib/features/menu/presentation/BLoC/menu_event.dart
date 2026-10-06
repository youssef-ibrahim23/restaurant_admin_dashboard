import 'package:equatable/equatable.dart';
import '../../data/model/menu_item_model.dart';

sealed class MenuEvent extends Equatable {}

final class LoadMenuItems extends MenuEvent {
  final int sectionId;

  LoadMenuItems({required this.sectionId});

  @override
  List<Object?> get props => [sectionId];
}

final class AddMenuItem extends MenuEvent {
  final MenuItemModel menuItem;

  AddMenuItem({required this.menuItem});

  @override
  List<Object?> get props => [menuItem];
}

final class EditMenuItem extends MenuEvent {
  final MenuItemModel menuItem;

  EditMenuItem({required this.menuItem});

  @override
  List<Object?> get props => [menuItem];
}

final class DeleteMenuItem extends MenuEvent {
  final int id;

  DeleteMenuItem({required this.id});

  @override
  List<Object?> get props => [id];
}

final class ToggleMenuItemAvailability extends MenuEvent {
  final int id;
  final int sectionId;
  final bool isAvailable;

  ToggleMenuItemAvailability({
    required this.id,
    required this.sectionId,
    required this.isAvailable,
  });

  @override
  List<Object?> get props => [id, sectionId, isAvailable];
}

// Editor events
final class SelectEditorItem extends MenuEvent {
  final int index;
  final String category;
  final bool isAvailable;
  final String photo;
  final String name;
  final String price;

  SelectEditorItem({
    required this.index,
    required this.category,
    required this.isAvailable,
    required this.photo,
    required this.name,
    required this.price,
  });

  @override
  List<Object?> get props => [index, category, isAvailable, photo, name, price];
}

final class SelectEditorCategory extends MenuEvent {
  final String category;

  SelectEditorCategory({required this.category});

  @override
  List<Object?> get props => [category];
}

final class SetEditorAvailability extends MenuEvent {
  final bool isAvailable;

  SetEditorAvailability({required this.isAvailable});

  @override
  List<Object?> get props => [isAvailable];
}

final class SelectEditorPhoto extends MenuEvent {
  final String photo;

  SelectEditorPhoto({required this.photo});

  @override
  List<Object?> get props => [photo];
}

final class UpdateEditorName extends MenuEvent {
  final String name;

  UpdateEditorName({required this.name});

  @override
  List<Object?> get props => [name];
}

final class UpdateEditorPrice extends MenuEvent {
  final String price;

  UpdateEditorPrice({required this.price});

  @override
  List<Object?> get props => [price];
}

final class ClearEditor extends MenuEvent {
  @override
  List<Object?> get props => [];
}

final class ValidateEditorForm extends MenuEvent {
  @override
  List<Object?> get props => [];
}
