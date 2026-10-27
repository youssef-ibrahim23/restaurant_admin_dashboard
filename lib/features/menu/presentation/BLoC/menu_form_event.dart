import 'package:equatable/equatable.dart';
import 'package:restaurant_admin_dashboard/features/menu/data/model/menu_item_model.dart';

sealed class MenuFormEvent extends Equatable {
  const MenuFormEvent();
}

final class MenuFormReset extends MenuFormEvent {
  const MenuFormReset();

  @override
  List<Object?> get props => [];
}

final class MenuFormItemSelected extends MenuFormEvent {
  final MenuItemModel item;
  final int index;

  const MenuFormItemSelected({required this.item, required this.index});

  @override
  List<Object?> get props => [item, index];
}

final class MenuFormCategoryChanged extends MenuFormEvent {
  final String category;

  const MenuFormCategoryChanged(this.category);

  @override
  List<Object?> get props => [category];
}

final class MenuFormAvailabilityChanged extends MenuFormEvent {
  final bool isAvailable;

  const MenuFormAvailabilityChanged(this.isAvailable);

  @override
  List<Object?> get props => [isAvailable];
}

final class MenuFormPhotoChanged extends MenuFormEvent {
  final String photo;

  const MenuFormPhotoChanged(this.photo);

  @override
  List<Object?> get props => [photo];
}

final class MenuFormNameChanged extends MenuFormEvent {
  final String name;

  const MenuFormNameChanged(this.name);

  @override
  List<Object?> get props => [name];
}

final class MenuFormPriceChanged extends MenuFormEvent {
  final String price;

  const MenuFormPriceChanged(this.price);

  @override
  List<Object?> get props => [price];
}

final class MenuFormSaveRequested extends MenuFormEvent {
  final int sectionId;
  final List<MenuItemModel> items;

  const MenuFormSaveRequested({required this.sectionId, required this.items});

  @override
  List<Object?> get props => [sectionId, items];
}

final class MenuFormSubmissionHandled extends MenuFormEvent {
  const MenuFormSubmissionHandled();

  @override
  List<Object?> get props => [];
}
