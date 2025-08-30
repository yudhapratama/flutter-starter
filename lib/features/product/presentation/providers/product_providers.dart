import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/product_local_datasource.dart';
import '../../data/repositories_impl/product_repository_impl.dart';
import '../../domain/usecases/create_product.dart';
import '../../domain/usecases/delete_product.dart';
import '../../domain/usecases/get_products_by_seller.dart';
import '../../domain/usecases/search_products.dart';
import '../../domain/usecases/update_product.dart';
import '../../domain/usecases/filter_products.dart';
import '../../domain/usecases/get_product_statistics.dart';
import 'product_state.dart';
import 'product_notifier.dart';

/// Provider untuk ProductLocalDataSource
final productLocalDataSourceProvider = Provider<ProductLocalDataSource>((ref) {
  return ProductLocalDataSource();
});

/// Provider untuk ProductRepository
final productRepositoryProvider = Provider<ProductRepositoryImpl>((ref) {
  final localDataSource = ref.watch(productLocalDataSourceProvider);
  return ProductRepositoryImpl(local: localDataSource);
});

/// Provider untuk Use Cases
final getProductsBySellerProvider = Provider<GetProductsBySeller>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return GetProductsBySeller(repository);
});

final createProductProvider = Provider<CreateProduct>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return CreateProduct(repository);
});

final updateProductProvider = Provider<UpdateProduct>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return UpdateProduct(repository);
});

final deleteProductProvider = Provider<DeleteProduct>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return DeleteProduct(repository);
});

final searchProductsProvider = Provider<SearchProducts>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return SearchProducts(repository);
});

final filterProductsProvider = Provider<FilterProducts>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return FilterProducts(repository);
});

final getProductStatisticsProvider = Provider<GetProductStatistics>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return GetProductStatistics(repository);
});

/// Main Product Notifier Provider
final productNotifierProvider = StateNotifierProvider<ProductNotifier, ProductState>((ref) {
  final getProductsBySeller = ref.read(getProductsBySellerProvider);
  final createProduct = ref.read(createProductProvider);
  final updateProduct = ref.read(updateProductProvider);
  final deleteProduct = ref.read(deleteProductProvider);
  final searchProducts = ref.read(searchProductsProvider);
  final filterProducts = ref.read(filterProductsProvider);
  final getProductStatistics = ref.read(getProductStatisticsProvider);

  return ProductNotifier(
    getProductsBySeller: getProductsBySeller,
    createProduct: createProduct,
    updateProduct: updateProduct,
    deleteProduct: deleteProduct,
    searchProducts: searchProducts,
    filterProducts: filterProducts,
    getProductStatistics: getProductStatistics,
  );
});