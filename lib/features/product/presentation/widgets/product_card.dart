import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../domain/entities/product_entity.dart';
import '../../../../core/utils/formatter.dart';

class ProductCard extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ProductCard({
    super.key,
    required this.product,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onEdit, // Navigate to edit page when card is tapped
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column - Product Image (1:1 ratio)
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: colorScheme.surfaceContainerHighest,
                ),
                child: Stack(
                  children: [
                    // Product Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: product.images.isNotEmpty
                          ? Image.network(
                              product.images.first,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 80,
                                  height: 80,
                                  color: colorScheme.surfaceContainerHighest,
                                  child: Icon(
                                    Iconsax.image,
                                    size: 24,
                                    color: colorScheme.onSurface,
                                  ),
                                );
                              },
                            )
                          : Container(
                              width: 80,
                              height: 80,
                              color: colorScheme.surfaceContainerHighest,
                              child: Icon(
                                Iconsax.image,
                                size: 24,
                                color: colorScheme.onSurface,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Right Column - Product Information
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name
                    Text(
                      product.name,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Price
                     if (product.hasDiscount && product.discountPrice != null) 
                       Row(
                         children: [
                           Text(
                             formatCurrency(product.discountPrice!),
                             style: textTheme.titleMedium?.copyWith(
                               color: colorScheme.primary,
                               fontWeight: FontWeight.bold,
                             ),
                           ),
                           const SizedBox(width: 8),
                           Text(
                             formatCurrency(product.price),
                             style: textTheme.bodySmall?.copyWith(
                               color: colorScheme.onSurface,
                               decoration: TextDecoration.lineThrough,
                             ),
                           ),
                         ],
                       )
                     else
                      Text(
                        formatCurrency(product.price),
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    const SizedBox(height: 8),
                    // Stock and Category Row
                    Row(
                      children: [
                        // Stock Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: product.stock > 0 
                                ? Colors.green.withValues(alpha: 0.1)
                : colorScheme.errorContainer.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Iconsax.box,
                                size: 10,
                                color: product.stock > 0 
                                    ? Colors.green
                                    : colorScheme.error,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                'Stok: ${product.stock}',
                                style: textTheme.labelSmall?.copyWith(
                                  color: product.stock > 0 
                                      ? Colors.green
                                      : colorScheme.error,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        // Category Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Iconsax.category,
                                size: 10,
                                color: colorScheme.onSurface,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                product.category.length > 8 
                                    ? '${product.category.substring(0, 8)}...'
                                    : product.category,
                                style: textTheme.labelSmall?.copyWith(
                                  color: colorScheme.onSurface,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Status Badge and Actions
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getStatusColor(product.status, colorScheme),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getStatusText(product.status),
                      style: textTheme.labelSmall?.copyWith(
                        color: _getStatusTextColor(product.status, colorScheme),
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Action Buttons
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                         onTap: () {
                           onEdit?.call();
                         },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(
                            Iconsax.edit_2,
                            color: colorScheme.primary,
                            size: 14,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                         onTap: () {
                           onDelete?.call();
                         },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: colorScheme.errorContainer.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(
                            Iconsax.trash,
                            color: colorScheme.error,
                            size: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status, ColorScheme colorScheme) {
    switch (status.toLowerCase()) {
      case 'active':
        return colorScheme.primaryContainer;
      case 'inactive':
        return colorScheme.errorContainer;
      case 'draft':
        return colorScheme.surfaceContainerHighest;
      default:
        return colorScheme.surfaceContainerHighest;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return 'Aktif';
      case 'inactive':
        return 'Nonaktif';
      case 'draft':
        return 'Draft';
      default:
        return status;
    }
  }

  Color _getStatusTextColor(String status, ColorScheme colorScheme) {
    switch (status.toLowerCase()) {
      case 'active':
        return colorScheme.onPrimaryContainer;
      case 'inactive':
        return colorScheme.onErrorContainer;
      case 'draft':
        return colorScheme.onSurface;
      default:
        return colorScheme.onSurface;
    }
  }
}