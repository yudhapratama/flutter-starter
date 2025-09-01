import '../models/seller_model.dart';

/// Abstract datasource untuk seller profile operations
/// 
/// Interface ini mendefinisikan kontrak untuk semua operasi
/// remote API yang berkaitan dengan seller profile
abstract class SellerRemoteDatasource {
  /// Mendapatkan data seller profile berdasarkan ID
  Future<SellerModel> getSellerProfile(String sellerId);

  /// Mendapatkan data seller profile yang sedang login
  Future<SellerModel> getCurrentSellerProfile();

  /// Memperbarui data seller profile
  Future<SellerModel> updateSellerProfile(SellerModel seller);

  /// Upload avatar seller
  Future<String> uploadAvatar(String sellerId, String imagePath);

  /// Menghapus avatar seller
  Future<bool> deleteAvatar(String sellerId);

  /// Mengubah password seller
  Future<bool> changePassword(String sellerId, String oldPassword, String newPassword);

  /// Verifikasi email seller
  Future<bool> verifyEmail(String sellerId, String verificationCode);

  /// Mengirim ulang kode verifikasi email
  Future<bool> resendEmailVerification(String sellerId);
}

/// Implementasi datasource untuk seller profile operations
/// 
/// Kelas ini mengimplementasikan [SellerRemoteDatasource] dan mengelola
/// semua operasi API yang berkaitan dengan seller profile
class SellerRemoteDatasourceImpl implements SellerRemoteDatasource {
  // TODO: Inject HTTP client atau API service
  // final ApiClient _apiClient;
  
  const SellerRemoteDatasourceImpl();

  @override
  Future<SellerModel> getSellerProfile(String sellerId) async {
    try {
      // TODO: Implement actual API call
      // final response = await _apiClient.get('/sellers/$sellerId');
      // return SellerModel.fromJson(response.data);
      
      // Mock data untuk development
      await Future.delayed(const Duration(milliseconds: 500));
      return SellerModel(
        id: sellerId,
        name: 'John Doe',
        email: 'john.doe@example.com',
        phone: '+62812345678',
        avatar: 'assets/images/placeholder_avatar.png',
        address: 'Jl. Contoh No. 123',
        city: 'Jakarta',
        province: 'DKI Jakarta',
        postalCode: '12345',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now(),
        isVerified: true,
        status: 'active',
      );
    } catch (e) {
      throw Exception('Failed to get seller profile: $e');
    }
  }

  @override
  Future<SellerModel> getCurrentSellerProfile() async {
    try {
      // TODO: Implement actual API call
      // final response = await _apiClient.get('/sellers/me');
      // return SellerModel.fromJson(response.data);
      
      // Mock data untuk development
      await Future.delayed(const Duration(milliseconds: 500));
      return SellerModel(
        id: 'current-seller-id',
        name: 'Current Seller',
        email: 'current@example.com',
        phone: '+62812345678',
        avatar: 'assets/images/placeholder_avatar.png',
        address: 'Jl. Current No. 456',
        city: 'Bandung',
        province: 'Jawa Barat',
        postalCode: '40123',
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        updatedAt: DateTime.now(),
        isVerified: true,
        status: 'active',
      );
    } catch (e) {
      throw Exception('Failed to get current seller profile: $e');
    }
  }

  @override
  Future<SellerModel> updateSellerProfile(SellerModel seller) async {
    try {
      // TODO: Implement actual API call
      // final response = await _apiClient.put('/sellers/${seller.id}', data: seller.toJson());
      // return SellerModel.fromJson(response.data);
      
      // Mock data untuk development
      await Future.delayed(const Duration(milliseconds: 800));
      return seller.copyWith(updatedAt: DateTime.now());
    } catch (e) {
      throw Exception('Failed to update seller profile: $e');
    }
  }

  @override
  Future<String> uploadAvatar(String sellerId, String imagePath) async {
    try {
      // TODO: Implement actual file upload
      // final formData = FormData.fromMap({
      //   'avatar': await MultipartFile.fromFile(imagePath),
      // });
      // final response = await _apiClient.post('/sellers/$sellerId/avatar', data: formData);
      // return response.data['avatar_url'];
      
      // Mock data untuk development
      await Future.delayed(const Duration(milliseconds: 1000));
      return 'assets/images/placeholder_avatar.png';
    } catch (e) {
      throw Exception('Failed to upload avatar: $e');
    }
  }

  @override
  Future<bool> deleteAvatar(String sellerId) async {
    try {
      // TODO: Implement actual API call
      // await _apiClient.delete('/sellers/$sellerId/avatar');
      
      // Mock data untuk development
      await Future.delayed(const Duration(milliseconds: 500));
      return true;
    } catch (e) {
      throw Exception('Failed to delete avatar: $e');
    }
  }

  @override
  Future<bool> changePassword(String sellerId, String oldPassword, String newPassword) async {
    try {
      // TODO: Implement actual API call
      // await _apiClient.put('/sellers/$sellerId/password', data: {
      //   'old_password': oldPassword,
      //   'new_password': newPassword,
      // });
      
      // Mock data untuk development
      await Future.delayed(const Duration(milliseconds: 800));
      return true;
    } catch (e) {
      throw Exception('Failed to change password: $e');
    }
  }

  @override
  Future<bool> verifyEmail(String sellerId, String verificationCode) async {
    try {
      // TODO: Implement actual API call
      // await _apiClient.post('/sellers/$sellerId/verify-email', data: {
      //   'verification_code': verificationCode,
      // });
      
      // Mock data untuk development
      await Future.delayed(const Duration(milliseconds: 600));
      return true;
    } catch (e) {
      throw Exception('Failed to verify email: $e');
    }
  }

  @override
  Future<bool> resendEmailVerification(String sellerId) async {
    try {
      // TODO: Implement actual API call
      // await _apiClient.post('/sellers/$sellerId/resend-verification');
      
      // Mock data untuk development
      await Future.delayed(const Duration(milliseconds: 500));
      return true;
    } catch (e) {
      throw Exception('Failed to resend email verification: $e');
    }
  }
}