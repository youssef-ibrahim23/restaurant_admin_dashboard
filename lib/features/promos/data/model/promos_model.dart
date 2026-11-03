import 'package:equatable/equatable.dart';

class PromoModel extends Equatable {
  final String id;
  final String code;
  final double discount;
  final String status;
  final DateTime createdAt;

  const PromoModel({
    required this.id,
    required this.code,
    required this.discount,
    required this.status,
    required this.createdAt,
  });

  factory PromoModel.fromJson(Map<String, dynamic> json) {
    return PromoModel(
      id: json['id']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      status: json['status']?.toString() ?? 'Active',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty && id != '0') 'id': id,
      'code': code,
      'discount': discount,
      'status': status,
    };
  }

  PromoModel copyWith({
    String? id,
    String? code,
    double? discount,
    String? status,
    DateTime? createdAt,
  }) {
    return PromoModel(
      id: id ?? this.id,
      code: code ?? this.code,
      discount: discount ?? this.discount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  bool get isActive => status.toLowerCase() == 'active';

  @override
  List<Object?> get props => [id, code, discount, status, createdAt];
}
