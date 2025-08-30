import '../repositories/product_repository.dart';

/// Use case untuk menghapus produk
class DeleteProduct {
  final ProductRepository repository;

  const DeleteProduct(this.repository);

  Future<bool> call(String productId) async {
    return await repository.deleteProduct(productId);
  }
}