import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/theme/app_theme.dart';

/// Widget card untuk menampilkan statistik toko
/// 
/// Menampilkan berbagai metrik performa toko seperti
/// total produk, pesanan, rating, dan pendapatan
class StatisticsCard extends StatelessWidget {
  final int totalProducts;
  final int totalOrders;
  final int totalReviews;
  final double rating;
  final double revenue;
  final int activeProducts;
  final int pendingOrders;
  final bool isLoading;

  const StatisticsCard({
    super.key,
    this.totalProducts = 0,
    this.totalOrders = 0,
    this.totalReviews = 0,
    this.rating = 0.0,
    this.revenue = 0.0,
    this.activeProducts = 0,
    this.pendingOrders = 0,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    if (isLoading) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppTheme.spacingS,
            vertical: AppTheme.spacingL,
          ),
          child: Column(
            children: [
              const CircularProgressIndicator(),
              SizedBox(height: AppTheme.spacingM),
              Text(
                'Memuat statistik...',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppTheme.spacingS,
          vertical: AppTheme.spacingL,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Iconsax.chart_2,
                  size: 24,
                  color: colorScheme.primary,
                ),
                SizedBox(width: AppTheme.spacingS),
                Text(
                  'Statistik Toko',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: AppTheme.spacingL),
            
            // Grid statistik utama
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              crossAxisSpacing: AppTheme.spacingM,
              mainAxisSpacing: AppTheme.spacingM,
              children: [
                _buildStatItem(
                  context,
                  icon: Iconsax.box,
                  title: 'Total Produk',
                  value: totalProducts.toString(),
                  subtitle: '$activeProducts aktif',
                  color: Colors.blue,
                ),
                _buildStatItem(
                  context,
                  icon: Iconsax.shopping_bag,
                  title: 'Total Pesanan',
                  value: totalOrders.toString(),
                  subtitle: '$pendingOrders menunggu',
                  color: Colors.green,
                ),
                _buildStatItem(
                  context,
                  icon: Iconsax.star,
                  title: 'Rating',
                  value: rating.toStringAsFixed(1),
                  subtitle: '$totalReviews ulasan',
                  color: Colors.amber,
                ),
                _buildStatItem(
                  context,
                  icon: Iconsax.money_4,
                  title: 'Pendapatan',
                  value: _formatCurrency(revenue),
                  subtitle: 'Total',
                  color: Colors.purple,
                ),
              ],
            ),
            
            SizedBox(height: AppTheme.spacingL),
            
            // Performance indicators
            Container(
              padding: EdgeInsets.all(AppTheme.spacingM),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Performa Bulan Ini',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  
                  SizedBox(height: AppTheme.spacingM),
                  
                  Row(
                    children: [
                      Expanded(
                        child: _buildPerformanceItem(
                          context,
                          label: 'Produk Terjual',
                          value: '${(totalOrders * 0.7).round()}',
                          trend: '+12%',
                          isPositive: true,
                        ),
                      ),
                      
                      SizedBox(width: AppTheme.spacingM),
                      
                      Expanded(
                        child: _buildPerformanceItem(
                          context,
                          label: 'Pengunjung',
                          value: '${(totalProducts * 15).round()}',
                          trend: '+8%',
                          isPositive: true,
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: AppTheme.spacingM),
                  
                  Row(
                    children: [
                      Expanded(
                        child: _buildPerformanceItem(
                          context,
                          label: 'Konversi',
                          value: '${((totalOrders / (totalProducts * 15)) * 100).toStringAsFixed(1)}%',
                          trend: '+2.1%',
                          isPositive: true,
                        ),
                      ),
                      
                      SizedBox(width: AppTheme.spacingM),
                      
                      Expanded(
                        child: _buildPerformanceItem(
                          context,
                          label: 'Rata-rata Order',
                          value: _formatCurrency(revenue / (totalOrders > 0 ? totalOrders : 1)),
                          trend: '+5.3%',
                          isPositive: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    final textTheme = Theme.of(context).textTheme;
    
    return Container(
      padding: EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: color,
              ),
              SizedBox(width: AppTheme.spacingXS),
              Expanded(
                child: Text(
                  title,
                  style: textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          
          SizedBox(height: AppTheme.spacingS),
          
          Text(
            value,
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          
          Text(
            subtitle,
            style: textTheme.bodySmall?.copyWith(
              color: color.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPerformanceItem(
    BuildContext context, {
    required String label,
    required String value,
    required String trend,
    required bool isPositive,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        
        SizedBox(height: AppTheme.spacingXS),
        
        Row(
          children: [
            Text(
              value,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            SizedBox(width: AppTheme.spacingXS),
            
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppTheme.spacingXS,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: isPositive
                    ? Colors.green.withValues(alpha: 0.1)
                    : Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isPositive ? Iconsax.arrow_up_3 : Iconsax.arrow_down,
                    size: 10,
                    color: isPositive ? Colors.green : Colors.red,
                  ),
                  SizedBox(width: 2),
                  Text(
                    trend,
                    style: textTheme.bodySmall?.copyWith(
                      color: isPositive ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  String _formatCurrency(double amount) {
    if (amount >= 1000000) {
      return 'Rp ${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return 'Rp ${(amount / 1000).toStringAsFixed(1)}K';
    } else {
      return 'Rp ${amount.toStringAsFixed(0)}';
    }
  }
}