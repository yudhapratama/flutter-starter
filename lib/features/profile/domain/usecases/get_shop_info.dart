import '../entities/shop_entity.dart';
import '../repositories/shop_repository.dart';

/// Use case untuk mendapatkan informasi toko
/// 
/// Use case ini mengelola logika bisnis untuk mengambil
/// data toko berdasarkan seller ID atau shop ID
class GetShopInfo {
  final ShopRepository _repository;

  const GetShopInfo(this._repository);

  /// Mendapatkan toko berdasarkan seller ID
  /// 
  /// [sellerId] ID seller pemilik toko
  /// Returns [ShopEntity] jika berhasil
  /// Throws [Exception] jika terjadi error
  Future<ShopEntity> getBysellerId(String sellerId) async {
    try {
      return await _repository.getShopBySellerId(sellerId);
    } catch (e) {
      throw Exception('Failed to get shop by seller ID: $e');
    }
  }

  /// Mendapatkan toko berdasarkan shop ID
  /// 
  /// [shopId] ID toko
  /// Returns [ShopEntity] jika berhasil
  /// Throws [Exception] jika terjadi error
  Future<ShopEntity> getById(String shopId) async {
    try {
      return await _repository.getShopById(shopId);
    } catch (e) {
      throw Exception('Failed to get shop by ID: $e');
    }
  }

  /// Mendapatkan statistik toko
  /// 
  /// [shopId] ID toko
  /// Returns [Map<String, dynamic>] statistik toko
  /// Throws [Exception] jika terjadi error
  Future<Map<String, dynamic>> getStatistics(String shopId) async {
    try {
      return await _repository.getShopStatistics(shopId);
    } catch (e) {
      throw Exception('Failed to get shop statistics: $e');
    }
  }

  /// Mendapatkan daftar kategori yang tersedia
  /// 
  /// Returns [List<String>] daftar kategori
  /// Throws [Exception] jika terjadi error
  Future<List<String>> getAvailableCategories() async {
    try {
      return await _repository.getAvailableCategories();
    } catch (e) {
      throw Exception('Failed to get available categories: $e');
    }
  }
}