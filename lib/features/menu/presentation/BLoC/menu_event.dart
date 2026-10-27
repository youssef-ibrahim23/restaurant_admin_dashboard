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
  final int sectionId;

  DeleteMenuItem({
    required this.id,
    required this.sectionId,
  });

  @override
  List<Object?> get props => [id, sectionId];
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
