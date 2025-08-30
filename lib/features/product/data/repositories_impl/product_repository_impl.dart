import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductLocalDataSource local;

  ProductRepositoryImpl({required this.local});

  @override
  Future<bool> createProduct(ProductEntity product) async {
    return await local.save(product);
  }

  @override
  Future<bool> deleteProduct(String id) async {
    return await local.delete(id);
  }

  @override
  Future<List<ProductEntity>> getAllProducts() async {
    return (await local.getAll());
  }

  @override
  Future<ProductEntity?> getProductById(String id) async {
    return await local.getById(id);
  }

  @override
  Future<List<ProductEntity>> getProductsBySellerId(String sellerId) async {
    return (await local.getBySellerId(sellerId));
  }

  @override
  Future<bool> toggleProductStatus(String id, bool isActive) async {
    final product = await getProductById(id);
    if (product == null) return false;
    final newStatus = isActive ? 'active' : 'inactive';
    return await updateProduct(product.copyWith(status: newStatus, updatedAt: DateTime.now()));
  }

  @override
  Future<bool> updateProduct(ProductEntity product) async {
    return await local.save(product);
  }

  @override
  Future<bool> updateProductStock(String id, int newStock) async {
    final product = await getProductById(id);
    if (product == null) return false;
    return await updateProduct(product.copyWith(stock: newStock, updatedAt: DateTime.now()));
  }

  @override
  Future<List<ProductEntity>> searchProducts(String query) async {
    final all = await getAllProducts();
    final lower = query.toLowerCase();
    return all.where((p) => p.name.toLowerCase().contains(lower) || p.category.toLowerCase().contains(lower)).toList();
  }

  @override
  Future<List<ProductEntity>> searchProductsAdvanced({
    required String query,
    String? sellerId,
    String? category,
    String? status,
  }) async {
    // Ambil produk berdasarkan seller atau semua produk
    List<ProductEntity> products;
    if (sellerId != null) {
      products = await getProductsBySellerId(sellerId);
    } else {
      products = await getAllProducts();
    }

    // Jika query kosong, return semua produk dengan filter
    if (query.trim().isEmpty) {
      var filteredProducts = products;
      
      // Filter berdasarkan kategori
      if (category != null && category.isNotEmpty) {
        filteredProducts = filteredProducts.where((product) {
          return product.category.toLowerCase() == category.toLowerCase();
        }).toList();
      }
      
      // Filter berdasarkan status
      if (status != null && status.isNotEmpty) {
        filteredProducts = filteredProducts.where((product) {
          return product.status.toLowerCase() == status.toLowerCase();
        }).toList();
      }
      
      return filteredProducts;
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

    // Urutkan berdasarkan relevansi
    filteredProducts.sort((a, b) {
      final aNameMatch = a.name.toLowerCase().startsWith(lowerQuery);
      final bNameMatch = b.name.toLowerCase().startsWith(lowerQuery);
      
      if (aNameMatch && !bNameMatch) return -1;
      if (!aNameMatch && bNameMatch) return 1;
      
      return a.name.compareTo(b.name);
    });

    return filteredProducts;
  }
  
  @override
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
  }) async {
    // Ambil produk berdasarkan seller atau semua produk
    List<ProductEntity> products;
    if (sellerId != null) {
      products = await getProductsBySellerId(sellerId);
    } else {
      products = await getAllProducts();
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
  
  @override
  Future<Map<String, int>> getProductStatistics(String sellerId) async {
    final products = await getProductsBySellerId(sellerId);
    
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
  
  @override
  Future<Map<String, double>> getPriceRange(String sellerId) async {
    final products = await getProductsBySellerId(sellerId);
    
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
  
  @override
  Future<List<String>> getAvailableCategories(String sellerId) async {
    final products = await getProductsBySellerId(sellerId);
    
    final categories = products
        .map((product) => product.category)
        .where((category) => category.isNotEmpty)
        .toSet()
        .toList();
    
    categories.sort();
    return categories;
  }
  
  @override
  Future<List<String>> getAvailableTags(String sellerId) async {
    final products = await getProductsBySellerId(sellerId);
    
    final allTags = <String>{};
    for (final product in products) {
      allTags.addAll(product.tags);
    }
    
    final tags = allTags.toList();
    tags.sort();
    return tags;
  }
}