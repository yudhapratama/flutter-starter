import '../../domain/entities/address_entity.dart';

/// Model untuk konversi data alamat dari/ke JSON
/// 
/// Model ini mengimplementasikan konversi antara JSON dan AddressEntity
class AddressModel extends AddressEntity {
  const AddressModel({
    required super.id,
    required super.shopId,
    required super.label,
    required super.address,
    required super.city,
    required super.province,
    required super.postalCode,
    super.phone,
    super.latitude,
    super.longitude,
    required super.isPrimary,
    required super.isActive,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Membuat AddressModel dari JSON
  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] as String,
      shopId: json['shop_id'] as String,
      label: json['label'] as String,
      address: json['address'] as String,
      city: json['city'] as String,
      province: json['province'] as String,
      postalCode: json['postal_code'] as String,
      phone: json['phone'] as String?,
      latitude: json['latitude'] != null ? (json['latitude'] as num).toDouble() : null,
      longitude: json['longitude'] != null ? (json['longitude'] as num).toDouble() : null,
      isPrimary: json['is_primary'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Mengkonversi AddressModel ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shop_id': shopId,
      'label': label,
      'address': address,
      'city': city,
      'province': province,
      'postal_code': postalCode,
      'phone': phone,
      'latitude': latitude,
      'longitude': longitude,
      'is_primary': isPrimary,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Membuat AddressModel dari AddressEntity
  factory AddressModel.fromEntity(AddressEntity entity) {
    return AddressModel(
      id: entity.id,
      shopId: entity.shopId,
      label: entity.label,
      address: entity.address,
      city: entity.city,
      province: entity.province,
      postalCode: entity.postalCode,
      phone: entity.phone,
      latitude: entity.latitude,
      longitude: entity.longitude,
      isPrimary: entity.isPrimary,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Membuat copy dari model dengan beberapa field yang diubah
  @override
  AddressModel copyWith({
    String? id,
    String? shopId,
    String? label,
    String? address,
    String? city,
    String? province,
    String? postalCode,
    String? phone,
    double? latitude,
    double? longitude,
    bool? isPrimary,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AddressModel(
      id: id ?? this.id,
      shopId: shopId ?? this.shopId,
      label: label ?? this.label,
      address: address ?? this.address,
      city: city ?? this.city,
      province: province ?? this.province,
      postalCode: postalCode ?? this.postalCode,
      phone: phone ?? this.phone,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isPrimary: isPrimary ?? this.isPrimary,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}