import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/usecases/create_product.dart';
import '../../domain/usecases/delete_product.dart';
import '../../domain/usecases/get_products_by_seller.dart';
import '../../domain/usecases/search_products.dart';
import '../../domain/usecases/update_product.dart';
import '../../domain/usecases/filter_products.dart';
import '../../domain/usecases/get_product_statistics.dart';
import 'product_state.dart';

class ProductNotifier extends StateNotifier<ProductState> {
  final GetProductsBySeller getProductsBySeller;
  final CreateProduct createProduct;
  final UpdateProduct updateProduct;
  final DeleteProduct deleteProduct;
  final SearchProducts searchProducts;
  final FilterProducts filterProducts;
  final GetProductStatistics getProductStatistics;

  ProductNotifier({
    required this.getProductsBySeller,
    required this.createProduct,
    required this.updateProduct,
    required this.deleteProduct,
    required this.searchProducts,
    required this.filterProducts,
    required this.getProductStatistics,
  }) : super(const ProductState());

  Future<void> loadProducts(String sellerId) async {
    state = state.copyWith(
      isLoading: true, 
      error: null, 
      currentPage: 1,
      hasMore: true,
    );
    try {
      // Add 1 second delay to simulate loading and see the loading indicator
      await Future.delayed(const Duration(seconds: 1));
      
      final allItems = await getProductsBySeller(sellerId);
      final paginatedItems = _getPaginatedItems(allItems, 1);
      final hasMore = allItems.length > state.itemsPerPage;
      
      state = state.copyWith(
        isLoading: false, 
        products: paginatedItems,
        hasMore: hasMore,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadMoreProducts(String sellerId) async {
    if (state.isLoadingMore || !state.hasMore) return;
    
    state = state.copyWith(isLoadingMore: true, error: null);
    try {
      // Add 1 second delay to simulate loading and see the loading indicator
      await Future.delayed(const Duration(seconds: 1));
      
      final allItems = await getProductsBySeller(sellerId);
      final nextPage = state.currentPage + 1;
      final newItems = _getPaginatedItems(allItems, nextPage);
      
      if (newItems.isNotEmpty) {
        final updatedProducts = [...state.products, ...newItems];
        final hasMore = (nextPage * state.itemsPerPage) < allItems.length;
        
        state = state.copyWith(
          isLoadingMore: false,
          products: updatedProducts,
          currentPage: nextPage,
          hasMore: hasMore,
        );
      } else {
        state = state.copyWith(
          isLoadingMore: false,
          hasMore: false,
        );
      }
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, error: e.toString());
    }
  }

  Future<void> refreshProducts(String sellerId) async {
    state = state.copyWith(
      currentPage: 1,
      hasMore: true,
    );
    
    // Add 1 second delay to simulate loading and see the refresh indicator
    await Future.delayed(const Duration(seconds: 1));
    
    await loadProducts(sellerId);
  }

  List<ProductEntity> _getPaginatedItems(List<ProductEntity> allItems, int page) {
    final startIndex = (page - 1) * state.itemsPerPage;
    final endIndex = startIndex + state.itemsPerPage;
    
    if (startIndex >= allItems.length) return [];
    
    return allItems.sublist(
      startIndex,
      endIndex > allItems.length ? allItems.length : endIndex,
    );
  }

  Future<bool> addProduct(ProductEntity product) async {
    try {
      final ok = await createProduct(product);
      if (ok) {
        final updated = [...state.products, product];
        state = state.copyWith(products: updated);
      }
      return ok;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Search products with query and filters
  Future<void> searchProductsWithQuery({
    required String query,
    required String sellerId,
    String? category,
    String? status,
  }) async {
    try {
      state = state.copyWith(
        isSearching: true,
        searchQuery: query,
        selectedCategory: category,
        selectedStatus: status,
        isSearchMode: query.isNotEmpty || category != null || status != null,
      );

      final results = await searchProducts(
        query: query,
        sellerId: sellerId,
        category: category,
        status: status,
      );

      state = state.copyWith(
        isSearching: false,
        searchResults: results,
      );
    } catch (e) {
      state = state.copyWith(
        isSearching: false,
        error: e.toString(),
      );
    }
  }

  /// Clear search and return to normal product list
  void clearSearch() {
    state = state.copyWith(
      isSearchMode: false,
      searchQuery: '',
      searchResults: [],
      selectedCategory: null,
      selectedStatus: null,
    );
  }

  /// Clear search and ensure products are loaded
  Future<void> clearSearchAndLoadProducts(String sellerId) async {
    state = state.copyWith(
      isSearchMode: false,
      searchQuery: '',
      searchResults: [],
      selectedCategory: null,
      selectedStatus: null,
      // Reset all filter state
      selectedCategories: const <String>{},
      selectedStatuses: const <String>{},
      selectedTags: const <String>{},
      minPrice: 0.0,
      maxPrice: 1000000.0,
      hasHalalCertification: false,
      isOrganic: false,
    );
    
    // If products list is empty, load products
    if (state.products.isEmpty) {
      await loadProducts(sellerId);
    }
  }

  /// Update search filters without changing query
  Future<void> updateSearchFilters({
    required String sellerId,
    String? category,
    String? status,
  }) async {
    await searchProductsWithQuery(
      query: state.searchQuery,
      sellerId: sellerId,
      category: category,
      status: status,
    );
  }

  Future<bool> editProduct(ProductEntity product) async {
    try {
      final ok = await updateProduct(product);
      if (ok) {
        final updated = state.products.map((p) => p.id == product.id ? product : p).toList();
        state = state.copyWith(products: updated);
      }
      return ok;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  Future<bool> removeProduct(String id) async {
    try {
      final ok = await deleteProduct(id);
      if (ok) {
        final updated = state.products.where((p) => p.id != id).toList();
        state = state.copyWith(products: updated);
      }
      return ok;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Filter products with complex parameters
  Future<void> filterProductsWithParams({
    required String sellerId,
    String? query,
    String? category,
    String? status,
    List<String>? tags,
    double? minPrice,
    double? maxPrice,
    bool? hasHalalCertification,
    bool? isOrganic,
    String sortBy = 'name',
    String sortOrder = 'asc',
  }) async {
    try {
      // Save filter state for persistence
      final selectedCategories = category != null ? {category} : <String>{};
      final selectedStatuses = status != null ? {status} : <String>{};
      final selectedTagsSet = tags?.toSet() ?? <String>{};
      
      state = state.copyWith(
        isSearching: true,
        searchQuery: query ?? '',
        selectedCategory: category,
        selectedStatus: status,
        isSearchMode: true,
        // Save filter state
        selectedCategories: selectedCategories,
        selectedStatuses: selectedStatuses,
        selectedTags: selectedTagsSet,
        minPrice: minPrice ?? 0.0,
        maxPrice: maxPrice ?? 1000000.0,
        hasHalalCertification: hasHalalCertification ?? false,
        isOrganic: isOrganic ?? false,
      );

      final results = await filterProducts(
        sellerId: sellerId,
        query: query,
        category: category,
        status: status,
        tags: tags,
        minPrice: minPrice,
        maxPrice: maxPrice,
        sortBy: sortBy,
        sortOrder: sortOrder,
      );

      state = state.copyWith(
        isSearching: false,
        searchResults: results,
      );
    } catch (e) {
      state = state.copyWith(
        isSearching: false,
        error: e.toString(),
      );
    }
  }

  /// Load product statistics
  Future<void> loadProductStatistics(String sellerId) async {
    try {
      state = state.copyWith(isLoadingStatistics: true);
      
      final statistics = await getProductStatistics(sellerId);
      
      state = state.copyWith(
        isLoadingStatistics: false,
        productStatistics: statistics,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingStatistics: false,
        error: e.toString(),
      );
    }
  }

  /// Get available categories for seller
  Future<List<String>> getAvailableCategories(String sellerId) async {
    try {
      final repository = filterProducts.repository;
      return await repository.getAvailableCategories(sellerId);
    } catch (e) {
      return [];
    }
  }

  /// Get available tags for seller
  Future<List<String>> getAvailableTags(String sellerId) async {
    try {
      final repository = filterProducts.repository;
      return await repository.getAvailableTags(sellerId);
    } catch (e) {
      return [];
    }
  }

  /// Get price range for seller
  Future<Map<String, double>> getPriceRange(String sellerId) async {
    try {
      final repository = filterProducts.repository;
      return await repository.getPriceRange(sellerId);
    } catch (e) {
      return {
        'min_price': 0.0,
        'max_price': 1000000.0,
      };
    }
  }
}