import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/seller_entity.dart';
import '../../domain/usecases/get_seller_profile.dart';
import '../../domain/usecases/update_seller_profile.dart';
import '../../data/repositories_impl/seller_repository_impl.dart';
import '../../data/datasources/seller_remote_datasource.dart';
// Providers
final sellerRemoteDatasourceProvider = Provider<SellerRemoteDatasource>((ref) {
  return const SellerRemoteDatasourceImpl();
});

final sellerRepositoryProvider = Provider<SellerRepositoryImpl>((ref) {
  final remoteDatasource = ref.read(sellerRemoteDatasourceProvider);
  return SellerRepositoryImpl(remoteDatasource: remoteDatasource);
});

// Provider untuk use cases
final getSellerProfileProvider = Provider((ref) {
  final repository = ref.read(sellerRepositoryProvider);
  return GetSellerProfile(repository);
});

final updateSellerProfileProvider = Provider((ref) {
  final repository = ref.read(sellerRepositoryProvider);
  return UpdateSellerProfile(repository);
});

// State classes
class SellerProfileState {
  final SellerEntity? seller;
  final bool isLoading;
  final String? error;
  final bool isUpdating;

  const SellerProfileState({
    this.seller,
    this.isLoading = false,
    this.error,
    this.isUpdating = false,
  });

  SellerProfileState copyWith({
    SellerEntity? seller,
    bool? isLoading,
    String? error,
    bool? isUpdating,
  }) {
    return SellerProfileState(
      seller: seller ?? this.seller,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isUpdating: isUpdating ?? this.isUpdating,
    );
  }
}

// Notifier untuk seller profile
class SellerProfileNotifier extends StateNotifier<SellerProfileState> {
  final GetSellerProfile _getSellerProfile;
  final UpdateSellerProfile _updateSellerProfile;

  SellerProfileNotifier(
    this._getSellerProfile,
    this._updateSellerProfile,
  ) : super(const SellerProfileState());

  Future<void> loadProfile([String? sellerId]) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final seller = sellerId != null 
          ? await _getSellerProfile.call(sellerId)
          : await _getSellerProfile.getCurrentProfile();
      state = state.copyWith(
        seller: seller,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Update seller profile
  Future<bool> updateProfile({
    String? name,
    String? email,
    String? phoneNumber,
    String? address,
    String? city,
    String? province,
    String? postalCode,
  }) async {
    state = state.copyWith(isUpdating: true, error: null);
    
    try {
      if (state.seller == null) {
        throw Exception('No seller profile found');
      }
      
      final updatedSeller = state.seller!.copyWith(
        name: name ?? state.seller!.name,
        email: email ?? state.seller!.email,
        phone: phoneNumber ?? state.seller!.phone,
        address: address ?? state.seller!.address,
        city: city ?? state.seller!.city,
        province: province ?? state.seller!.province,
        postalCode: postalCode ?? state.seller!.postalCode,
        updatedAt: DateTime.now(),
      );
      
      final result = await _updateSellerProfile(updatedSeller);
      state = state.copyWith(
        seller: result,
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

  // Upload avatar
  Future<bool> uploadAvatar(String imagePath) async {
    state = state.copyWith(isUpdating: true, error: null);
    
    try {
      if (state.seller == null) {
        throw Exception('No seller profile found');
      }
      
      // TODO: Implement actual avatar upload through repository
      // For now, just update the seller with a mock avatar URL
      final updatedSeller = state.seller!.copyWith(
        avatar: 'assets/images/placeholder_avatar.png', // Mock URL
        updatedAt: DateTime.now(),
      );
      
      final result = await _updateSellerProfile(updatedSeller);
      state = state.copyWith(
        seller: result,
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

  // Remove avatar
  Future<bool> removeAvatar() async {
    state = state.copyWith(isUpdating: true, error: null);
    
    try {
      if (state.seller == null) {
        throw Exception('No seller profile found');
      }
      
      // TODO: Implement actual avatar removal through repository
      final updatedSeller = state.seller!.copyWith(
        avatar: null,
        updatedAt: DateTime.now(),
      );
      
      final result = await _updateSellerProfile(updatedSeller);
      state = state.copyWith(
        seller: result,
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

  // Change password
  Future<bool> changePassword(String currentPassword, String newPassword) async {
    state = state.copyWith(isUpdating: true, error: null);
    
    try {
      if (state.seller == null) {
        throw Exception('No seller profile found');
      }
      
      // TODO: Implement actual password change through repository
      // For now, just simulate success
      await Future.delayed(const Duration(milliseconds: 500));
      state = state.copyWith(isUpdating: false);
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

// Provider untuk seller profile notifier
final sellerProfileNotifierProvider = StateNotifierProvider<SellerProfileNotifier, SellerProfileState>((ref) {
  final getSellerProfile = ref.read(getSellerProfileProvider);
  final updateSellerProfile = ref.read(updateSellerProfileProvider);
  return SellerProfileNotifier(getSellerProfile, updateSellerProfile);
});