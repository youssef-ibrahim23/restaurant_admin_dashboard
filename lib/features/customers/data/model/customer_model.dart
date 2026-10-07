class CustomerModel {
  final String id;
  final String name;
  final String phone;
  final String email;

  const CustomerModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
    };
  }
}