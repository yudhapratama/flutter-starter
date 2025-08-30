import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

/// Use case untuk filter produk dengan parameter yang lebih kompleks
class FilterProducts {
  final ProductRepository repository;

  const FilterProducts(this.repository);

  /// Filter produk dengan berbagai parameter
  /// [sellerId] - ID seller untuk membatasi pencarian
  /// [query] - kata kunci pencarian (opsional)
  /// [category] - filter berdasarkan kategori (opsional)
  /// [status] - filter berdasarkan status produk (opsional)
  /// [tags] - filter berdasarkan tags (opsional)
  /// [minPrice] - harga minimum (opsional)
  /// [maxPrice] - harga maksimum (opsional)
  /// [sortBy] - urutan sorting: 'name', 'price', 'created_at' (default: 'name')
  /// [sortOrder] - arah sorting: 'asc', 'desc' (default: 'asc')
  Future<List<ProductEntity>> call({
    String? sellerId,
    String? query,
    String? category,
    String? status,
    List<String>? tags,
    double? minPrice,
    double? maxPrice,
    String sortBy = 'name',
    String sortOrder = 'asc',
  }) async {
    // Ambil produk berdasarkan seller atau semua produk
    List<ProductEntity> products;
    if (sellerId != null) {
      products = await repository.getProductsBySellerId(sellerId);
    } else {
      products = await repository.getAllProducts();
    }

    // Filter berdasarkan query jika ada
    if (query != null && query.trim().isNotEmpty) {
      final lowerQuery = query.toLowerCase().trim();
      products = products.where((product) {
        final nameMatch = product.name.toLowerCase().contains(lowerQuery);
        final descriptionMatch = product.description.toLowerCase().contains(lowerQuery);
        final categoryMatch = product.category.toLowerCase().contains(lowerQuery);
        final tagsMatch = product.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
        final skuMatch = product.sku?.toLowerCase().contains(lowerQuery) ?? false;
        
        return nameMatch || descriptionMatch || categoryMatch || tagsMatch || skuMatch;
      }).toList();
    }

    // Filter berdasarkan kategori
    if (category != null && category.isNotEmpty) {
      products = products.where((product) {
        return product.category.toLowerCase() == category.toLowerCase();
      }).toList();
    }

    // Filter berdasarkan status
    if (status != null && status.isNotEmpty) {
      products = products.where((product) {
        return product.status.toLowerCase() == status.toLowerCase();
      }).toList();
    }

    // Filter berdasarkan tags
    if (tags != null && tags.isNotEmpty) {
      products = products.where((product) {
        return tags.any((tag) => product.tags.contains(tag.toLowerCase()));
      }).toList();
    }

    // Filter berdasarkan range harga
    if (minPrice != null) {
      products = products.where((product) {
        final effectivePrice = product.hasDiscount && product.discountPrice != null 
            ? product.discountPrice! 
            : product.price;
        return effectivePrice >= minPrice;
      }).toList();
    }

    if (maxPrice != null) {
      products = products.where((product) {
        final effectivePrice = product.hasDiscount && product.discountPrice != null 
            ? product.discountPrice! 
            : product.price;
        return effectivePrice <= maxPrice;
      }).toList();
    }

    // Sorting
    products.sort((a, b) {
      int comparison = 0;
      
      switch (sortBy.toLowerCase()) {
        case 'price':
          final aPrice = a.hasDiscount && a.discountPrice != null ? a.discountPrice! : a.price;
          final bPrice = b.hasDiscount && b.discountPrice != null ? b.discountPrice! : b.price;
          comparison = aPrice.compareTo(bPrice);
          break;
        case 'created_at':
          comparison = a.createdAt.compareTo(b.createdAt);
          break;
        case 'stock':
          comparison = a.stock.compareTo(b.stock);
          break;
        case 'name':
        default:
          comparison = a.name.toLowerCase().compareTo(b.name.toLowerCase());
          break;
      }
      
      return sortOrder.toLowerCase() == 'desc' ? -comparison : comparison;
    });

    return products;
  }
}