import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

/// Use case untuk mencari produk berdasarkan query
class SearchProducts {
  final ProductRepository repository;

  const SearchProducts(this.repository);

  /// Mencari produk berdasarkan nama, deskripsi, kategori, atau tag
  /// [query] - kata kunci pencarian
  /// [sellerId] - ID seller untuk membatasi pencarian pada produk seller tertentu
  /// [category] - filter berdasarkan kategori (opsional)
  /// [status] - filter berdasarkan status produk (opsional)
  Future<List<ProductEntity>> call({
    required String query,
    String? sellerId,
    String? category,
    String? status,
  }) async {
    // Jika query kosong, return semua produk seller
    if (query.trim().isEmpty) {
      if (sellerId != null) {
        return await repository.getProductsBySellerId(sellerId);
      }
      return await repository.getAllProducts();
    }

    // Ambil semua produk terlebih dahulu
    List<ProductEntity> products;
    if (sellerId != null) {
      products = await repository.getProductsBySellerId(sellerId);
    } else {
      products = await repository.getAllProducts();
    }

    // Filter berdasarkan query
    final lowerQuery = query.toLowerCase().trim();
    var filteredProducts = products.where((product) {
      final nameMatch = product.name.toLowerCase().contains(lowerQuery);
      final descriptionMatch = product.description.toLowerCase().contains(lowerQuery);
      final categoryMatch = product.category.toLowerCase().contains(lowerQuery);
      final tagsMatch = product.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
      final skuMatch = product.sku?.toLowerCase().contains(lowerQuery) ?? false;
      
      return nameMatch || descriptionMatch || categoryMatch || tagsMatch || skuMatch;
    }).toList();

    // Filter berdasarkan kategori jika ada
    if (category != null && category.isNotEmpty) {
      filteredProducts = filteredProducts.where((product) {
        return product.category.toLowerCase() == category.toLowerCase();
      }).toList();
    }

    // Filter berdasarkan status jika ada
    if (status != null && status.isNotEmpty) {
      filteredProducts = filteredProducts.where((product) {
        return product.status.toLowerCase() == status.toLowerCase();
      }).toList();
    }

    // Urutkan berdasarkan relevansi (nama yang cocok di awal)
    filteredProducts.sort((a, b) {
      final aNameMatch = a.name.toLowerCase().startsWith(lowerQuery);
      final bNameMatch = b.name.toLowerCase().startsWith(lowerQuery);
      
      if (aNameMatch && !bNameMatch) return -1;
      if (!aNameMatch && bNameMatch) return 1;
      
      // Jika sama-sama match atau tidak match, urutkan berdasarkan nama
      return a.name.compareTo(b.name);
    });

    return filteredProducts;
  }
}