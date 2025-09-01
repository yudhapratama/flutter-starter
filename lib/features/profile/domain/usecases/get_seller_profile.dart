import '../entities/seller_entity.dart';
import '../repositories/seller_repository.dart';

/// Use case untuk mendapatkan seller profile
/// 
/// Use case ini mengelola logika bisnis untuk mengambil
/// data profile seller berdasarkan ID atau current user
class GetSellerProfile {
  final SellerRepository _repository;

  const GetSellerProfile(this._repository);

  /// Mendapatkan seller profile berdasarkan ID
  /// 
  /// [sellerId] ID seller yang akan diambil profilenya
  /// Returns [SellerEntity] jika berhasil
  /// Throws [Exception] jika terjadi error
  Future<SellerEntity> call(String sellerId) async {
    try {
      return await _repository.getSellerProfile(sellerId);
    } catch (e) {
      throw Exception('Failed to get seller profile: $e');
    }
  }

  /// Mendapatkan seller profile yang sedang login
  /// 
  /// Returns [SellerEntity] jika berhasil
  /// Throws [Exception] jika terjadi error
  Future<SellerEntity> getCurrentProfile() async {
    try {
      return await _repository.getCurrentSellerProfile();
    } catch (e) {
      throw Exception('Failed to get current seller profile: $e');
    }
  }
}