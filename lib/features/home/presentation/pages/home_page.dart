import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../profile/presentation/providers/shop_profile_provider.dart';
import '../../../profile/presentation/widgets/statistics_card.dart';
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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
              if (auth.user == null) ...[
                Text("Welcome Guest!", style: textTheme.bodyLarge),
                const SizedBox(height: 16),
                AppButton(
                  label: "Login",
                  onPressed: () {
                    Navigator.pushNamed(context, "/login");
                  },
                ),
              ] else ...[
                // Statistics Card
                Consumer(
                  builder: (context, ref, child) {
                    final shopState = ref.watch(shopProfileNotifierProvider);
                    
                    if (shopState.isLoading) {
                      return const StatisticsCard(isLoading: true);
                    } else if (shopState.error != null) {
                      return const SizedBox.shrink();
                    } else if (shopState.shop != null) {
                      final shop = shopState.shop!;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: StatisticsCard(
                          totalProducts: shop.totalProducts,
                          totalOrders: shop.totalOrders,
                          totalReviews: shop.totalReviews,
                          rating: shop.rating,
                          revenue: shop.revenue,
                          activeProducts: shop.totalProducts,
                          pendingOrders: 0, // TODO: Add pending orders calculation
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
                const SizedBox(height: 24),
                Text("Welcome, ${auth.user!.name}", style: textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text("Dashboard Seller Pasar Al Huda", style: textTheme.titleMedium),
                const SizedBox(height: 32),
                AppButton(
                  label: "Kelola Produk",
                  icon: const Icon(Iconsax.box),
                  onPressed: () {
                    Navigator.pushNamed(context, "/products");
                  },
                ),
                const SizedBox(height: 12),
                AppButton(
                  label: "Profile",
                  icon: const Icon(Iconsax.user),
                  onPressed: () {
                    Navigator.pushNamed(context, "/profile");
                  },
                ),
                const SizedBox(height: 12),
                AppButton(
                  label: "Logout",
                  icon: const Icon(Iconsax.logout),
                  onPressed: () {
                    authNotifier.logout();
                  },
                ),
              ],
              const SizedBox(height: 40),
            ],
            ),
          ),
        ),
      ),
    );
  }
}
