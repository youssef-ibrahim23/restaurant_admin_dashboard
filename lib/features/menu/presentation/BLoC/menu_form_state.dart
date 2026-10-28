import 'package:equatable/equatable.dart';
import 'package:restaurant_admin_dashboard/features/menu/data/model/menu_item_model.dart';

final class MenuFormState extends Equatable {
  final int? selectedItemIndex;
  final String selectedCategory;
  final bool isAvailable;
  final String selectedPhoto;
  final String name;
  final String price;
  final String? nameError;
  final String? priceError;
  final MenuItemModel? itemToSave;
  final String? submissionError;

  const MenuFormState({
    this.selectedItemIndex,
    this.selectedCategory = 'Burger',
    this.isAvailable = true,
    this.selectedPhoto = '🍔',
    this.name = '',
    this.price = '',
    this.nameError,
    this.priceError,
    this.itemToSave,
    this.submissionError,
  });

  factory MenuFormState.fromItem(MenuItemModel item, int index) {
    return MenuFormState(
      selectedItemIndex: index,
      selectedCategory: item.category,
      isAvailable: item.isAvailable,
      selectedPhoto: item.photo,
      name: item.name,
      price: item.price.toStringAsFixed(2),
    );
  }

  MenuFormState copyWith({
    int? selectedItemIndex,
    String? selectedCategory,
    bool? isAvailable,
    String? selectedPhoto,
    String? name,
    String? price,
    String? nameError,
    String? priceError,
    bool clearNameError = false,
    bool clearPriceError = false,
    MenuItemModel? itemToSave,
    bool clearItemToSave = false,
    String? submissionError,
    bool clearSubmissionError = false,
  }) {
    return MenuFormState(
      selectedItemIndex: selectedItemIndex,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isAvailable: isAvailable ?? this.isAvailable,
      selectedPhoto: selectedPhoto ?? this.selectedPhoto,
      name: name ?? this.name,
      price: price ?? this.price,
      nameError: clearNameError ? null : nameError ?? this.nameError,
      priceError: clearPriceError ? null : priceError ?? this.priceError,
      itemToSave: clearItemToSave ? null : itemToSave ?? this.itemToSave,
      submissionError: clearSubmissionError
          ? null
          : submissionError ?? this.submissionError,
    );
  }

  @override
  List<Object?> get props => [
    selectedItemIndex,
    selectedCategory,
    isAvailable,
    selectedPhoto,
    name,
    price,
    nameError,
    priceError,
    itemToSave,
    submissionError,
  ];
}
