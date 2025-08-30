import '../../../../core/utils/local_storage_service.dart';
import '../../../../core/utils/logger.dart';

class AuthRemoteDataSource {
  /// Login with email and password
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      Logger.info('Attempting login for email: $email');
      
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Get user from local storage
      final user = await LocalStorageService.getUserByCredentials(email, password);
      
      if (user == null) {
        throw Exception('Invalid credentials');
      }
      
      // Save current user session
      await LocalStorageService.saveCurrentUser(user);
      
      Logger.info('Login successful for user: ${user['email']}');
      
      return {
        'success': true,
        'token': 'dummy.jwt.token.${user['id']}',
        'user': user,
        'message': 'Login berhasil'
      };
    } catch (e, stackTrace) {
      Logger.error('Login failed', error: e, stackTrace: stackTrace);
      return {
        'success': false,
        'message': e.toString().contains('Invalid credentials') 
          ? 'Email atau password salah'
          : 'Terjadi kesalahan saat login'
      };
    }
  }

  /// Register new user
  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    try {
      Logger.info('Attempting registration for email: ${userData['email']}');
      
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Check if user already exists
      final existingUser = await LocalStorageService.getUserByCredentials(
        userData['email'], 
        userData['password']
      );
      
      if (existingUser != null) {
        throw Exception('User already exists');
      }
      
      // Generate user ID
      final users = await LocalStorageService.getUsers();
      final newUserId = (users.length + 1).toString();
      
      // Create new user data
      final newUser = {
        'id': newUserId,
        'name': userData['name'],
        'email': userData['email'],
        'password': userData['password'],
        'phone': userData['phone'] ?? '',
        'address': userData['address'] ?? '',
        'createdAt': DateTime.now().toIso8601String(),
        'isActive': true,
      };
      
      // Save user to local storage
      await LocalStorageService.saveUser(newUser);
      
      Logger.info('Registration successful for user: ${newUser['email']}');
      
      return {
        'success': true,
        'user': newUser,
        'message': 'Registrasi berhasil'
      };
    } catch (e, stackTrace) {
      Logger.error('Registration failed', error: e, stackTrace: stackTrace);
      return {
        'success': false,
        'message': e.toString().contains('User already exists')
          ? 'Email sudah terdaftar'
          : 'Terjadi kesalahan saat registrasi'
      };
    }
  }

  /// Logout current user
  Future<Map<String, dynamic>> logout() async {
    try {
      Logger.info('Attempting logout');
      
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Clear current user session
      await LocalStorageService.clearCurrentUser();
      
      Logger.info('Logout successful');
      
      return {
        'success': true,
        'message': 'Logout berhasil'
      };
    } catch (e, stackTrace) {
      Logger.error('Logout failed', error: e, stackTrace: stackTrace);
      return {
        'success': false,
        'message': 'Terjadi kesalahan saat logout'
      };
    }
  }

  /// Get current user session
  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final user = await LocalStorageService.getCurrentUser();
      Logger.info('Current user retrieved: ${user?['email'] ?? 'None'}');
      return user;
    } catch (e, stackTrace) {
      Logger.error('Failed to get current user', error: e, stackTrace: stackTrace);
      return null;
    }
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    try {
      final user = await getCurrentUser();
      return user != null;
    } catch (e, stackTrace) {
      Logger.error('Failed to check login status', error: e, stackTrace: stackTrace);
      return false;
    }
  }
}
