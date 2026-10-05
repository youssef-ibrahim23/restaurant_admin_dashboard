class MenuEditorState {
  final int? selectedItemIndex;
  final String selectedCategory;
  final bool isAvailable;
  final String selectedPhoto;

  const MenuEditorState({
    this.selectedItemIndex,
    this.selectedCategory = 'Burger',
    this.isAvailable = true,
    this.selectedPhoto = '🍔',
  });

  MenuEditorState copyWith({
    int? selectedItemIndex,
    bool clearSelectedItem = false,
    String? selectedCategory,
    bool? isAvailable,
    String? selectedPhoto,
  }) {
    return MenuEditorState(
      selectedItemIndex: clearSelectedItem
          ? null
          : selectedItemIndex ?? this.selectedItemIndex,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isAvailable: isAvailable ?? this.isAvailable,
      selectedPhoto: selectedPhoto ?? this.selectedPhoto,
    );
  }
}
