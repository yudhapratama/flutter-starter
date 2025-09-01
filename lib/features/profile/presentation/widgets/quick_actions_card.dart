import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/theme/app_theme.dart';

/// Widget card untuk aksi cepat profil dan toko
/// 
/// Menyediakan tombol-tombol aksi cepat untuk mengelola
/// profil seller dan informasi toko
class QuickActionsCard extends StatelessWidget {
  final VoidCallback? onEditProfile;
  final VoidCallback? onEditShop;
  final VoidCallback? onChangePassword;
  final VoidCallback? onViewProducts;
  final VoidCallback? onViewOrders;
  final VoidCallback? onViewAnalytics;
  final VoidCallback? onSettings;
  final VoidCallback? onSupport;
  final bool hasShop;

  const QuickActionsCard({
    super.key,
    this.onEditProfile,
    this.onEditShop,
    this.onChangePassword,
    this.onViewProducts,
    this.onViewOrders,
    this.onViewAnalytics,
    this.onSettings,
    this.onSupport,
    this.hasShop = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Iconsax.flash_1,
                  size: 24,
                  color: colorScheme.primary,
                ),
                SizedBox(width: AppTheme.spacingS),
                Text(
                  'Aksi Cepat',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: AppTheme.spacingL),
            
            // Profile actions
            Text(
              'Profil',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
            
            SizedBox(height: AppTheme.spacingM),
            
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    context,
                    icon: Iconsax.edit,
                    label: 'Edit Profil',
                    onTap: onEditProfile,
                    color: Colors.blue,
                  ),
                ),
                
                SizedBox(width: AppTheme.spacingM),
                
                Expanded(
                  child: _buildActionButton(
                    context,
                    icon: Iconsax.lock,
                    label: 'Ubah Password',
                    onTap: onChangePassword,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            
            if (hasShop) ...[
              SizedBox(height: AppTheme.spacingL),
              
              // Shop actions
              Text(
                'Toko',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface.withValues(alpha: 0.8),
                ),
              ),
              
              SizedBox(height: AppTheme.spacingM),
              
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      context,
                      icon: Iconsax.shop,
                      label: 'Edit Toko',
                      onTap: onEditShop,
                      color: Colors.green,
                    ),
                  ),
                  
                  SizedBox(width: AppTheme.spacingM),
                  
                  Expanded(
                    child: _buildActionButton(
                      context,
                      icon: Iconsax.box,
                      label: 'Produk',
                      onTap: onViewProducts,
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: AppTheme.spacingM),
              
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      context,
                      icon: Iconsax.shopping_bag,
                      label: 'Pesanan',
                      onTap: onViewOrders,
                      color: Colors.teal,
                    ),
                  ),
                  
                  SizedBox(width: AppTheme.spacingM),
                  
                  Expanded(
                    child: _buildActionButton(
                      context,
                      icon: Iconsax.chart_2,
                      label: 'Analitik',
                      onTap: onViewAnalytics,
                      color: Colors.indigo,
                    ),
                  ),
                ],
              ),
            ],
            
            SizedBox(height: AppTheme.spacingL),
            
            // Other actions
            Text(
              'Lainnya',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
            
            SizedBox(height: AppTheme.spacingM),
            
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    context,
                    icon: Iconsax.setting_2,
                    label: 'Pengaturan',
                    onTap: onSettings,
                    color: Colors.grey,
                  ),
                ),
                
                SizedBox(width: AppTheme.spacingM),
                
                Expanded(
                  child: _buildActionButton(
                    context,
                    icon: Iconsax.message_question,
                    label: 'Bantuan',
                    onTap: onSupport,
                    color: Colors.cyan,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
    required Color color,
  }) {
    final textTheme = Theme.of(context).textTheme;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.all(AppTheme.spacingM),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: color.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(AppTheme.spacingS),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: color,
                ),
              ),
              
              SizedBox(height: AppTheme.spacingS),
              
              Text(
                label,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}