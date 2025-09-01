import '../models/shop_model.dart';
import '../models/address_model.dart';

/// Abstract datasource untuk shop operations
/// 
/// Interface ini mendefinisikan kontrak untuk semua operasi
/// remote API yang berkaitan dengan shop/toko
abstract class ShopRemoteDatasource {
  /// Mendapatkan data toko berdasarkan seller ID
  Future<ShopModel> getShopBySellerId(String sellerId);

  /// Mendapatkan data toko berdasarkan shop ID
  Future<ShopModel> getShopById(String shopId);

  /// Membuat toko baru
  Future<ShopModel> createShop(ShopModel shop);

  /// Memperbarui data toko
  Future<ShopModel> updateShop(ShopModel shop);

  /// Upload logo toko
  Future<String> uploadLogo(String shopId, String imagePath);

  /// Upload banner toko
  Future<String> uploadBanner(String shopId, String imagePath);

  /// Menghapus logo toko
  Future<bool> deleteLogo(String shopId);

  /// Menghapus banner toko
  Future<bool> deleteBanner(String shopId);

  /// Mengaktifkan/menonaktifkan toko
  Future<bool> toggleShopStatus(String shopId, bool isActive);

  /// Mendapatkan statistik toko
  Future<Map<String, dynamic>> getShopStatistics(String shopId);

  /// Mendapatkan daftar kategori yang tersedia
  Future<List<String>> getAvailableCategories();
}

/// Implementasi datasource untuk shop operations
/// 
/// Kelas ini mengimplementasikan [ShopRemoteDatasource] dan mengelola
/// semua operasi API yang berkaitan dengan shop/toko
class ShopRemoteDatasourceImpl implements ShopRemoteDatasource {
  // TODO: Inject HTTP client atau API service
  // final ApiClient _apiClient;
  
  const ShopRemoteDatasourceImpl();

  @override
  Future<ShopModel> getShopBySellerId(String sellerId) async {
    try {
      // TODO: Implement actual API call
      // final response = await _apiClient.get('/shops/seller/$sellerId');
      // return ShopModel.fromJson(response.data);
      
      // Mock data untuk development
      await Future.delayed(const Duration(milliseconds: 500));
      return ShopModel(
        id: 'shop-$sellerId',
        sellerId: sellerId,
        name: 'Toko Contoh',
        description: 'Toko online terpercaya dengan berbagai produk berkualitas',
        logo: 'assets/images/placeholder_logo.png',
        banner: 'assets/images/placeholder_banner.png',
        addresses: [
          AddressModel(
            id: 'addr-1',
            shopId: 'shop-$sellerId',
            label: 'Alamat Utama',
            address: 'Jl. Toko No. 789',
            city: 'Jakarta',
            province: 'DKI Jakarta',
            postalCode: '12345',
            phone: '+62812345678',
            latitude: -6.2088,
            longitude: 106.8456,
            isPrimary: true,
            isActive: true,
            createdAt: DateTime.now().subtract(const Duration(days: 90)),
            updatedAt: DateTime.now(),
          ),
          AddressModel(
            id: 'addr-2',
            shopId: 'shop-$sellerId',
            label: 'Gudang',
            address: 'Jl. Gudang No. 123',
            city: 'Jakarta',
            province: 'DKI Jakarta',
            postalCode: '12346',
            phone: '+62812345679',
            latitude: -6.2100,
            longitude: 106.8500,
            isPrimary: false,
            isActive: true,
            createdAt: DateTime.now().subtract(const Duration(days: 60)),
            updatedAt: DateTime.now(),
          ),
        ],
        phone: '+62812345678',
        email: 'toko@example.com',
        website: 'https://tokocontoh.com',
        socialMedia: {
          'instagram': '@tokocontoh',
          'facebook': 'Toko Contoh',
          'whatsapp': '+62812345678',
        },
        businessHours: {
          'monday': '08:00-17:00',
          'tuesday': '08:00-17:00',
          'wednesday': '08:00-17:00',
          'thursday': '08:00-17:00',
          'friday': '08:00-17:00',
          'saturday': '08:00-15:00',
          'sunday': 'Tutup',
        },
        categories: ['Elektronik', 'Fashion', 'Makanan'],
        rating: 4.5,
        totalReviews: 150,
        totalProducts: 25,
        totalOrders: 320,
        revenue: 15750000.0,
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
        updatedAt: DateTime.now(),
        isActive: true,
        isVerified: true,
        status: 'active',
      );
    } catch (e) {
      throw Exception('Failed to get shop by seller ID: $e');
    }
  }

  @override
  Future<ShopModel> getShopById(String shopId) async {
    try {
      // TODO: Implement actual API call
      // final response = await _apiClient.get('/shops/$shopId');
      // return ShopModel.fromJson(response.data);
      
      // Mock data untuk development
      await Future.delayed(const Duration(milliseconds: 500));
      return ShopModel(
        id: shopId,
        sellerId: 'seller-123',
        name: 'Toko Berdasarkan ID',
        description: 'Toko yang dicari berdasarkan ID',
        logo: 'assets/images/placeholder_logo.png',
        banner: 'assets/images/placeholder_banner.png',
        addresses: [
          AddressModel(
            id: 'addr-main',
            shopId: shopId,
            label: 'Alamat Utama',
            address: 'Jl. ID Shop No. 456',
            city: 'Bandung',
            province: 'Jawa Barat',
            postalCode: '40123',
            phone: '+62812345678',
            latitude: -6.9175,
            longitude: 107.6191,
            isPrimary: true,
            isActive: true,
            createdAt: DateTime.now().subtract(const Duration(days: 60)),
            updatedAt: DateTime.now(),
          ),
        ],
        phone: '+62812345678',
        email: 'shop@example.com',
        website: 'https://shopid.com',
        socialMedia: {
          'instagram': '@shopid',
          'facebook': 'Shop ID',
        },
        businessHours: {
          'monday': '09:00-18:00',
          'tuesday': '09:00-18:00',
          'wednesday': '09:00-18:00',
          'thursday': '09:00-18:00',
          'friday': '09:00-18:00',
          'saturday': '09:00-16:00',
          'sunday': 'Tutup',
        },
        categories: ['Fashion', 'Aksesoris'],
        rating: 4.2,
        totalReviews: 89,
        totalProducts: 15,
        totalOrders: 180,
        revenue: 8500000.0,
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        updatedAt: DateTime.now(),
        isActive: true,
        isVerified: false,
        status: 'active',
      );
    } catch (e) {
      throw Exception('Failed to get shop by ID: $e');
    }
  }

