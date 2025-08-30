import '../repositories/product_repository.dart';

/// Use case untuk mendapatkan statistik produk
class GetProductStatistics {
  final ProductRepository repository;

  const GetProductStatistics(this.repository);

  /// Mendapatkan statistik produk untuk seller tertentu
  /// [sellerId] - ID seller untuk membatasi statistik pada produk seller tertentu
  /// Returns Map dengan key: 'total', 'active', 'inactive', 'draft', 'low_stock', 'out_of_stock'
  Future<Map<String, int>> call(String sellerId) async {
    final products = await repository.getProductsBySellerId(sellerId);
    
    int total = products.length;
    int active = 0;
    int inactive = 0;
    int draft = 0;
    int lowStock = 0;
    int outOfStock = 0;
    
    for (final product in products) {
      // Count by status
      switch (product.status.toLowerCase()) {
        case 'active':
          active++;
          break;
        case 'inactive':
          inactive++;
          break;
        case 'draft':
          draft++;
          break;
      }
      
      // Count by stock level
      if (product.stock == 0) {
        outOfStock++;
      } else if (product.stock <= 10) { // Low stock threshold: 10 or less
        lowStock++;
      }
    }
    
    return {
      'total': total,
      'active': active,
      'inactive': inactive,
      'draft': draft,
      'low_stock': lowStock,
      'out_of_stock': outOfStock,
    };
  }
  
  /// Mendapatkan range harga untuk produk seller
  /// [sellerId] - ID seller
  /// Returns Map dengan key: 'min_price', 'max_price'
  Future<Map<String, double>> getPriceRange(String sellerId) async {
    final products = await repository.getProductsBySellerId(sellerId);
    
    if (products.isEmpty) {
      return {
        'min_price': 0.0,
        'max_price': 1000000.0, // Default max 1 juta
      };
    }
    
    double minPrice = double.infinity;
    double maxPrice = 0.0;
    
    for (final product in products) {
      final effectivePrice = product.hasDiscount && product.discountPrice != null 
          ? product.discountPrice! 
          : product.price;
      
      if (effectivePrice < minPrice) {
        minPrice = effectivePrice;
      }
      if (effectivePrice > maxPrice) {
        maxPrice = effectivePrice;
      }
    }
    
    return {
      'min_price': minPrice == double.infinity ? 0.0 : minPrice,
      'max_price': maxPrice,
    };
  }
  
  /// Mendapatkan semua kategori yang tersedia untuk seller
  /// [sellerId] - ID seller
  /// Returns List kategori unik
  Future<List<String>> getAvailableCategories(String sellerId) async {
    final products = await repository.getProductsBySellerId(sellerId);
    
    final categories = products
        .map((product) => product.category)
        .where((category) => category.isNotEmpty)
        .toSet()
        .toList();
    
    categories.sort();
    return categories;
  }
  
  /// Mendapatkan semua tags yang tersedia untuk seller
  /// [sellerId] - ID seller
  /// Returns List tags unik
  Future<List<String>> getAvailableTags(String sellerId) async {
    final products = await repository.getProductsBySellerId(sellerId);
    
    final allTags = <String>{};
    for (final product in products) {
      allTags.addAll(product.tags);
    }
    
    final tags = allTags.toList();
    tags.sort();
    return tags;
  }
}