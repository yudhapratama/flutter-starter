import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

/// Use case untuk mendapatkan produk berdasarkan seller ID
class GetProductsBySeller {
  final ProductRepository repository;

  const GetProductsBySeller(this.repository);

  Future<List<ProductEntity>> call(String sellerId) async {
    return await repository.getProductsBySellerId(sellerId);
  }
}