  @override
  Future<ShopModel> createShop(ShopModel shop) async {
    try {
      // TODO: Implement actual API call
      // final response = await _apiClient.post('/shops', data: shop.toJson());
      // return ShopModel.fromJson(response.data);
      
      // Mock data untuk development
      await Future.delayed(const Duration(milliseconds: 1000));
      return shop.copyWith(
        id: 'new-shop-${DateTime.now().millisecondsSinceEpoch}',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Failed to create shop: $e');
    }
  }

  @override
  Future<ShopModel> updateShop(ShopModel shop) async {
    try {
      // TODO: Implement actual API call
      // final response = await _apiClient.put('/shops/${shop.id}', data: shop.toJson());
      // return ShopModel.fromJson(response.data);
      
      // Mock data untuk development
      await Future.delayed(const Duration(milliseconds: 800));
      return shop.copyWith(updatedAt: DateTime.now());
    } catch (e) {
      throw Exception('Failed to update shop: $e');
    }
  }

  @override
  Future<String> uploadLogo(String shopId, String imagePath) async {
    try {
      // TODO: Implement actual file upload
      // final formData = FormData.fromMap({
      //   'logo': await MultipartFile.fromFile(imagePath),
      // });
      // final response = await _apiClient.post('/shops/$shopId/logo', data: formData);
      // return response.data['logo_url'];
      
      // Mock data untuk development
      await Future.delayed(const Duration(milliseconds: 1200));
      return 'assets/images/placeholder_logo.png';
    } catch (e) {
      throw Exception('Failed to upload logo: $e');
    }
  }

  @override
  Future<String> uploadBanner(String shopId, String imagePath) async {
    try {
      // TODO: Implement actual file upload
      // final formData = FormData.fromMap({
      //   'banner': await MultipartFile.fromFile(imagePath),
      // });
      // final response = await _apiClient.post('/shops/$shopId/banner', data: formData);
      // return response.data['banner_url'];
      
      // Mock data untuk development
      await Future.delayed(const Duration(milliseconds: 1500));
      return 'assets/images/placeholder_banner.png';
    } catch (e) {
      throw Exception('Failed to upload banner: $e');
    }
  }

  @override
  Future<bool> deleteLogo(String shopId) async {
    try {
      // TODO: Implement actual API call
      // await _apiClient.delete('/shops/$shopId/logo');
      
      // Mock data untuk development
      await Future.delayed(const Duration(milliseconds: 500));
      return true;
    } catch (e) {
      throw Exception('Failed to delete logo: $e');
    }
  }

  @override
  Future<bool> deleteBanner(String shopId) async {
    try {
      // TODO: Implement actual API call
      // await _apiClient.delete('/shops/$shopId/banner');
      
      // Mock data untuk development
      await Future.delayed(const Duration(milliseconds: 500));
      return true;
    } catch (e) {
      throw Exception('Failed to delete banner: $e');
    }
  }

  @override
  Future<bool> toggleShopStatus(String shopId, bool isActive) async {
    try {
      // TODO: Implement actual API call
      // await _apiClient.put('/shops/$shopId/status', data: {'is_active': isActive});
      
      // Mock data untuk development
      await Future.delayed(const Duration(milliseconds: 600));
      return true;
    } catch (e) {
      throw Exception('Failed to toggle shop status: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getShopStatistics(String shopId) async {
    try {
      // TODO: Implement actual API call
      // final response = await _apiClient.get('/shops/$shopId/statistics');
      // return response.data;
      
      // Mock data untuk development
      await Future.delayed(const Duration(milliseconds: 700));
      return {
        'total_products': 25,
        'total_orders': 150,
        'total_revenue': 15000000,
        'average_rating': 4.5,
        'total_reviews': 89,
        'monthly_visitors': 1250,
        'conversion_rate': 3.2,
      };
    } catch (e) {
      throw Exception('Failed to get shop statistics: $e');
    }
  }

  @override
  Future<List<String>> getAvailableCategories() async {
    try {
      // TODO: Implement actual API call
      // final response = await _apiClient.get('/categories');
      // return List<String>.from(response.data);
      
      // Mock data untuk development
      await Future.delayed(const Duration(milliseconds: 300));
      return [
        'Elektronik',
        'Fashion',
        'Makanan & Minuman',
        'Kesehatan & Kecantikan',
        'Rumah & Taman',
        'Olahraga & Outdoor',
        'Otomotif',
        'Buku & Alat Tulis',
        'Mainan & Hobi',
        'Aksesoris',
      ];
    } catch (e) {
      throw Exception('Failed to get available categories: $e');
    }
  }
}