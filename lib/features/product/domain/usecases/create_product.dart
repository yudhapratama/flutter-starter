import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

/// Use case untuk membuat produk baru
class CreateProduct {
  final ProductRepository repository;

  const CreateProduct(this.repository);

  Future<bool> call(ProductEntity product) async {
    return await repository.createProduct(product);
  }
}