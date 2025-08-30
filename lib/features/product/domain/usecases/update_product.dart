import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

/// Use case untuk update produk
class UpdateProduct {
  final ProductRepository repository;

  const UpdateProduct(this.repository);

  Future<bool> call(ProductEntity product) async {
    return await repository.updateProduct(product);
  }
}