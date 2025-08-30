/// Product entity untuk domain layer
class ProductEntity {
  final String id;
  final String sellerId;
  final String name;
  final String description;
  final double price;
  final int stock;
  final String category;
  final List<String> images;
  final int? mainImageIndex; // Index foto utama (0-4)
  final String? sku;
  
  // Diskon
  final bool hasDiscount;
  final double? discountPrice;
  final DateTime? discountStartDate;
  final DateTime? discountEndDate;
  
  // Stok & Pesanan
  final int minOrder;
  final int maxOrder;
  
  // Pengiriman
  final double weightInGrams; // dalam gram
  final double? length; // panjang dalam cm
  final double? width; // lebar dalam cm
  final double? height; // tinggi dalam cm
  
  // Status & Sertifikasi
  final String status; // 'active', 'inactive', 'draft'
  final bool hasHalalCertification;
  
  // Tag Produk
  final List<String> tags;
  
  final DateTime createdAt;
  final DateTime updatedAt;

  @Deprecated('Use status field instead')
  bool get isActive => status == 'active';

  const ProductEntity({
    required this.id,
    required this.sellerId,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.category,
    required this.images,
    this.mainImageIndex,
    this.sku,
    this.hasDiscount = false,
    this.discountPrice,
    this.discountStartDate,
    this.discountEndDate,
    this.minOrder = 1,
    this.maxOrder = 999,
    required this.weightInGrams,
    this.length,
    this.width,
    this.height,
    this.status = 'active',
    this.hasHalalCertification = false,
    this.tags = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  /// Copy with method for immutable updates
  ProductEntity copyWith({
    String? id,
    String? sellerId,
    String? name,
    String? description,
    double? price,
    int? stock,
    String? category,
    List<String>? images,
    int? mainImageIndex,
    String? sku,
    bool? hasDiscount,
    double? discountPrice,
    DateTime? discountStartDate,
    DateTime? discountEndDate,
    int? minOrder,
    int? maxOrder,
    double? weightInGrams,
    double? length,
    double? width,
    double? height,
    String? status,
    bool? hasHalalCertification,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      sellerId: sellerId ?? this.sellerId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      category: category ?? this.category,
      images: images ?? this.images,
      mainImageIndex: mainImageIndex ?? this.mainImageIndex,
      sku: sku ?? this.sku,
      hasDiscount: hasDiscount ?? this.hasDiscount,
      discountPrice: discountPrice ?? this.discountPrice,
      discountStartDate: discountStartDate ?? this.discountStartDate,
      discountEndDate: discountEndDate ?? this.discountEndDate,
      minOrder: minOrder ?? this.minOrder,
      maxOrder: maxOrder ?? this.maxOrder,
      weightInGrams: weightInGrams ?? this.weightInGrams,
      length: length ?? this.length,
      width: width ?? this.width,
      height: height ?? this.height,
      status: status ?? this.status,
      hasHalalCertification: hasHalalCertification ?? this.hasHalalCertification,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProductEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'ProductEntity(id: $id, name: $name, sellerId: $sellerId)';
  }
}