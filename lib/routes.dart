import 'package:flutter/material.dart';
import 'core/widgets/main_layout.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/profile/presentation/pages/profile_page.dart';
import 'features/product/presentation/pages/product_list_page.dart';

class Routes {
  static const home = '/';
  static const login = '/login';
  static const register = '/register';
  static const profile = '/profile';
  static const products = '/products';
  static const main = '/main';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => const MainLayout(initialIndex: 0),
      main: (context) => const MainLayout(initialIndex: 0),
      login: (context) => const LoginPage(),
      register: (context) => const RegisterPage(),
      profile: (context) => const ProfilePage(),
      products: (context) => const ProductListPage(),
    };
  }
}
