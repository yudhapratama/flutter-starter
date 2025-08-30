import '../entities/product_entity.dart';

/// Product repository contract
abstract class ProductRepository {
  /// Get all products for a seller
  Future<List<ProductEntity>> getProductsBySellerId(String sellerId);

  /// Get all products
  Future<List<ProductEntity>> getAllProducts();

  /// Get product by ID
  Future<ProductEntity?> getProductById(String id);

  /// Create new product
  Future<bool> createProduct(ProductEntity product);

  /// Update existing product
  Future<bool> updateProduct(ProductEntity product);

  /// Delete product
  Future<bool> deleteProduct(String id);

  /// Update product stock
  Future<bool> updateProductStock(String id, int newStock);

  /// Toggle product active status
  Future<bool> toggleProductStatus(String id, bool isActive);

  /// Search products by name or category
  Future<List<ProductEntity>> searchProducts(String query);

  /// Search products with advanced filters
  Future<List<ProductEntity>> searchProductsAdvanced({
    required String query,
    String? sellerId,
    String? category,
    String? status,
  });
  
  /// Filter products with complex parameters
  Future<List<ProductEntity>> filterProducts({
    String? sellerId,
    String? query,
    String? category,
    String? status,
    List<String>? tags,
    double? minPrice,
    double? maxPrice,
    String sortBy = 'name',
    String sortOrder = 'asc',
  });
  
  /// Get product statistics for a seller
  Future<Map<String, int>> getProductStatistics(String sellerId);
  
  /// Get price range for seller's products
  Future<Map<String, double>> getPriceRange(String sellerId);
  
  /// Get available categories for seller
  Future<List<String>> getAvailableCategories(String sellerId);
  
  /// Get available tags for seller
  Future<List<String>> getAvailableTags(String sellerId);
}