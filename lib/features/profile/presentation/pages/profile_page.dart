import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/seller_profile_provider.dart';
import '../providers/shop_profile_provider.dart';
import '../widgets/profile_card.dart';
import '../widgets/shop_info_card.dart';

import '../widgets/quick_actions_card.dart';
import '../widgets/profile_menu_item.dart';
import '../widgets/edit_profile_form.dart';
import '../widgets/edit_shop_form.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(sellerProfileNotifierProvider.notifier).loadProfile();
      
      final auth = ref.read(authProvider);
      if (auth.user != null) {
        ref.read(shopProfileNotifierProvider.notifier).getShopBySellerId(auth.user!.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final auth = ref.watch(authProvider);
    final user = auth.user;
    
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Not logged in')),
      );
    }
    
    final sellerProfileState = ref.watch(sellerProfileNotifierProvider);
    final shopProfileState = ref.watch(shopProfileNotifierProvider);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              _showSettingsBottomSheet(context);
            },
            icon: const Icon(Iconsax.setting_2),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(sellerProfileNotifierProvider.notifier).loadProfile();
          final auth = ref.read(authProvider);
          if (auth.user != null) {
            await ref.read(shopProfileNotifierProvider.notifier).getShopBySellerId(auth.user!.id);
          }
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppTheme.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Card
              if (sellerProfileState.seller != null)
                ProfileCard(
                  seller: sellerProfileState.seller!,
                  onEdit: () => _showEditProfileForm(context),
                  isLoading: sellerProfileState.isLoading,
                )
              else if (sellerProfileState.isLoading)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(AppTheme.spacingL),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                )
              else
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.spacingL),
                    child: Column(
                      children: [
                        const Icon(Iconsax.user, size: 48),
                        const SizedBox(height: AppTheme.spacingM),
                        Text(
                          'Gagal memuat profil',
                          style: textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppTheme.spacingS),
                        AppButton(
                          label: 'Coba Lagi',
                          onPressed: () => ref.read(sellerProfileNotifierProvider.notifier).loadProfile(),
                          isOutlined: true,
                        ),
                      ],
                    ),
                  ),
                ),
              
              const SizedBox(height: AppTheme.spacingL),
              
              // Shop Info Card
              ShopInfoCard(
                shop: shopProfileState.shop,
                onEdit: shopProfileState.shop != null ? () => _showEditShopForm(context) : null,
                onCreate: shopProfileState.shop == null ? () => _showCreateShopForm(context) : null,
                isLoading: shopProfileState.isLoading,
              ),
              
              const SizedBox(height: AppTheme.spacingL),
              

              
              // Quick Actions Card
              QuickActionsCard(
                onEditProfile: () => _showEditProfileForm(context),
                onEditShop: shopProfileState.shop != null ? () => _showEditShopForm(context) : null,
                onChangePassword: () => _showChangePasswordDialog(context),
                onViewProducts: () {
                  // TODO: Navigate to products page
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fitur produk akan segera hadir')),
                  );
                },
                onViewOrders: () {
                  // TODO: Navigate to orders page
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fitur pesanan akan segera hadir')),
                  );
                },
                onViewAnalytics: () {
                  // TODO: Navigate to analytics page
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fitur analitik akan segera hadir')),
                  );
                },
                onSettings: () => _showSettingsBottomSheet(context),
                onSupport: () {
                  // TODO: Navigate to support page
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fitur bantuan akan segera hadir')),
                  );
                },
              ),
              
              const SizedBox(height: AppTheme.spacingL),
              
              // Profile Menu Section
              Text(
                'Profil',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              
              const SizedBox(height: AppTheme.spacingM),
              
              // Profile Menu Items
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ProfileMenuItem(
                      icon: Iconsax.user_edit,
                      title: 'Edit Profil',
                      subtitle: 'Ubah informasi profil Anda',
                      onTap: () => _showEditProfileForm(context),
                    ),
                    const Divider(height: 1),
                    ProfileMenuItem(
                      icon: Iconsax.shop,
                      title: shopProfileState.shop != null ? 'Edit Toko' : 'Buat Toko',
                      subtitle: shopProfileState.shop != null ? 'Ubah informasi toko' : 'Buat toko baru',
                      onTap: () {
                        if (shopProfileState.shop != null) {
                          _showEditShopForm(context);
                        } else {
                          _showCreateShopForm(context);
                        }
                      },
                    ),
                    const Divider(height: 1),
                    ProfileMenuItem(
                      icon: Iconsax.lock,
                      title: 'Ubah Kata Sandi',
                      subtitle: 'Perbarui kata sandi akun',
                      onTap: () => _showChangePasswordDialog(context),
                    ),
                    const Divider(height: 1),
                    ProfileMenuItem(
                      icon: Iconsax.notification,
                      title: 'Notifikasi',
                      subtitle: 'Atur preferensi notifikasi',
                      onTap: () {
                        // TODO: Navigate to notification settings
                      },
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: AppTheme.spacingL),
              
              // Settings Menu Section
              Text(
                'Pengaturan',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              
              const SizedBox(height: AppTheme.spacingM),
              
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ProfileMenuItem(
                      icon: Iconsax.security_safe,
                      title: 'Keamanan',
                      subtitle: 'Pengaturan keamanan akun',
                      onTap: () {
                        // TODO: Navigate to security settings
                      },
                    ),
                    const Divider(height: 1),
                    ProfileMenuItem(
                      icon: Iconsax.language_square,
                      title: 'Bahasa',
                      subtitle: 'Pilih bahasa aplikasi',
                      onTap: () {
                        // TODO: Navigate to language settings
                      },
                    ),
                    const Divider(height: 1),
                    ProfileMenuItem(
                      icon: Iconsax.info_circle,
                      title: 'Tentang',
                      subtitle: 'Informasi aplikasi',
                      onTap: () {
                        // TODO: Navigate to about page
                      },
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: AppTheme.spacingXL),
              

              
              const SizedBox(height: AppTheme.spacingL),
              
              // App Version
              Center(
                child: Text(
                  'Versi 1.0.0',
                  style: textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ),
              
              const SizedBox(height: AppTheme.spacingM),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditProfileForm(BuildContext context) {
    final sellerState = ref.read(sellerProfileNotifierProvider);
    if (sellerState.seller == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: EditProfileForm(
          seller: sellerState.seller!,
          onSave: (updatedSeller) async {
            await ref.read(sellerProfileNotifierProvider.notifier).updateProfile(
              name: updatedSeller.name,
              email: updatedSeller.email,
              phoneNumber: updatedSeller.phone,
              address: updatedSeller.address,
              city: updatedSeller.city,
              province: updatedSeller.province,
              postalCode: updatedSeller.postalCode,
            );
            if (context.mounted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profil berhasil diperbarui')),
              );
            }
          },
          onCancel: () => Navigator.pop(context),
        ),
      ),
    );
  }

  void _showEditShopForm(BuildContext context) {
    final shopState = ref.read(shopProfileNotifierProvider);
    if (shopState.shop == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: EditShopForm(
          shop: shopState.shop,
          onSave: (updatedShop) async {
            await ref.read(shopProfileNotifierProvider.notifier).updateShop(
              name: updatedShop.name,
              description: updatedShop.description,
              phone: updatedShop.phone,
              email: updatedShop.email ?? '',
              website: updatedShop.website ?? '',
              categories: updatedShop.categories,
            );
            if (context.mounted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Informasi toko berhasil diperbarui')),
              );
            }
          },
          onCancel: () => Navigator.pop(context),
        ),
      ),
    );
  }

  void _showCreateShopForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: EditShopForm(
          onSave: (newShop) async {
            // Get primary address data
            final primaryAddress = newShop.addresses.firstWhere(
              (addr) => addr.isPrimary,
              orElse: () => newShop.addresses.first,
            );
            
            await ref.read(shopProfileNotifierProvider.notifier).createShop(
              name: newShop.name,
              description: newShop.description,
              address: primaryAddress.address,
              city: primaryAddress.city,
              province: primaryAddress.province,
              postalCode: primaryAddress.postalCode,
              phone: newShop.phone,
              email: newShop.email ?? '',
              website: newShop.website ?? '',
              categories: newShop.categories,
            );
            if (context.mounted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Toko berhasil dibuat')),
              );
            }
          },
          onCancel: () => Navigator.pop(context),
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ubah Kata Sandi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Kata Sandi Saat Ini',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Kata Sandi Baru',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Konfirmasi Kata Sandi Baru',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement password change
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fitur ubah kata sandi akan segera hadir')),
              );
            },
            child: const Text('Ubah'),
          ),
        ],
      ),
    );
  }

  void _showSettingsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Iconsax.notification),
              title: const Text('Notifikasi'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fitur notifikasi akan segera hadir')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.security_safe),
              title: const Text('Keamanan'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fitur keamanan akan segera hadir')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.language_square),
              title: const Text('Bahasa'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fitur bahasa akan segera hadir')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.logout),
              title: const Text('Keluar'),
              onTap: () {
                Navigator.pop(context);
                _showLogoutDialog(context, ref);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Keluar',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin keluar dari aplikasi?',
          style: textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Batal',
              style: textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
          AppButton(
            label: 'Keluar',
            onPressed: () {
              Navigator.of(context).pop();
              // Logout user
              ref.read(authProvider.notifier).logout();
            },
            isOutlined: true,
          ),
        ],
      ),
    );
  }
}
