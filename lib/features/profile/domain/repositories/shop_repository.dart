import '../entities/shop_entity.dart';

/// Repository contract untuk operasi shop/toko
/// 
/// Interface ini mendefinisikan kontrak untuk semua operasi
/// yang berkaitan dengan data toko seller
abstract class ShopRepository {
  /// Mendapatkan data toko berdasarkan seller ID
  /// 
  /// [sellerId] ID seller pemilik toko
  /// Returns [ShopEntity] jika berhasil
  /// Throws [Exception] jika terjadi error
  Future<ShopEntity> getShopBySellerId(String sellerId);

  /// Mendapatkan data toko berdasarkan shop ID
  /// 
  /// [shopId] ID toko
  /// Returns [ShopEntity] jika berhasil
  /// Throws [Exception] jika terjadi error
  Future<ShopEntity> getShopById(String shopId);

  /// Membuat toko baru
  /// 
  /// [shop] data toko yang akan dibuat
  /// Returns [ShopEntity] data toko yang sudah dibuat
  /// Throws [Exception] jika terjadi error
  Future<ShopEntity> createShop(ShopEntity shop);

  /// Memperbarui data toko
  /// 
  /// [shop] data toko yang akan diupdate
  /// Returns [ShopEntity] data toko yang sudah diupdate
  /// Throws [Exception] jika terjadi error
  Future<ShopEntity> updateShop(ShopEntity shop);

  /// Upload logo toko
  /// 
  /// [shopId] ID toko
  /// [imagePath] path file gambar yang akan diupload
  /// Returns [String] URL logo yang sudah diupload
  /// Throws [Exception] jika terjadi error
  Future<String> uploadLogo(String shopId, String imagePath);

  /// Upload banner toko
  /// 
  /// [shopId] ID toko
  /// [imagePath] path file gambar yang akan diupload
  /// Returns [String] URL banner yang sudah diupload
  /// Throws [Exception] jika terjadi error
  Future<String> uploadBanner(String shopId, String imagePath);

  /// Menghapus logo toko
  /// 
  /// [shopId] ID toko
  /// Returns [bool] true jika berhasil
  /// Throws [Exception] jika terjadi error
  Future<bool> deleteLogo(String shopId);

  /// Menghapus banner toko
  /// 
  /// [shopId] ID toko
  /// Returns [bool] true jika berhasil
  /// Throws [Exception] jika terjadi error
  Future<bool> deleteBanner(String shopId);

  /// Mengaktifkan/menonaktifkan toko
  /// 
  /// [shopId] ID toko
  /// [isActive] status aktif toko
  /// Returns [bool] true jika berhasil
  /// Throws [Exception] jika terjadi error
  Future<bool> toggleShopStatus(String shopId, bool isActive);

  /// Mendapatkan statistik toko
  /// 
  /// [shopId] ID toko
  /// Returns [Map<String, dynamic>] statistik toko
  /// Throws [Exception] jika terjadi error
  Future<Map<String, dynamic>> getShopStatistics(String shopId);

  /// Mendapatkan daftar kategori yang tersedia
  /// 
  /// Returns [List<String>] daftar kategori
  /// Throws [Exception] jika terjadi error
  Future<List<String>> getAvailableCategories();
}