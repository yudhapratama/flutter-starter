import '../../domain/entities/product_entity.dart';

/// State untuk fitur Product
class ProductState {
  final bool isLoading;
  final bool isLoadingMore;
  final bool isSearching;
  final bool isLoadingStatistics;
  final List<ProductEntity> products;
  final List<ProductEntity> searchResults;
  final String? error;
  final int currentPage;
  final bool hasMore;
  final int itemsPerPage;
  final String searchQuery;
  final String? selectedCategory;
  final String? selectedStatus;
  final bool isSearchMode;
  final Map<String, int>? productStatistics;
  
  // Filter state persistence
  final Set<String> selectedCategories;
  final Set<String> selectedStatuses;
  final Set<String> selectedTags;
  final double minPrice;
  final double maxPrice;
  final bool hasHalalCertification;
  final bool isOrganic;

  const ProductState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isSearching = false,
    this.isLoadingStatistics = false,
    this.products = const [],
    this.searchResults = const [],
    this.error,
    this.currentPage = 1,
    this.hasMore = true,
    this.itemsPerPage = 10,
    this.searchQuery = '',
    this.selectedCategory,
    this.selectedStatus,
    this.isSearchMode = false,
    this.productStatistics,
    this.selectedCategories = const {},
    this.selectedStatuses = const {},
    this.selectedTags = const {},
    this.minPrice = 0.0,
    this.maxPrice = 1000000.0,
    this.hasHalalCertification = false,
    this.isOrganic = false,
  });

  /// Get current displayed products (search results or regular products)
  List<ProductEntity> get displayedProducts => isSearchMode ? searchResults : products;

  ProductState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    bool? isSearching,
    bool? isLoadingStatistics,
    List<ProductEntity>? products,
    List<ProductEntity>? searchResults,
    String? error,
    int? currentPage,
    bool? hasMore,
    int? itemsPerPage,
    String? searchQuery,
    String? selectedCategory,
    String? selectedStatus,
    bool? isSearchMode,
    Map<String, int>? productStatistics,
    Set<String>? selectedCategories,
    Set<String>? selectedStatuses,
    Set<String>? selectedTags,
    double? minPrice,
    double? maxPrice,
    bool? hasHalalCertification,
    bool? isOrganic,
  }) {
    return ProductState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isSearching: isSearching ?? this.isSearching,
      isLoadingStatistics: isLoadingStatistics ?? this.isLoadingStatistics,
      products: products ?? this.products,
      searchResults: searchResults ?? this.searchResults,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      isSearchMode: isSearchMode ?? this.isSearchMode,
      productStatistics: productStatistics ?? this.productStatistics,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      selectedStatuses: selectedStatuses ?? this.selectedStatuses,
      selectedTags: selectedTags ?? this.selectedTags,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      hasHalalCertification: hasHalalCertification ?? this.hasHalalCertification,
      isOrganic: isOrganic ?? this.isOrganic,
    );
  }
}