import '../entities/seller_entity.dart';

/// Repository contract untuk operasi seller profile
/// 
/// Interface ini mendefinisikan kontrak untuk semua operasi
/// yang berkaitan dengan data seller profile
abstract class SellerRepository {
  /// Mendapatkan data seller profile berdasarkan ID
  /// 
  /// Returns [SellerEntity] jika berhasil
  /// Throws [Exception] jika terjadi error
  Future<SellerEntity> getSellerProfile(String sellerId);

  /// Mendapatkan data seller profile yang sedang login
  /// 
  /// Returns [SellerEntity] jika berhasil
  /// Throws [Exception] jika terjadi error
  Future<SellerEntity> getCurrentSellerProfile();

  /// Memperbarui data seller profile
  /// 
  /// [seller] data seller yang akan diupdate
  /// Returns [SellerEntity] data seller yang sudah diupdate
  /// Throws [Exception] jika terjadi error
  Future<SellerEntity> updateSellerProfile(SellerEntity seller);

  /// Upload avatar seller
  /// 
  /// [sellerId] ID seller
  /// [imagePath] path file gambar yang akan diupload
  /// Returns [String] URL avatar yang sudah diupload
  /// Throws [Exception] jika terjadi error
  Future<String> uploadAvatar(String sellerId, String imagePath);

  /// Menghapus avatar seller
  /// 
  /// [sellerId] ID seller
  /// Returns [bool] true jika berhasil
  /// Throws [Exception] jika terjadi error
  Future<bool> deleteAvatar(String sellerId);

  /// Mengubah password seller
  /// 
  /// [sellerId] ID seller
  /// [oldPassword] password lama
  /// [newPassword] password baru
  /// Returns [bool] true jika berhasil
  /// Throws [Exception] jika terjadi error
  Future<bool> changePassword(String sellerId, String oldPassword, String newPassword);

  /// Verifikasi email seller
  /// 
  /// [sellerId] ID seller
  /// [verificationCode] kode verifikasi
  /// Returns [bool] true jika berhasil
  /// Throws [Exception] jika terjadi error
  Future<bool> verifyEmail(String sellerId, String verificationCode);

  /// Mengirim ulang kode verifikasi email
  /// 
  /// [sellerId] ID seller
  /// Returns [bool] true jika berhasil
  /// Throws [Exception] jika terjadi error
  Future<bool> resendEmailVerification(String sellerId);
}