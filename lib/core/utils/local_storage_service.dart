import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/logger.dart';
import 'dummy_products_extension.dart';

/// Local storage service untuk menyimpan data dummy sebagai mock API
/// Digunakan untuk fase development dengan dummy data
class LocalStorageService {
  static const String _keyUsers = 'users';
  static const String _keyProducts = 'products';
  static const String _keyOrders = 'orders';
  static const String _keyShops = 'shops';
  static const String _keyCurrentUser = 'current_user';
  static const String _keyIsFirstLaunch = 'is_first_launch';

  static SharedPreferences? _prefs;

  /// Initialize shared preferences
  static Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      Logger.info('LocalStorageService initialized successfully');
      
      // Populate dummy data jika pertama kali launch
      if (await isFirstLaunch()) {
        await _populateDummyData();
        await setFirstLaunchComplete();
      }
    } catch (e, stackTrace) {
      Logger.error('Failed to initialize LocalStorageService', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Check if this is first launch
  static Future<bool> isFirstLaunch() async {
    return !(_prefs?.getBool(_keyIsFirstLaunch) ?? false);
  }

  /// Mark first launch as complete
  static Future<void> setFirstLaunchComplete() async {
    await _prefs?.setBool(_keyIsFirstLaunch, true);
  }

  // ==================
  // USER OPERATIONS
  // ==================

  /// Save user data
  static Future<void> saveUser(Map<String, dynamic> user) async {
    try {
      final users = await getUsers();
      final existingIndex = users.indexWhere((u) => u['id'] == user['id']);
      
      if (existingIndex != -1) {
        users[existingIndex] = user;
      } else {
        users.add(user);
      }
      
      await _prefs?.setString(_keyUsers, jsonEncode(users));
      Logger.info('User saved: ${user['email']}');
    } catch (e, stackTrace) {
      Logger.error('Failed to save user', error: e, stackTrace: stackTrace);
    }
  }

  /// Get all users
  static Future<List<Map<String, dynamic>>> getUsers() async {
    try {
      final usersJson = _prefs?.getString(_keyUsers);
      if (usersJson == null) return [];
      
      final usersList = jsonDecode(usersJson) as List;
      return usersList.cast<Map<String, dynamic>>();
    } catch (e, stackTrace) {
      Logger.error('Failed to get users', error: e, stackTrace: stackTrace);
      return [];
    }
  }

  /// Get user by email and password
  static Future<Map<String, dynamic>?> getUserByCredentials(String email, String password) async {
    try {
      final users = await getUsers();
      return users.firstWhere(
        (user) => user['email'] == email && user['password'] == password,
        orElse: () => {},
      ).isEmpty ? null : users.firstWhere(
        (user) => user['email'] == email && user['password'] == password,
      );
    } catch (e, stackTrace) {
      Logger.error('Failed to get user by credentials', error: e, stackTrace: stackTrace);
      return null;
    }
  }

  /// Save current user session
  static Future<void> saveCurrentUser(Map<String, dynamic> user) async {
    try {
      await _prefs?.setString(_keyCurrentUser, jsonEncode(user));
      Logger.info('Current user session saved: ${user['email']}');
    } catch (e, stackTrace) {
      Logger.error('Failed to save current user', error: e, stackTrace: stackTrace);
    }
  }

  /// Get current user session
  static Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final userJson = _prefs?.getString(_keyCurrentUser);
      if (userJson == null) return null;
      
      return jsonDecode(userJson) as Map<String, dynamic>;
    } catch (e, stackTrace) {
      Logger.error('Failed to get current user', error: e, stackTrace: stackTrace);
      return null;
    }
  }

  /// Clear current user session (logout)
  static Future<void> clearCurrentUser() async {
    try {
      await _prefs?.remove(_keyCurrentUser);
      Logger.info('Current user session cleared');
    } catch (e, stackTrace) {
      Logger.error('Failed to clear current user', error: e, stackTrace: stackTrace);
    }
  }

  // ==================
  // PRODUCT OPERATIONS
  // ==================

  /// Save product
  static Future<void> saveProduct(Map<String, dynamic> product) async {
    try {
      final products = await getProducts();
      final existingIndex = products.indexWhere((p) => p['id'] == product['id']);
      
      if (existingIndex != -1) {
        products[existingIndex] = product;
      } else {
        products.add(product);
      }
      
      await _prefs?.setString(_keyProducts, jsonEncode(products));
      Logger.info('Product saved: ${product['name']}');
    } catch (e, stackTrace) {
      Logger.error('Failed to save product', error: e, stackTrace: stackTrace);
    }
  }

  /// Get all products
  static Future<List<Map<String, dynamic>>> getProducts() async {
    try {
      final productsJson = _prefs?.getString(_keyProducts);
      if (productsJson == null) return [];
      
      final productsList = jsonDecode(productsJson) as List;
      return productsList.cast<Map<String, dynamic>>();
    } catch (e, stackTrace) {
      Logger.error('Failed to get products', error: e, stackTrace: stackTrace);
      return [];
    }
  }

  /// Get products by seller ID
  static Future<List<Map<String, dynamic>>> getProductsBySellerId(String sellerId) async {
    try {
      final products = await getProducts();
      return products.where((product) => product['sellerId'] == sellerId).toList();
    } catch (e, stackTrace) {
      Logger.error('Failed to get products by seller ID', error: e, stackTrace: stackTrace);
      return [];
    }
  }

  /// Delete product
  static Future<void> deleteProduct(String productId) async {
    try {
      final products = await getProducts();
      products.removeWhere((product) => product['id'] == productId);
      await _prefs?.setString(_keyProducts, jsonEncode(products));
      Logger.info('Product deleted: $productId');
    } catch (e, stackTrace) {
      Logger.error('Failed to delete product', error: e, stackTrace: stackTrace);
    }
  }

  // ==================
  // ORDER OPERATIONS
  // ==================

  /// Save order
  static Future<void> saveOrder(Map<String, dynamic> order) async {
    try {
      final orders = await getOrders();
      final existingIndex = orders.indexWhere((o) => o['id'] == order['id']);
      
      if (existingIndex != -1) {
        orders[existingIndex] = order;
      } else {
        orders.add(order);
      }
      
      await _prefs?.setString(_keyOrders, jsonEncode(orders));
      Logger.info('Order saved: ${order['id']}');
    } catch (e, stackTrace) {
      Logger.error('Failed to save order', error: e, stackTrace: stackTrace);
    }
  }

  /// Get all orders
  static Future<List<Map<String, dynamic>>> getOrders() async {
    try {
      final ordersJson = _prefs?.getString(_keyOrders);
      if (ordersJson == null) return [];
      
      final ordersList = jsonDecode(ordersJson) as List;
      return ordersList.cast<Map<String, dynamic>>();
    } catch (e, stackTrace) {
      Logger.error('Failed to get orders', error: e, stackTrace: stackTrace);
      return [];
    }
  }

  /// Get orders by seller ID
  static Future<List<Map<String, dynamic>>> getOrdersBySellerId(String sellerId) async {
    try {
      final orders = await getOrders();
      return orders.where((order) => order['sellerId'] == sellerId).toList();
    } catch (e, stackTrace) {
      Logger.error('Failed to get orders by seller ID', error: e, stackTrace: stackTrace);
      return [];
    }
  }

  // ==================
  // SHOP OPERATIONS
  // ==================

  /// Save shop data
  static Future<void> saveShop(Map<String, dynamic> shop) async {
    try {
      final shops = await getShops();
      final existingIndex = shops.indexWhere((s) => s['id'] == shop['id']);
      
      if (existingIndex != -1) {
        shops[existingIndex] = shop;
      } else {
        shops.add(shop);
      }
      
      await _prefs?.setString(_keyShops, jsonEncode(shops));
      Logger.info('Shop saved: ${shop['name']}');
    } catch (e, stackTrace) {
      Logger.error('Failed to save shop', error: e, stackTrace: stackTrace);
    }
  }

  /// Get all shops
  static Future<List<Map<String, dynamic>>> getShops() async {
    try {
      final shopsJson = _prefs?.getString(_keyShops);
      if (shopsJson == null) return [];
      
      final shopsList = jsonDecode(shopsJson) as List;
      return shopsList.cast<Map<String, dynamic>>();
    } catch (e, stackTrace) {
      Logger.error('Failed to get shops', error: e, stackTrace: stackTrace);
      return [];
    }
  }

  /// Get shop by seller ID
  static Future<Map<String, dynamic>?> getShopBySellerId(String sellerId) async {
    try {
      final shops = await getShops();
      final shop = shops.where((shop) => shop['sellerId'] == sellerId).toList();
      return shop.isEmpty ? null : shop.first;
    } catch (e, stackTrace) {
      Logger.error('Failed to get shop by seller ID', error: e, stackTrace: stackTrace);
      return null;
    }
  }

  // ==================
  // DUMMY DATA POPULATION
  // ==================

  /// Populate initial dummy data
  static Future<void> _populateDummyData() async {
    Logger.info('Populating dummy data...');
    
    // Dummy users (sellers)
    final dummyUsers = [
      {
        'id': 'seller_001',
        'name': 'Ahmad Fauzi',
        'email': 'ahmad@pasaralhuda.com',
        'password': '123456',
        'phone': '081234567890',
        'role': 'seller',
        'createdAt': DateTime.now().toIso8601String(),
      },
      {
        'id': 'seller_002',
        'name': 'Siti Nurhaliza',
        'email': 'siti@pasaralhuda.com',
        'password': '123456',
        'phone': '082345678901',
        'role': 'seller',
        'createdAt': DateTime.now().toIso8601String(),
      },
    ];

    // Dummy shops
    final dummyShops = [
      {
        'id': 'shop_001',
        'sellerId': 'seller_001',
        'name': 'Toko Berkah Jaya',
        'description': 'Menyediakan berbagai kebutuhan sehari-hari dengan kualitas terbaik',
        'address': 'Jl. Pasar Al Huda No. 12, Jakarta Timur',
        'phone': '081234567890',
        'rating': 4.5,
        'totalReviews': 125,
        'isActive': true,
        'createdAt': DateTime.now().toIso8601String(),
      },
      {
        'id': 'shop_002',
        'sellerId': 'seller_002',
        'name': 'Warung Sari Rasa',
        'description': 'Makanan dan minuman tradisional dengan cita rasa autentik',
        'address': 'Jl. Pasar Al Huda No. 25, Jakarta Timur',
        'phone': '082345678901',
        'rating': 4.8,
        'totalReviews': 89,
        'isActive': true,
        'createdAt': DateTime.now().toIso8601String(),
      },
    ];

    // Dummy products
    final dummyProducts = [
      {
        'id': 'product_001',
        'sellerId': 'seller_001',
        'name': 'Beras Premium Organik',
        'description': 'Beras organik berkualitas tinggi, bebas pestisida dan pupuk kimia. Cocok untuk keluarga yang peduli kesehatan.',
        'price': 85000.0,
        'stock': 50,
        'category': 'Makanan Pokok',
        'images': ['https://images.unsplash.com/photo-1586201375761-83865001e31c?w=300&h=300&fit=crop&crop=center'],
        'mainImageIndex': 0,
        'sku': 'BRS-ORG-001',
        'hasDiscount': true,
        'discountPrice': 75000.0,
        'discountStartDate': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
        'discountEndDate': DateTime.now().add(const Duration(days: 7)).toIso8601String(),
        'minOrder': 1,
        'maxOrder': 10,
        'weightInGrams': 5000,
        'length': 30.0,
        'width': 20.0,
        'height': 8.0,
        'status': 'active',
        'hasHalalCertification': true,
        'tags': ['organik', 'premium', 'sehat', 'halal'],
        'createdAt': DateTime.now().subtract(const Duration(days: 5)).toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
      {
        'id': 'product_002',
        'sellerId': 'seller_001',
        'name': 'Minyak Goreng Kelapa Murni',
        'description': 'Minyak goreng dari kelapa murni, tidak menggunakan bahan kimia berbahaya. Sehat untuk memasak sehari-hari.',
        'price': 45000.0,
        'stock': 25,
        'category': 'Minyak & Bumbu',
        'images': ['https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=300&h=300&fit=crop&crop=center'],
        'mainImageIndex': 0,
        'sku': 'MYK-KLP-002',
        'hasDiscount': false,
        'discountPrice': null,
        'discountStartDate': null,
        'discountEndDate': null,
        'minOrder': 1,
        'maxOrder': 5,
        'weightInGrams': 1000,
        'length': 15.0,
        'width': 8.0,
        'height': 20.0,
        'status': 'active',
        'hasHalalCertification': true,
        'tags': ['murni', 'sehat', 'halal', 'kelapa'],
        'createdAt': DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
      {
        'id': 'product_003',
        'sellerId': 'seller_002',
        'name': 'Rendang Daging Sapi',
        'description': 'Rendang daging sapi autentik Padang dengan bumbu rempah pilihan. Siap saji, tinggal hangatkan.',
        'price': 125000.0,
        'stock': 15,
        'category': 'Makanan Siap Saji',
        'images': ['https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=300&h=300&fit=crop&crop=center'],
        'mainImageIndex': 0,
        'sku': 'RND-SPI-003',
        'hasDiscount': true,
        'discountPrice': 110000.0,
        'discountStartDate': DateTime.now().toIso8601String(),
        'discountEndDate': DateTime.now().add(const Duration(days: 3)).toIso8601String(),
        'minOrder': 1,
        'maxOrder': 3,
        'weightInGrams': 500,
        'length': 12.0,
        'width': 12.0,
        'height': 5.0,
        'status': 'active',
        'hasHalalCertification': true,
        'tags': ['rendang', 'padang', 'siap saji', 'halal', 'daging sapi'],
        'createdAt': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
      {
        'id': 'product_004',
        'sellerId': 'seller_002',
        'name': 'Kerupuk Udang Tradisional',
        'description': 'Kerupuk udang buatan rumah dengan resep turun temurun. Renyah dan gurih, cocok sebagai pelengkap makan.',
        'price': 25000.0,
        'stock': 0,
        'category': 'Camilan',
        'images': ['https://images.unsplash.com/photo-1599490659213-e2b9527bd087?w=300&h=300&fit=crop&crop=center'],
        'mainImageIndex': 0,
        'sku': 'KRP-UDG-004',
        'hasDiscount': false,
        'discountPrice': null,
        'discountStartDate': null,
        'discountEndDate': null,
        'minOrder': 1,
        'maxOrder': 10,
        'weightInGrams': 200,
        'length': 20.0,
        'width': 15.0,
        'height': 3.0,
        'status': 'inactive',
        'hasHalalCertification': true,
        'tags': ['kerupuk', 'udang', 'tradisional', 'renyah'],
        'createdAt': DateTime.now().subtract(const Duration(days: 7)).toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
      {
        'id': 'product_005',
        'sellerId': 'seller_001',
        'name': 'Teh Herbal Daun Mint',
        'description': 'Teh herbal dari daun mint segar, membantu pencernaan dan memberikan efek menyegarkan.',
        'price': 35000.0,
        'stock': 30,
        'category': 'Minuman',
        'images': ['https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=300&h=300&fit=crop&crop=center'],
        'mainImageIndex': 0,
        'sku': null,
        'hasDiscount': false,
        'discountPrice': null,
        'discountStartDate': null,
        'discountEndDate': null,
        'minOrder': 2,
        'maxOrder': 20,
        'weightInGrams': 100,
        'length': 10.0,
        'width': 6.0,
        'height': 15.0,
        'status': 'draft',
        'hasHalalCertification': false,
        'tags': ['herbal', 'mint', 'sehat', 'menyegarkan'],
        'createdAt': DateTime.now().subtract(const Duration(hours: 12)).toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
      {
        'id': 'product_006',
        'sellerId': 'seller_001',
        'name': 'Gula Aren Organik',
        'description': 'Gula aren murni tanpa campuran bahan kimia. Lebih sehat dari gula putih biasa.',
        'price': 55000.0,
        'stock': 40,
        'category': 'Pemanis Alami',
        'images': ['https://images.unsplash.com/photo-1571115764595-644a1f56a55c?w=300&h=300&fit=crop&crop=center'],
        'mainImageIndex': 0,
        'sku': 'GLA-ORG-006',
        'hasDiscount': true,
        'discountPrice': 48000.0,
        'discountStartDate': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
        'discountEndDate': DateTime.now().add(const Duration(days: 5)).toIso8601String(),
        'minOrder': 1,
        'maxOrder': 8,
        'weightInGrams': 1000,
        'length': 12.0,
        'width': 8.0,
        'height': 15.0,
        'status': 'active',
        'hasHalalCertification': true,
        'tags': ['organik', 'aren', 'sehat', 'alami'],
        'createdAt': DateTime.now().subtract(const Duration(days: 4)).toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
      {
        'id': 'product_007',
        'sellerId': 'seller_002',
        'name': 'Sambal Terasi Homemade',
        'description': 'Sambal terasi buatan rumah dengan cita rasa pedas yang pas. Cocok untuk lalapan.',
        'price': 18000.0,
        'stock': 22,
        'category': 'Sambal & Saus',
        'images': ['https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=300&h=300&fit=crop&crop=center'],
        'mainImageIndex': 0,
        'sku': 'SMB-TRS-007',
        'hasDiscount': false,
        'discountPrice': null,
        'discountStartDate': null,
        'discountEndDate': null,
        'minOrder': 2,
        'maxOrder': 15,
        'weightInGrams': 250,
        'length': 8.0,
        'width': 8.0,
        'height': 10.0,
        'status': 'active',
        'hasHalalCertification': true,
        'tags': ['sambal', 'terasi', 'pedas', 'homemade'],
        'createdAt': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
      {
        'id': 'product_008',
        'sellerId': 'seller_001',
        'name': 'Kopi Arabika Gayo',
        'description': 'Kopi arabika premium dari dataran tinggi Gayo, Aceh. Aroma dan rasa yang khas.',
        'price': 95000.0,
        'stock': 18,
        'category': 'Minuman',
        'images': ['https://images.unsplash.com/photo-1447933601403-0c6688de566e?w=300&h=300&fit=crop&crop=center'],
        'mainImageIndex': 0,
        'sku': 'KPI-ARB-008',
        'hasDiscount': true,
        'discountPrice': 85000.0,
        'discountStartDate': DateTime.now().toIso8601String(),
        'discountEndDate': DateTime.now().add(const Duration(days: 10)).toIso8601String(),
        'minOrder': 1,
        'maxOrder': 5,
        'weightInGrams': 500,
        'length': 15.0,
        'width': 10.0,
        'height': 5.0,
        'status': 'active',
        'hasHalalCertification': true,
        'tags': ['kopi', 'arabika', 'gayo', 'premium'],
        'createdAt': DateTime.now().subtract(const Duration(days: 6)).toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
      {
        'id': 'product_009',
        'sellerId': 'seller_002',
        'name': 'Tempe Kedelai Segar',
        'description': 'Tempe kedelai segar dibuat setiap hari. Sumber protein nabati yang baik.',
        'price': 8000.0,
        'stock': 35,
        'category': 'Protein Nabati',
        'images': ['https://images.unsplash.com/photo-1609501676725-7186f734b2b0?w=300&h=300&fit=crop&crop=center'],
        'mainImageIndex': 0,
        'sku': 'TMP-KDL-009',
        'hasDiscount': false,
        'discountPrice': null,
        'discountStartDate': null,
        'discountEndDate': null,
        'minOrder': 3,
        'maxOrder': 20,
        'weightInGrams': 300,
        'length': 15.0,
        'width': 8.0,
        'height': 2.0,
        'status': 'active',
        'hasHalalCertification': true,
        'tags': ['tempe', 'kedelai', 'segar', 'protein'],
        'createdAt': DateTime.now().subtract(const Duration(hours: 8)).toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
      {
        'id': 'product_010',
        'sellerId': 'seller_001',
        'name': 'Madu Hutan Asli',
        'description': 'Madu hutan asli dari lebah liar. Kaya akan nutrisi dan antioksidan alami.',
        'price': 120000.0,
        'stock': 12,
        'category': 'Pemanis Alami',
        'images': ['https://images.unsplash.com/photo-1587049352846-4a222e784d38?w=300&h=300&fit=crop&crop=center'],
        'mainImageIndex': 0,
        'sku': 'MDU-HTN-010',
        'hasDiscount': false,
        'discountPrice': null,
        'discountStartDate': null,
        'discountEndDate': null,
        'minOrder': 1,
        'maxOrder': 3,
        'weightInGrams': 500,
        'length': 10.0,
        'width': 10.0,
        'height': 12.0,
        'status': 'active',
        'hasHalalCertification': true,
        'tags': ['madu', 'hutan', 'asli', 'antioksidan'],
        'createdAt': DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
    ];

    // Save dummy data
    for (final user in dummyUsers) {
      await saveUser(user);
    }
    
    for (final shop in dummyShops) {
      await saveShop(shop);
    }
    
    // Save main dummy products (product_001 to product_010)
    for (final product in dummyProducts) {
      await saveProduct(product);
    }
    
    // Save additional dummy products (product_011 to product_050)
    for (final product in additionalDummyProducts) {
      await saveProduct(product);
    }

    Logger.info('Dummy data population completed');
  }

  // ==================
  // UTILITY METHODS
  // ==================

  /// Clear all data (for testing purposes)
  static Future<void> clearAllData() async {
    try {
      await _prefs?.clear();
      Logger.info('All local storage data cleared');
    } catch (e, stackTrace) {
      Logger.error('Failed to clear all data', error: e, stackTrace: stackTrace);
    }
  }

  /// Get storage info
  static Future<Map<String, int>> getStorageInfo() async {
    try {
      final users = await getUsers();
      final products = await getProducts();
      final orders = await getOrders();
      final shops = await getShops();
      
      return {
        'users': users.length,
        'products': products.length,
        'orders': orders.length,
        'shops': shops.length,
      };
    } catch (e, stackTrace) {
      Logger.error('Failed to get storage info', error: e, stackTrace: stackTrace);
      return {};
    }
  }
}