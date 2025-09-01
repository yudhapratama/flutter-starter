import 'address_entity.dart';

/// Entity yang merepresentasikan data toko seller
/// 
/// Entity ini berisi informasi lengkap tentang toko termasuk
/// data bisnis, alamat, dan konfigurasi toko
class ShopEntity {
  final String id;
  final String sellerId;
  final String name;
  final String description;
  final String? logo;
  final String? banner;
  final List<AddressEntity> addresses; // multi alamat toko
  final String phone;
  final String? email;
  final String? website;
  final Map<String, String> socialMedia; // {"instagram": "@shop", "facebook": "shop"}
  final Map<String, dynamic> businessHours; // {"monday": {"open": "08:00", "close": "17:00"}}
  final List<String> categories; // kategori produk yang dijual
  final double rating;
  final int totalReviews;
  final int totalProducts;
  final int totalOrders; // tambahan untuk statistik
  final double revenue; // tambahan untuk statistik
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final bool isVerified;
  final String status; // pending, approved, rejected, suspended

  const ShopEntity({
    required this.id,
    required this.sellerId,
    required this.name,
    required this.description,
    this.logo,
    this.banner,
    required this.addresses,
    required this.phone,
    this.email,
    this.website,
    required this.socialMedia,
    required this.businessHours,
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

  /// Mendapatkan alamat utama toko
  AddressEntity? get primaryAddress {
    try {
      return addresses.firstWhere((address) => address.isPrimary);
    } catch (e) {
      return addresses.isNotEmpty ? addresses.first : null;
    }
  }

  /// Membuat copy dari entity dengan beberapa field yang diubah
  ShopEntity copyWith({
    String? id,
    String? sellerId,
    String? name,
    String? description,
    String? logo,
    String? banner,
    List<AddressEntity>? addresses,
    String? phone,
    String? email,
    String? website,
    Map<String, String>? socialMedia,
    Map<String, dynamic>? businessHours,
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
    return ShopEntity(
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
    return other is ShopEntity &&
        other.id == id &&
        other.sellerId == sellerId &&
        other.name == name &&
        other.description == description &&
        other.logo == logo &&
        other.banner == banner &&
        other.addresses == addresses &&
        other.phone == phone &&
        other.email == email &&
        other.website == website &&
        other.socialMedia == socialMedia &&
        other.businessHours == businessHours &&
        other.categories == categories &&
        other.rating == rating &&
        other.totalReviews == totalReviews &&
        other.totalProducts == totalProducts &&
        other.totalOrders == totalOrders &&
        other.revenue == revenue &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.isActive == isActive &&
        other.isVerified == isVerified &&
        other.status == status;
  }

  @override
  int get hashCode {
    return Object.hashAll([
      id,
      sellerId,
      name,
      description,
      logo,
      banner,
      addresses,
      phone,
      email,
      website,
      socialMedia,
      businessHours,
      categories,
      rating,
      totalReviews,
      totalProducts,
      totalOrders,
      revenue,
      createdAt,
      updatedAt,
      isActive,
      isVerified,
      status,
    ]);
  }

  @override
  String toString() {
    return 'ShopEntity(id: $id, sellerId: $sellerId, name: $name, description: $description, logo: $logo, banner: $banner, addresses: $addresses, phone: $phone, email: $email, website: $website, socialMedia: $socialMedia, businessHours: $businessHours, categories: $categories, rating: $rating, totalReviews: $totalReviews, totalProducts: $totalProducts, totalOrders: $totalOrders, revenue: $revenue, createdAt: $createdAt, updatedAt: $updatedAt, isActive: $isActive, isVerified: $isVerified, status: $status)';
  }
}