import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/widgets/app_button.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              SizedBox(
                width: 100,
                height: 100,
                child: Icon(
                  Iconsax.home_copy,
                  size: 64,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              const SizedBox(height: 24),
              if (auth.user == null) ...[
                Text("Welcome Guest!", style: textTheme.bodyLarge),
                const SizedBox(height: 16),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: AppButton(
                      label: "Login",
                      onPressed: () {
                        Navigator.pushNamed(context, "/login");
                      },
                    ),
                  ),
                ),
              ] else ...[
                Text("Welcome, ${auth.user!.name}", style: textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text("Dashboard Seller Pasar Al Huda", style: textTheme.titleMedium),
                const SizedBox(height: 32),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.65,
                    child: AppButton(
                      label: "Kelola Produk",
                      icon: const Icon(Iconsax.box),
                      onPressed: () {
                        Navigator.pushNamed(context, "/products");
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.65,
                    child: AppButton(
                      label: "Profile",
                      icon: const Icon(Iconsax.user),
                      onPressed: () {
                        Navigator.pushNamed(context, "/profile");
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.65,
                    child: AppButton(
                      label: "Logout",
                      icon: const Icon(Iconsax.logout),
                      onPressed: () {
                        authNotifier.logout();
                      },
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
