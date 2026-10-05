class MenuItemModel {
  final int? id;
  final int sectionId;
  final String photo;
  final String name;
  final double price;
  final String category;
  final bool isAvailable;

  const MenuItemModel({
    this.id,
    required this.sectionId,
    required this.photo,
    required this.name,
    required this.price,
    required this.category,
    required this.isAvailable,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      id: json['id'] as int?,
      sectionId: json['section_id'],
      photo: (json['photo'] as String?)?.isNotEmpty == true
          ? json['photo'] as String
          : '🍔',
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String,
      isAvailable: json['is_available'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'section_id': sectionId,
      'photo': photo,
      'name': name,
      'price': price,
      'category': category,
      'is_available': isAvailable,
    };
  }
}