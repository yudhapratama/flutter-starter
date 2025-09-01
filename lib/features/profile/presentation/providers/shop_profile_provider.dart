import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/shop_entity.dart';
import '../../domain/entities/address_entity.dart';
import '../../domain/usecases/get_shop_info.dart';
import '../../domain/usecases/update_shop_info.dart';
import '../../data/repositories_impl/shop_repository_impl.dart';
import '../../data/datasources/shop_remote_datasource.dart';

// Provider untuk datasource
final shopRemoteDatasourceProvider = Provider<ShopRemoteDatasource>((ref) {
  return const ShopRemoteDatasourceImpl();
});

// Provider untuk repository
final shopRepositoryProvider = Provider((ref) {
  final remoteDatasource = ref.read(shopRemoteDatasourceProvider);
  return ShopRepositoryImpl(remoteDatasource: remoteDatasource);
});

// Provider untuk use cases
final getShopInfoProvider = Provider((ref) {
  final repository = ref.read(shopRepositoryProvider);
  return GetShopInfo(repository);
});

final updateShopInfoProvider = Provider((ref) {
  final repository = ref.read(shopRepositoryProvider);
  return UpdateShopInfo(repository);
});

// State classes
class ShopProfileState {
  final ShopEntity? shop;
  final bool isLoading;
  final String? error;
  final bool isUpdating;
  final Map<String, dynamic>? statistics;
  final List<String>? availableCategories;

  const ShopProfileState({
    this.shop,
    this.isLoading = false,
    this.error,
    this.isUpdating = false,
    this.statistics,
    this.availableCategories,
  });

  ShopProfileState copyWith({
    ShopEntity? shop,
    bool? isLoading,
    String? error,
    bool? isUpdating,
    Map<String, dynamic>? statistics,
    List<String>? availableCategories,
  }) {
    return ShopProfileState(
      shop: shop ?? this.shop,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isUpdating: isUpdating ?? this.isUpdating,
      statistics: statistics ?? this.statistics,
      availableCategories: availableCategories ?? this.availableCategories,
    );
  }
}

// Notifier untuk shop profile
class ShopProfileNotifier extends StateNotifier<ShopProfileState> {
  final GetShopInfo _getShopInfo;
  final UpdateShopInfo _updateShopInfo;

  ShopProfileNotifier(
    this._getShopInfo,
    this._updateShopInfo,
  ) : super(const ShopProfileState());

