import '../../../../core/utils/local_storage_service.dart';
import '../../domain/entities/product_entity.dart';
import '../models/product_model.dart';

/// Datasource lokal untuk produk menggunakan LocalStorageService
class ProductLocalDataSource {
  Future<List<ProductModel>> getAll() async {
    final data = await LocalStorageService.getProducts();
    return data.map((e) => ProductModel.fromJson(e)).toList();
  }

  Future<List<ProductModel>> getBySellerId(String sellerId) async {
    final data = await LocalStorageService.getProductsBySellerId(sellerId);
    return data.map((e) => ProductModel.fromJson(e)).toList();
  }

  Future<ProductModel?> getById(String id) async {
    final data = await LocalStorageService.getProducts();
    final map = data.firstWhere((e) => e['id'] == id, orElse: () => {});
    if (map.isEmpty) return null;
    return ProductModel.fromJson(map);
  }

  Future<bool> save(ProductEntity product) async {
    final model = ProductModel(
      id: product.id,
      sellerId: product.sellerId,
      name: product.name,
      description: product.description,
      price: product.price,
      stock: product.stock,
      category: product.category,
      images: product.images,
      mainImageIndex: product.mainImageIndex,
      sku: product.sku,
      hasDiscount: product.hasDiscount,
      discountPrice: product.discountPrice,
      discountStartDate: product.discountStartDate,
      discountEndDate: product.discountEndDate,
      minOrder: product.minOrder,
      maxOrder: product.maxOrder,
      weightInGrams: product.weightInGrams,
      length: product.length,
      width: product.width,
      height: product.height,
      status: product.status,
      hasHalalCertification: product.hasHalalCertification,
      tags: product.tags,
      createdAt: product.createdAt,
      updatedAt: product.updatedAt,
    );
    await LocalStorageService.saveProduct(model.toJson());
    return true;
  }

  Future<bool> delete(String id) async {
    await LocalStorageService.deleteProduct(id);
    return true;
  }
}