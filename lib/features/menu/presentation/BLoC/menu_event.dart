import '../../data/model/menu_item_model.dart';

sealed class MenuEvent {}

final class LoadMenuItems extends MenuEvent {
  final int sectionId;

  LoadMenuItems({required this.sectionId});
}

final class AddMenuItem extends MenuEvent {
  final MenuItemModel menuItem;

  AddMenuItem({required this.menuItem});
}

final class EditMenuItem extends MenuEvent {
  final MenuItemModel menuItem;

  EditMenuItem({required this.menuItem});
}

final class DeleteMenuItem extends MenuEvent {
  final int id;

  DeleteMenuItem({required this.id});
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
}
