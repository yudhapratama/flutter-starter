import '../../domain/entities/product_entity.dart';

/// ProductModel sebagai DTO untuk data layer
class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.sellerId,
    required super.name,
    required super.description,
    required super.price,
    required super.stock,
    required super.category,
    required super.images,
    super.mainImageIndex,
    super.sku,
    super.hasDiscount = false,
    super.discountPrice,
    super.discountStartDate,
    super.discountEndDate,
    super.minOrder = 1,
    super.maxOrder = 999,
    required super.weightInGrams,
    super.length,
    super.width,
    super.height,
    super.status = 'active',
    super.hasHalalCertification = false,
    super.tags = const [],
    required super.createdAt,
    required super.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      sellerId: json['sellerId'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
      stock: json['stock'] as int? ?? 0,
      category: json['category'] as String? ?? '',
      images: (json['images'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      mainImageIndex: json['mainImageIndex'] as int?,
      sku: json['sku'] as String?,
      hasDiscount: json['hasDiscount'] as bool? ?? false,
      discountPrice: (json['discountPrice'] as num?)?.toDouble(),
      discountStartDate: json['discountStartDate'] != null ? DateTime.parse(json['discountStartDate'] as String) : null,
      discountEndDate: json['discountEndDate'] != null ? DateTime.parse(json['discountEndDate'] as String) : null,
      minOrder: json['minOrder'] as int? ?? 1,
      maxOrder: json['maxOrder'] as int? ?? 999,
      weightInGrams: (json['weightInGrams'] as num?)?.toDouble() ?? 0.0,
      length: (json['length'] as num?)?.toDouble(),
      width: (json['width'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
      status: json['status'] as String? ?? 'active',
      hasHalalCertification: json['hasHalalCertification'] as bool? ?? false,
      tags: (json['tags'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sellerId': sellerId,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'category': category,
      'images': images,
      'mainImageIndex': mainImageIndex,
      'sku': sku,
      'hasDiscount': hasDiscount,
      'discountPrice': discountPrice,
      'discountStartDate': discountStartDate?.toIso8601String(),
      'discountEndDate': discountEndDate?.toIso8601String(),
      'minOrder': minOrder,
      'maxOrder': maxOrder,
      'weightInGrams': weightInGrams,
      'length': length,
      'width': width,
      'height': height,
      'status': status,
      'hasHalalCertification': hasHalalCertification,
      'tags': tags,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  ProductEntity toEntity() => this;
}