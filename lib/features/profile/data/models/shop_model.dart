import '../../domain/entities/shop_entity.dart';
import 'address_model.dart';

/// Model data untuk shop/toko
/// 
/// Kelas ini merepresentasikan data toko dalam format JSON
/// dan menyediakan konversi ke/dari entity
class ShopModel {
  final String id;
  final String sellerId;
  final String name;
  final String? description;
  final String? logo;
  final String? banner;
  final List<AddressModel> addresses;
  final String? phone;
  final String? email;
  final String? website;
  final Map<String, String>? socialMedia;
  final Map<String, String>? businessHours;
  final List<String> categories;
  final double rating;
  final int totalReviews;
  final int totalProducts;
  final int totalOrders;
  final double revenue;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final bool isVerified;
  final String status;

  const ShopModel({
    required this.id,
    required this.sellerId,
    required this.name,
    this.description,
    this.logo,
    this.banner,
    required this.addresses,
    this.phone,
    this.email,
    this.website,
    this.socialMedia,
    this.businessHours,
    required this.categories,
    required this.rating,
    required this.totalReviews,
    required this.totalProducts,
    required this.totalOrders,
    required this.revenue,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
    required this.isVerified,
    required this.status,
  });

  /// Membuat instance dari JSON
  factory ShopModel.fromJson(Map<String, dynamic> json) {
    return ShopModel(
      id: json['id'] as String,
      sellerId: json['seller_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      logo: json['logo'] as String?,
      banner: json['banner'] as String?,
      addresses: json['addresses'] != null 
          ? (json['addresses'] as List).map((e) => AddressModel.fromJson(e as Map<String, dynamic>)).toList()
          : [],
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      website: json['website'] as String?,
      socialMedia: json['social_media'] != null 
          ? Map<String, String>.from(json['social_media'] as Map)
          : null,
      businessHours: json['business_hours'] != null 
          ? Map<String, String>.from(json['business_hours'] as Map)
          : null,
      categories: json['categories'] != null 
          ? List<String>.from(json['categories'] as List)
          : [],
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: json['total_reviews'] as int? ?? 0,
      totalProducts: json['total_products'] as int? ?? 0,
      totalOrders: json['total_orders'] as int? ?? 0,
      revenue: (json['revenue'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      isActive: json['is_active'] as bool? ?? true,
      isVerified: json['is_verified'] as bool? ?? false,
      status: json['status'] as String? ?? 'active',
    );
  }

  /// Mengkonversi ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'seller_id': sellerId,
      'name': name,
      'description': description,
      'logo': logo,
      'banner': banner,
      'addresses': addresses.map((e) => e.toJson()).toList(),
      'phone': phone,
      'email': email,
      'website': website,
      'social_media': socialMedia,
      'business_hours': businessHours,
      'categories': categories,
      'rating': rating,
      'total_reviews': totalReviews,
      'total_products': totalProducts,
      'total_orders': totalOrders,
      'revenue': revenue,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_active': isActive,
      'is_verified': isVerified,
      'status': status,
    };
  }

  /// Mengkonversi ke entity
  ShopEntity toEntity() {
    return ShopEntity(
      id: id,
      sellerId: sellerId,
      name: name,
      description: description ?? '',
      logo: logo,
      banner: banner,
      addresses: addresses.map((e) => e).toList(),
      phone: phone ?? '',
      email: email,
      website: website,
      socialMedia: socialMedia ?? {},
      businessHours: businessHours?.map((key, value) => MapEntry(key, value)) ?? <String, dynamic>{},
      categories: categories,
      rating: rating,
      totalReviews: totalReviews,
      totalProducts: totalProducts,
      totalOrders: totalOrders,
      revenue: revenue,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isActive: isActive,
      isVerified: isVerified,
      status: status,
    );
  }

  /// Membuat instance dari entity
  factory ShopModel.fromEntity(ShopEntity entity) {
    return ShopModel(
      id: entity.id,
      sellerId: entity.sellerId,
      name: entity.name,
      description: entity.description,
      logo: entity.logo,
      banner: entity.banner,
      addresses: entity.addresses.map((e) => AddressModel.fromEntity(e)).toList(),
      phone: entity.phone,
      email: entity.email,
      website: entity.website,
      socialMedia: entity.socialMedia,
      businessHours: entity.businessHours.map((key, value) => MapEntry(key, value.toString())),
      categories: entity.categories,
      rating: entity.rating,
      totalReviews: entity.totalReviews,
      totalProducts: entity.totalProducts,
      totalOrders: entity.totalOrders,
      revenue: entity.revenue,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isActive: entity.isActive,
      isVerified: entity.isVerified,
      status: entity.status,
    );
  }

  /// Copy with method
  ShopModel copyWith({
    String? id,
    String? sellerId,
    String? name,
    String? description,
    String? logo,
    String? banner,
    List<AddressModel>? addresses,
    String? phone,
    String? email,
    String? website,
    Map<String, String>? socialMedia,
    Map<String, String>? businessHours,
    List<String>? categories,
    double? rating,
    int? totalReviews,
    int? totalProducts,
    int? totalOrders,
    double? revenue,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    bool? isVerified,
    String? status,
  }) {
    return ShopModel(
      id: id ?? this.id,
      sellerId: sellerId ?? this.sellerId,
      name: name ?? this.name,
      description: description ?? this.description,
      logo: logo ?? this.logo,
      banner: banner ?? this.banner,
      addresses: addresses ?? this.addresses,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      website: website ?? this.website,
      socialMedia: socialMedia ?? this.socialMedia,
      businessHours: businessHours ?? this.businessHours,
      categories: categories ?? this.categories,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      totalProducts: totalProducts ?? this.totalProducts,
      totalOrders: totalOrders ?? this.totalOrders,
      revenue: revenue ?? this.revenue,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      isVerified: isVerified ?? this.isVerified,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ShopModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'ShopModel(id: $id, name: $name, sellerId: $sellerId, isActive: $isActive, status: $status)';
  }
}