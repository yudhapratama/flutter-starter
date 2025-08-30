import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

/// Use case untuk mendapatkan semua produk milik seller
class GetProducts {
  final ProductRepository repository;

  GetProducts(this.repository);

  /// Eksekusi use case untuk mendapatkan produk berdasarkan seller ID
  Future<List<ProductEntity>> call(String sellerId) async {
    return await repository.getProductsBySellerId(sellerId);
  }
}