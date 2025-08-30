import 'package:flutter/material.dart';
import '../../../../core/widgets/shimmer_widget.dart';

/// Shimmer loading widget untuk ProductCard
class ProductCardShimmer extends StatelessWidget {
  const ProductCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product image shimmer
                const ShimmerContainer(
                  width: 80,
                  height: 80,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                const SizedBox(width: 12),
                // Product info shimmer
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product name
                      const ShimmerContainer(
                        width: double.infinity,
                        height: 16,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      const SizedBox(height: 8),
                      // Category
                      ShimmerContainer(
                        width: 100,
                        height: 12,
                        borderRadius: const BorderRadius.all(Radius.circular(4)),
                      ),
                      const SizedBox(height: 8),
                      // Status badge
                      ShimmerContainer(
                        width: 60,
                        height: 20,
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                      ),
                    ],
                  ),
                ),
                // Action buttons shimmer
                Column(
                  children: [
                    ShimmerContainer(
                      width: 32,
                      height: 32,
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                    ),
                    const SizedBox(height: 8),
                    ShimmerContainer(
                      width: 32,
                      height: 32,
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Description shimmer
            const ShimmerContainer(
              width: double.infinity,
              height: 12,
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            const SizedBox(height: 4),
            ShimmerContainer(
              width: 200,
              height: 12,
              borderRadius: const BorderRadius.all(Radius.circular(4)),
            ),
            const SizedBox(height: 12),
            // Tags shimmer
            Row(
              children: [
                ShimmerContainer(
                  width: 50,
                  height: 20,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                const SizedBox(width: 8),
                ShimmerContainer(
                  width: 60,
                  height: 20,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                const SizedBox(width: 8),
                ShimmerContainer(
                  width: 40,
                  height: 20,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Price and stock shimmer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ShimmerContainer(
                      width: 80,
                      height: 16,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    const SizedBox(height: 4),
                    ShimmerContainer(
                      width: 60,
                      height: 12,
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                    ),
                  ],
                ),
                ShimmerContainer(
                  width: 80,
                  height: 14,
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}