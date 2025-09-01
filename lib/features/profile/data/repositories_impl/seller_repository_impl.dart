import '../../domain/entities/seller_entity.dart';
import '../../domain/repositories/seller_repository.dart';
import '../datasources/seller_remote_datasource.dart';
import '../models/seller_model.dart';

/// Implementasi repository untuk seller profile
/// 
/// Kelas ini mengimplementasikan [SellerRepository] dan mengelola
/// operasi data seller melalui remote datasource
class SellerRepositoryImpl implements SellerRepository {
  final SellerRemoteDatasource _remoteDatasource;

  const SellerRepositoryImpl({
    required SellerRemoteDatasource remoteDatasource,
  }) : _remoteDatasource = remoteDatasource;

  @override
  Future<SellerEntity> getSellerProfile(String sellerId) async {
    try {
      final sellerModel = await _remoteDatasource.getSellerProfile(sellerId);
      return sellerModel.toEntity();
    } catch (e) {
      throw Exception('Failed to get seller profile: $e');
    }
  }

  @override
  Future<SellerEntity> getCurrentSellerProfile() async {
    try {
      final sellerModel = await _remoteDatasource.getCurrentSellerProfile();
      return sellerModel.toEntity();
    } catch (e) {
      throw Exception('Failed to get current seller profile: $e');
    }
  }

  @override
  Future<SellerEntity> updateSellerProfile(SellerEntity seller) async {
    try {
      final sellerModel = SellerModel.fromEntity(seller);
      final updatedModel = await _remoteDatasource.updateSellerProfile(sellerModel);
      return updatedModel.toEntity();
    } catch (e) {
      throw Exception('Failed to update seller profile: $e');
    }
  }

  @override
  Future<String> uploadAvatar(String sellerId, String imagePath) async {
    try {
      return await _remoteDatasource.uploadAvatar(sellerId, imagePath);
    } catch (e) {
      throw Exception('Failed to upload avatar: $e');
    }
  }

  @override
  Future<bool> deleteAvatar(String sellerId) async {
    try {
      return await _remoteDatasource.deleteAvatar(sellerId);
    } catch (e) {
      throw Exception('Failed to delete avatar: $e');
    }
  }

  @override
  Future<bool> changePassword(String sellerId, String oldPassword, String newPassword) async {
    try {
      return await _remoteDatasource.changePassword(sellerId, oldPassword, newPassword);
    } catch (e) {
      throw Exception('Failed to change password: $e');
    }
  }

  @override
  Future<bool> verifyEmail(String sellerId, String verificationCode) async {
    try {
      return await _remoteDatasource.verifyEmail(sellerId, verificationCode);
    } catch (e) {
      throw Exception('Failed to verify email: $e');
    }
  }

  @override
  Future<bool> resendEmailVerification(String sellerId) async {
    try {
      return await _remoteDatasource.resendEmailVerification(sellerId);
    } catch (e) {
      throw Exception('Failed to resend email verification: $e');
    }
  }
}