import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
import '../../domain/entities/seller_entity.dart';

class ProfileCard extends StatelessWidget {
  final SellerEntity seller;
  final VoidCallback? onEdit;
  final bool isLoading;

  const ProfileCard({
    super.key,
    required this.seller,
    this.onEdit,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: colorScheme.primary.withOpacity(0.1),
                  backgroundImage: seller.avatar != null
                      ? NetworkImage(seller.avatar!)
                      : null,
                  child: seller.avatar == null
                      ? Icon(
                          Iconsax.user,
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
                        seller.name,
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingXS),
                      Text(
                        seller.email,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
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
            const SizedBox(height: AppTheme.spacingM),
            const Divider(),
            const SizedBox(height: AppTheme.spacingM),
            _buildInfoRow(
              context,
              icon: Iconsax.call,
              label: 'Phone',
              value: seller.phone,
            ),
            const SizedBox(height: AppTheme.spacingS),
            _buildInfoRow(
              context,
              icon: Iconsax.location,
              label: 'Address',
              value: '${seller.address}, ${seller.city}, ${seller.province}',
            ),
            const SizedBox(height: AppTheme.spacingS),
            _buildInfoRow(
              context,
              icon: Iconsax.calendar,
              label: 'Joined',
              value: _formatDate(seller.createdAt),
            ),
            if (seller.isVerified) ...[
              const SizedBox(height: AppTheme.spacingS),
              Row(
                children: [
                  Icon(
                    Iconsax.verify,
                    size: 16,
                    color: Colors.green,
                  ),
                  const SizedBox(width: AppTheme.spacingXS),
                  Text(
                    'Verified Seller',
                    style: textTheme.bodySmall?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ]
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