  // Get shop by seller ID
  Future<void> getShopBySellerId(String sellerId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final shop = await _getShopInfo.getBysellerId(sellerId);
      state = state.copyWith(
        shop: shop,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Get shop by shop ID
  Future<void> getShopById(String shopId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final shop = await _getShopInfo.getById(shopId);
      state = state.copyWith(
        shop: shop,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Get shop statistics
  Future<void> getShopStatistics(String shopId) async {
    try {
      final statistics = await _getShopInfo.getStatistics(shopId);
      state = state.copyWith(statistics: statistics);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // Get available categories
  Future<void> getAvailableCategories() async {
    try {
      final categories = await _getShopInfo.getAvailableCategories();
      state = state.copyWith(availableCategories: categories);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // Create new shop
  Future<bool> createShop({
    required String name,
    required String description,
    required String address,
    required String city,
    required String province,
    required String postalCode,
    required String phone,
    required String email,
    String? website,
    Map<String, String>? socialMedia,
    Map<String, String>? businessHours,
    List<String>? categories,
  }) async {
    state = state.copyWith(isUpdating: true, error: null);
    
    try {
      // Create primary address
      final primaryAddress = AddressEntity(
        id: '1',
        shopId: '',
        label: 'Alamat Utama',
        address: address,
        city: city,
        province: province,
        postalCode: postalCode,
        phone: phone,
        latitude: null,
        longitude: null,
        isPrimary: true,
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      final shopEntity = ShopEntity(
        id: '',
        sellerId: '',
        name: name,
        description: description,
        addresses: [primaryAddress],
        phone: phone,
        email: email,
        website: website,
        socialMedia: socialMedia ?? {},
        businessHours: businessHours ?? {},
        categories: categories ?? [],
        banner: null,
        rating: 0.0,
        totalReviews: 0,
        totalProducts: 0,
        totalOrders: 0,
        revenue: 0.0,
        isActive: true,
        isVerified: false,
        status: 'pending',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      final newShop = await _updateShopInfo.create(shopEntity);
      
      state = state.copyWith(
        shop: newShop,
        isUpdating: false,
      );
      
      return true;
    } catch (e) {
      state = state.copyWith(
        isUpdating: false,
        error: e.toString(),
      );
      return false;
    }
  }

  // Update shop info
  Future<bool> updateShop({
    String? name,
    String? description,
    String? phone,
    String? email,
    String? website,
    Map<String, String>? socialMedia,
    Map<String, String>? businessHours,
    List<String>? categories,
  }) async {
    state = state.copyWith(isUpdating: true, error: null);
    
    try {
      if (state.shop == null) {
        throw Exception('No shop found');
      }
      
      final updatedShop = state.shop!.copyWith(
        name: name ?? state.shop!.name,
        description: description ?? state.shop!.description,
        phone: phone ?? state.shop!.phone,
        email: email ?? state.shop!.email,
        website: website ?? state.shop!.website,
        socialMedia: socialMedia ?? state.shop!.socialMedia,
        businessHours: businessHours ?? state.shop!.businessHours,
        categories: categories ?? state.shop!.categories,
        updatedAt: DateTime.now(),
      );
      
      final result = await _updateShopInfo.call(updatedShop);
      
      state = state.copyWith(
        shop: result,
        isUpdating: false,
      );
      
      return true;
    } catch (e) {
      state = state.copyWith(
        isUpdating: false,
        error: e.toString(),
      );
      return false;
    }
  }

  // Toggle shop status (active/inactive)
  Future<bool> toggleShopStatus() async {
    state = state.copyWith(isUpdating: true, error: null);
    
    try {
      if (state.shop == null) {
        throw Exception('No shop found');
      }
      
      final result = await _updateShopInfo.toggleStatus(
         state.shop!.id,
         !state.shop!.isActive,
       );
       
       // Update the shop status in state
       final updatedShop = state.shop!.copyWith(
         isActive: !state.shop!.isActive,
         updatedAt: DateTime.now(),
       );
      
      if (result) {
        state = state.copyWith(
          shop: updatedShop,
          isUpdating: false,
        );
      } else {
        state = state.copyWith(isUpdating: false);
      }
      
      return result;
    } catch (e) {
      state = state.copyWith(
        isUpdating: false,
        error: e.toString(),
      );
      return false;
    }
  }

  // Upload shop logo
  Future<bool> uploadLogo(String imagePath) async {
    state = state.copyWith(isUpdating: true, error: null);
    
    try {
      if (state.shop == null) {
        throw Exception('No shop found');
      }
      
      // TODO: Implement actual logo upload through repository
      // For now, just update the shop with a mock logo URL
      final updatedShop = state.shop!.copyWith(
        logo: 'assets/images/placeholder_logo.png', // Mock URL
        updatedAt: DateTime.now(),
      );
      
      final result = await _updateShopInfo.call(updatedShop);
      state = state.copyWith(
        shop: result,
        isUpdating: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isUpdating: false,
        error: e.toString(),
      );
      return false;
    }
  }

  // Upload shop banner
  Future<bool> uploadBanner(String imagePath) async {
    state = state.copyWith(isUpdating: true, error: null);
    
    try {
      if (state.shop == null) {
        throw Exception('No shop found');
      }
      
      // TODO: Implement actual banner upload through repository
      // For now, just update the shop with a mock banner URL
      final updatedShop = state.shop!.copyWith(
        banner: 'assets/images/placeholder_banner.png', // Mock URL
        updatedAt: DateTime.now(),
      );
      
      final result = await _updateShopInfo.call(updatedShop);
      state = state.copyWith(
        shop: result,
        isUpdating: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isUpdating: false,
        error: e.toString(),
      );
      return false;
    }
  }

  // Add new address
  Future<bool> addAddress({
    required String label,
    required String address,
    required String city,
    required String province,
    required String postalCode,
    required String phone,
    double? latitude,
    double? longitude,
    bool isPrimary = false,
  }) async {
    state = state.copyWith(isUpdating: true, error: null);
    
    try {
      if (state.shop == null) {
        throw Exception('No shop found');
      }
      
      final newAddress = AddressEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        shopId: state.shop!.id,
        label: label,
        address: address,
        city: city,
        province: province,
        postalCode: postalCode,
        phone: phone,
        latitude: latitude,
        longitude: longitude,
        isPrimary: isPrimary,
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      List<AddressEntity> updatedAddresses = List.from(state.shop!.addresses);
      
      // If this is set as primary, make all others non-primary
      if (isPrimary) {
        updatedAddresses = updatedAddresses.map((addr) => 
          addr.copyWith(isPrimary: false)
        ).toList();
      }
      
      updatedAddresses.add(newAddress);
      
      final updatedShop = state.shop!.copyWith(
        addresses: updatedAddresses,
        updatedAt: DateTime.now(),
      );
      
      final result = await _updateShopInfo.call(updatedShop);
      
      state = state.copyWith(
        shop: result,
        isUpdating: false,
      );
      
      return true;
    } catch (e) {
      state = state.copyWith(
        isUpdating: false,
        error: e.toString(),
      );
      return false;
    }
  }
  
  // Update address
  Future<bool> updateAddress({
    required String addressId,
    String? label,
    String? address,
    String? city,
    String? province,
    String? postalCode,
    String? phone,
    double? latitude,
    double? longitude,
    bool? isPrimary,
  }) async {
    state = state.copyWith(isUpdating: true, error: null);
    
    try {
      if (state.shop == null) {
        throw Exception('No shop found');
      }
      
      List<AddressEntity> updatedAddresses = state.shop!.addresses.map((addr) {
        if (addr.id == addressId) {
          return addr.copyWith(
            label: label ?? addr.label,
            address: address ?? addr.address,
            city: city ?? addr.city,
            province: province ?? addr.province,
            postalCode: postalCode ?? addr.postalCode,
            phone: phone ?? addr.phone,
            latitude: latitude ?? addr.latitude,
            longitude: longitude ?? addr.longitude,
            isPrimary: isPrimary ?? addr.isPrimary,
            updatedAt: DateTime.now(),
          );
        }
        return addr;
      }).toList();
      
      // If this address is set as primary, make all others non-primary
      if (isPrimary == true) {
        updatedAddresses = updatedAddresses.map((addr) => 
          addr.id == addressId ? addr : addr.copyWith(isPrimary: false)
        ).toList();
      }
      
      final updatedShop = state.shop!.copyWith(
        addresses: updatedAddresses,
        updatedAt: DateTime.now(),
      );
      
      final result = await _updateShopInfo.call(updatedShop);
      
      state = state.copyWith(
        shop: result,
        isUpdating: false,
      );
      
      return true;
    } catch (e) {
      state = state.copyWith(
        isUpdating: false,
        error: e.toString(),
      );
      return false;
    }
  }
  
  // Set primary address
  Future<bool> setPrimaryAddress(String addressId) async {
    state = state.copyWith(isUpdating: true, error: null);
    
    try {
      if (state.shop == null) {
        throw Exception('No shop found');
      }
      
      final updatedAddresses = state.shop!.addresses.map((addr) => 
        addr.copyWith(
          isPrimary: addr.id == addressId,
          updatedAt: addr.id == addressId ? DateTime.now() : addr.updatedAt,
        )
      ).toList();
      
      final updatedShop = state.shop!.copyWith(
        addresses: updatedAddresses,
        updatedAt: DateTime.now(),
      );
      
      final result = await _updateShopInfo.call(updatedShop);
      
      state = state.copyWith(
        shop: result,
        isUpdating: false,
      );
      
      return true;
    } catch (e) {
      state = state.copyWith(
        isUpdating: false,
        error: e.toString(),
      );
      return false;
    }
  }
  
  // Delete address
  Future<bool> deleteAddress(String addressId) async {
    state = state.copyWith(isUpdating: true, error: null);
    
    try {
      if (state.shop == null) {
        throw Exception('No shop found');
      }
      
      final addressToDelete = state.shop!.addresses.firstWhere(
        (addr) => addr.id == addressId,
        orElse: () => throw Exception('Address not found'),
      );
      
      // Cannot delete primary address if it's the only one
      if (addressToDelete.isPrimary && state.shop!.addresses.length == 1) {
        throw Exception('Cannot delete the only address');
      }
      
      final updatedAddresses = state.shop!.addresses
          .where((addr) => addr.id != addressId)
          .toList();
      
      // If deleted address was primary, make the first remaining address primary
      if (addressToDelete.isPrimary && updatedAddresses.isNotEmpty) {
        updatedAddresses[0] = updatedAddresses[0].copyWith(
          isPrimary: true,
          updatedAt: DateTime.now(),
        );
      }
      
      final updatedShop = state.shop!.copyWith(
        addresses: updatedAddresses,
        updatedAt: DateTime.now(),
      );
      
      final result = await _updateShopInfo.call(updatedShop);
      
      state = state.copyWith(
        shop: result,
        isUpdating: false,
      );
      
      return true;
    } catch (e) {
      state = state.copyWith(
        isUpdating: false,
        error: e.toString(),
      );
      return false;
    }
  }

  // Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Provider untuk shop profile notifier
final shopProfileNotifierProvider = StateNotifierProvider<ShopProfileNotifier, ShopProfileState>((ref) {
  final getShopInfo = ref.read(getShopInfoProvider);
  final updateShopInfo = ref.read(updateShopInfoProvider);
  return ShopProfileNotifier(getShopInfo, updateShopInfo);
});