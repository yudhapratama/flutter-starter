import '../../domain/entities/seller_entity.dart';

/// Model data untuk seller profile
/// 
/// Kelas ini merepresentasikan data seller dalam format JSON
/// dan menyediakan konversi ke/dari entity
class SellerModel {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? avatar;
  final String? address;
  final String? city;
  final String? province;
  final String? postalCode;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isVerified;
  final String status;

  const SellerModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatar,
    this.address,
    this.city,
    this.province,
    this.postalCode,
    required this.createdAt,
    required this.updatedAt,
    required this.isVerified,
    required this.status,
  });

  /// Membuat instance dari JSON
  factory SellerModel.fromJson(Map<String, dynamic> json) {
    return SellerModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      avatar: json['avatar'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      province: json['province'] as String?,
      postalCode: json['postal_code'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      isVerified: json['is_verified'] as bool? ?? false,
      status: json['status'] as String? ?? 'active',
    );
  }

  /// Mengkonversi ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'address': address,
      'city': city,
      'province': province,
      'postal_code': postalCode,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_verified': isVerified,
      'status': status,
    };
  }

  /// Mengkonversi ke entity
  SellerEntity toEntity() {
    return SellerEntity(
      id: id,
      name: name,
      email: email,
      phone: phone ?? '',
      avatar: avatar,
      address: address,
      city: city,
      province: province,
      postalCode: postalCode ?? '',
      createdAt: createdAt,
      updatedAt: updatedAt,
      isVerified: isVerified,
      status: status,
    );
  }

  /// Membuat instance dari entity
  factory SellerModel.fromEntity(SellerEntity entity) {
    return SellerModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      phone: entity.phone,
      avatar: entity.avatar,
      address: entity.address,
      city: entity.city,
      province: entity.province,
      postalCode: entity.postalCode,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isVerified: entity.isVerified,
      status: entity.status,
    );
  }

  /// Copy with method
  SellerModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatar,
    String? address,
    String? city,
    String? province,
    String? postalCode,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isVerified,
    String? status,
  }) {
    return SellerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      address: address ?? this.address,
      city: city ?? this.city,
      province: province ?? this.province,
      postalCode: postalCode ?? this.postalCode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isVerified: isVerified ?? this.isVerified,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SellerModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'SellerModel(id: $id, name: $name, email: $email, isVerified: $isVerified, status: $status)';
  }
}