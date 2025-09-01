import '../../domain/entities/shop_entity.dart';
import '../../domain/repositories/shop_repository.dart';
import '../datasources/shop_remote_datasource.dart';
import '../models/shop_model.dart';

/// Implementasi repository untuk shop/toko
/// 
/// Kelas ini mengimplementasikan [ShopRepository] dan mengelola
/// operasi data toko melalui remote datasource
class ShopRepositoryImpl implements ShopRepository {
  final ShopRemoteDatasource _remoteDatasource;

  const ShopRepositoryImpl({
    required ShopRemoteDatasource remoteDatasource,
  }) : _remoteDatasource = remoteDatasource;

  @override
  Future<ShopEntity> getShopBySellerId(String sellerId) async {
    try {
      final shopModel = await _remoteDatasource.getShopBySellerId(sellerId);
      return shopModel.toEntity();
    } catch (e) {
      throw Exception('Failed to get shop by seller ID: $e');
    }
  }

  @override
  Future<ShopEntity> getShopById(String shopId) async {
    try {
      final shopModel = await _remoteDatasource.getShopById(shopId);
      return shopModel.toEntity();
    } catch (e) {
      throw Exception('Failed to get shop by ID: $e');
    }
  }

  @override
  Future<ShopEntity> createShop(ShopEntity shop) async {
    try {
      final shopModel = ShopModel.fromEntity(shop);
      final createdModel = await _remoteDatasource.createShop(shopModel);
      return createdModel.toEntity();
    } catch (e) {
      throw Exception('Failed to create shop: $e');
    }
  }

  @override
  Future<ShopEntity> updateShop(ShopEntity shop) async {
    try {
      final shopModel = ShopModel.fromEntity(shop);
      final updatedModel = await _remoteDatasource.updateShop(shopModel);
      return updatedModel.toEntity();
    } catch (e) {
      throw Exception('Failed to update shop: $e');
    }
  }

  @override
  Future<String> uploadLogo(String shopId, String imagePath) async {
    try {
      return await _remoteDatasource.uploadLogo(shopId, imagePath);
    } catch (e) {
      throw Exception('Failed to upload logo: $e');
    }
  }

  @override
  Future<String> uploadBanner(String shopId, String imagePath) async {
    try {
      return await _remoteDatasource.uploadBanner(shopId, imagePath);
    } catch (e) {
      throw Exception('Failed to upload banner: $e');
    }
  }

  @override
  Future<bool> deleteLogo(String shopId) async {
    try {
      return await _remoteDatasource.deleteLogo(shopId);
    } catch (e) {
      throw Exception('Failed to delete logo: $e');
    }
  }

  @override
  Future<bool> deleteBanner(String shopId) async {
    try {
      return await _remoteDatasource.deleteBanner(shopId);
    } catch (e) {
      throw Exception('Failed to delete banner: $e');
    }
  }

  @override
  Future<bool> toggleShopStatus(String shopId, bool isActive) async {
    try {
      return await _remoteDatasource.toggleShopStatus(shopId, isActive);
    } catch (e) {
      throw Exception('Failed to toggle shop status: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getShopStatistics(String shopId) async {
    try {
      return await _remoteDatasource.getShopStatistics(shopId);
    } catch (e) {
      throw Exception('Failed to get shop statistics: $e');
    }
  }

  @override
  Future<List<String>> getAvailableCategories() async {
    try {
      return await _remoteDatasource.getAvailableCategories();
    } catch (e) {
      throw Exception('Failed to get available categories: $e');
    }
  }
}