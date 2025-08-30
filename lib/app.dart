import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories_impl/auth_repository_impl.dart';
import 'features/auth/domain/usecases/login_user.dart';
import 'features/auth/domain/usecases/logout_user.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'routes.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      overrides: [
        authProvider.overrideWith((ref) {
          final repo = AuthRepositoryImpl(AuthRemoteDataSource());
          return AuthNotifier(
            loginUser: LoginUser(repo),
            logoutUser: LogoutUser(repo),
          );
        })
      ],
      child: MaterialApp(
        title: 'FDD Demo',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        initialRoute: Routes.login,
        routes: Routes.getRoutes(),
      ),
    );
  }
}
