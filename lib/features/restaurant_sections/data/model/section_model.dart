class SectionModel {
  final int id;
  final String name;
  final bool isOpen;

  const SectionModel({
    required this.id,
    required this.name,
    required this.isOpen,
  });

  factory SectionModel.fromJson(Map<String, dynamic> json) {
    return SectionModel(
      id: json['id'] as int,
      name: json['name'] as String,
      isOpen: json['is_open'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'is_open': isOpen,
    };
  }
}