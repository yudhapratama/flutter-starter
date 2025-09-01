import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_client.dart';

/// Provider untuk API Client
/// 
/// Menyediakan instance ApiClient yang dapat digunakan
/// di seluruh aplikasi melalui dependency injection
final apiClientProvider = Provider<ApiClient>((ref) {
  // TODO: Ganti dengan base URL yang sesuai
  const baseUrl = 'https://api.pasaralhuda.com';
  
  return ApiClient(baseUrl: baseUrl);
});