import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/shop_entity.dart';
import '../../domain/usecases/get_shop_info.dart';
import '../../domain/usecases/update_shop_info.dart';
import '../../data/repositories_impl/shop_repository_impl.dart';
import '../../data/datasources/shop_remote_datasource.dart';
// Providers
final shopRemoteDatasourceProvider = Provider<ShopRemoteDatasource>((ref) {
  return ShopRemoteDatasourceImpl();
});

final shopRepositoryProvider = Provider<ShopRepositoryImpl>((ref) {
  final remoteDatasource = ref.watch(shopRemoteDatasourceProvider);
  return ShopRepositoryImpl(remoteDatasource: remoteDatasource);
});

final getShopInfoProvider = Provider<GetShopInfo>((ref) {
  final repository = ref.watch(shopRepositoryProvider);
  return GetShopInfo(repository);
});

final updateShopInfoProvider = Provider<UpdateShopInfo>((ref) {
  final repository = ref.watch(shopRepositoryProvider);
  return UpdateShopInfo(repository);
});

// State classes
class ShopState {
  final ShopEntity? shop;
  final bool isLoading;
  final String? error;
  final bool isUpdating;
  final Map<String, dynamic>? statistics;
  final List<String>? availableCategories;

  const ShopState({
    this.shop,
    this.isLoading = false,
    this.error,
    this.isUpdating = false,
    this.statistics,
    this.availableCategories,
  });

  ShopState copyWith({
    ShopEntity? shop,
    bool? isLoading,
    String? error,
    bool? isUpdating,
    Map<String, dynamic>? statistics,
    List<String>? availableCategories,
  }) {
    return ShopState(
      shop: shop ?? this.shop,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isUpdating: isUpdating ?? this.isUpdating,
      statistics: statistics ?? this.statistics,
      availableCategories: availableCategories ?? this.availableCategories,
    );
  }
}

// Notifier
class ShopNotifier extends StateNotifier<ShopState> {
  final GetShopInfo _getShopInfo;
  final UpdateShopInfo _updateShopInfo;

  ShopNotifier(
    this._getShopInfo,
    this._updateShopInfo,
  ) : super(const ShopState());

  Future<void> loadShopBySellerId(String sellerId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final shop = await _getShopInfo.getBysellerId(sellerId);
      state = state.copyWith(
        isLoading: false,
        shop: shop,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadShopById(String shopId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final shop = await _getShopInfo.getById(shopId);
      state = state.copyWith(
        isLoading: false,
        shop: shop,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadShopStatistics(String shopId) async {
    try {
      final statistics = await _getShopInfo.getStatistics(shopId);
      state = state.copyWith(
        statistics: statistics,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> loadAvailableCategories() async {
    try {
      final categories = await _getShopInfo.getAvailableCategories();
      state = state.copyWith(availableCategories: categories);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<bool> createShop(ShopEntity shop) async {
    state = state.copyWith(isUpdating: true, error: null);
    
    try {
      final createdShop = await _updateShopInfo.create(shop);
      state = state.copyWith(
        isUpdating: false,
        shop: createdShop,
        error: null,
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

  Future<bool> updateShop(ShopEntity shop) async {
    state = state.copyWith(isUpdating: true, error: null);
    
    try {
      final updatedShop = await _updateShopInfo.call(shop);
      state = state.copyWith(
        isUpdating: false,
        shop: updatedShop,
        error: null,
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

  Future<bool> toggleShopStatus(String shopId, bool isActive) async {
    state = state.copyWith(isUpdating: true, error: null);
    
    try {
      final success = await _updateShopInfo.toggleStatus(shopId, isActive);
      if (success) {
        // Reload shop data to get updated status
        await loadShopById(shopId);
      }
      state = state.copyWith(isUpdating: false);
      return success;
    } catch (e) {
      state = state.copyWith(
        isUpdating: false,
        error: e.toString(),
      );
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Provider
final shopProvider = StateNotifierProvider<ShopNotifier, ShopState>(
  (ref) {
    final getShopInfo = ref.read(getShopInfoProvider);
    final updateShopInfo = ref.read(updateShopInfoProvider);
    return ShopNotifier(getShopInfo, updateShopInfo);
  },
);