import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
import '../../domain/entities/address_entity.dart';
import '../../domain/entities/shop_entity.dart';

/// Widget card untuk menampilkan informasi toko
/// 
/// Menampilkan nama toko, status, rating, dan statistik dasar
class ShopInfoCard extends StatelessWidget {
  final ShopEntity? shop;
  final VoidCallback? onEdit;
  final VoidCallback? onCreate;
  final bool isLoading;

  const ShopInfoCard({
    super.key,
    this.shop,
    this.onEdit,
    this.onCreate,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    if (shop == null) {
      return _buildCreateShopCard(context, textTheme, colorScheme);
    }

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusM),
                    image: shop!.logo != null
                        ? DecorationImage(
                            image: NetworkImage(shop!.logo!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: shop!.logo == null
                      ? Icon(
                          Iconsax.shop,
                          size: 30,
                          color: colorScheme.primary,
                        )
                      : null,
                ),
                const SizedBox(width: AppTheme.spacingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shop!.name,
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingXS),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spacingS,
                              vertical: AppTheme.spacingXS,
                            ),
                            decoration: BoxDecoration(
                              color: shop!.isActive
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(AppTheme.radiusS),
                            ),
                            child: Text(
                              shop!.isActive ? 'Active' : 'Inactive',
                              style: textTheme.bodySmall?.copyWith(
                                color: shop!.isActive ? Colors.green : Colors.orange,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (onEdit != null)
                  AppButton(
                    label: 'Edit',
                    onPressed: isLoading ? null : onEdit,
                    isOutlined: true,
                    width: 80,
                    loading: isLoading,
                  ),
              ],
            ),
            if (shop!.description?.isNotEmpty == true) ...[
              const SizedBox(height: AppTheme.spacingM),
              Text(
                shop!.description ?? '',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
            const SizedBox(height: AppTheme.spacingM),
            const Divider(),
            const SizedBox(height: AppTheme.spacingM),
            _buildInfoRow(
              context,
              icon: Iconsax.location,
              label: 'Address',
              value: () {
                AddressEntity? primaryAddress;
                try {
                  primaryAddress = shop!.addresses.firstWhere((addr) => addr.isPrimary);
                } catch (e) {
                  primaryAddress = shop!.addresses.isNotEmpty ? shop!.addresses.first : null;
                }
                if (primaryAddress == null) return 'No address available';
                return '${primaryAddress.address}, ${primaryAddress.city}, ${primaryAddress.province} ${primaryAddress.postalCode}';
              }(),
            ),
            const SizedBox(height: AppTheme.spacingS),
            _buildInfoRow(
              context,
              icon: Iconsax.call,
              label: 'Phone',
              value: shop!.phone,
            ),
            const SizedBox(height: AppTheme.spacingS),
            _buildInfoRow(
              context,
              icon: Iconsax.calendar,
              label: 'Created',
              value: _formatDate(shop!.createdAt),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateShopCard(
    BuildContext context,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          children: [
            Icon(
              Iconsax.shop_add,
              size: 64,
              color: colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: AppTheme.spacingM),
            Text(
              'Create Your Shop',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spacingS),
            Text(
              'Set up your shop to start selling products',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacingL),
            AppButton(
              label: 'Create Shop',
              onPressed: isLoading ? null : onCreate,
              loading: isLoading,
              expanded: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: colorScheme.onSurface.withOpacity(0.6),
        ),
        const SizedBox(width: AppTheme.spacingS),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              Text(
                value,
                style: textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}