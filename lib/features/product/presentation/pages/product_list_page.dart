import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../../../core/widgets/app_button.dart';
import '../providers/product_providers.dart';
import '../widgets/product_card.dart';
import '../widgets/product_card_shimmer.dart';
import '../widgets/product_search_widget.dart';
import '../widgets/product_filter_widget.dart';
import 'product_form_page.dart';

class ProductListPage extends ConsumerStatefulWidget {
  const ProductListPage({super.key});

  @override
  ConsumerState<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends ConsumerState<ProductListPage> {
  final ScrollController _scrollController = ScrollController();
  final String _sellerId = 'seller_001'; // TODO: Get from auth state
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productNotifierProvider.notifier).loadProducts(_sellerId);
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      ref.read(productNotifierProvider.notifier).loadMoreProducts(_sellerId);
    }
  }

  Future<void> _onRefresh() async {
    await ref.read(productNotifierProvider.notifier).refreshProducts(_sellerId);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final productState = ref.watch(productNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Produk',
          style: textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(productNotifierProvider.notifier).refreshProducts(_sellerId);
            },
            icon: const Icon(Iconsax.refresh),
          ),
        ],
      ),

      body: Column(
        children: [
          // Header with Add Product Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                  // Search Widget
                  Row(
                    children: [
                      Expanded(
                        child: ProductSearchWidget(
                          initialQuery: productState.searchQuery,
                          isLoading: productState.isSearching,
                          onSearchChanged: (query) {
                            ref.read(productNotifierProvider.notifier).searchProductsWithQuery(
                              query: query,
                              sellerId: _sellerId,
                              category: productState.selectedCategory,
                              status: productState.selectedStatus,
                            );
                          },
                          onClearSearch: () {
                            ref.read(productNotifierProvider.notifier).clearSearchAndLoadProducts(_sellerId);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showFilters = !_showFilters;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _showFilters || productState.selectedCategory != null || productState.selectedStatus != null
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.surface,
                            border: Border.all(
                              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.filter_list,
                            color: _showFilters || productState.selectedCategory != null || productState.selectedStatus != null
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context).colorScheme.onSurface,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
             ),
           ),
           // Filter Widget
           if (_showFilters)
             Container(
               constraints: BoxConstraints(
                 maxHeight: MediaQuery.of(context).size.height * 0.7,
               ),
               child: SingleChildScrollView(
                 child: ProductFilterWidget(
                   sellerId: _sellerId,
                   onFilterChanged: (filters) {
                     // Extract filter values from the map
                     final categories = filters['categories'] as List<String>? ?? [];
                     final statuses = filters['statuses'] as List<String>? ?? [];
                     final tags = filters['tags'] as List<String>? ?? [];
                     final minPrice = filters['minPrice'] as double?;
                     final maxPrice = filters['maxPrice'] as double?;
                     
                     ref.read(productNotifierProvider.notifier).filterProductsWithParams(
                       sellerId: _sellerId,
                       category: categories.isNotEmpty ? categories.first : null,
                       status: statuses.isNotEmpty ? statuses.first : null,
                       tags: tags.isNotEmpty ? tags : null,
                       minPrice: minPrice,
                       maxPrice: maxPrice,
                     );
                     
                     // Close filter after applying
                     setState(() {
                       _showFilters = false;
                     });
                   },
                   onClearFilters: () {
                     ref.read(productNotifierProvider.notifier).clearSearchAndLoadProducts(_sellerId);
                     
                     // Close filter after clearing
                     setState(() {
                       _showFilters = false;
                     });
                   },
                 ),
               ),
             ),
           // Content
           Expanded(
            child: productState.isLoading
                ? ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: 6, // Show 6 shimmer cards
                    itemBuilder: (context, index) => const ProductCardShimmer(),
                  )
                : productState.error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Iconsax.warning_2, size: 64, color: Colors.red),
                            const SizedBox(height: 16),
                            Text(
                              'Terjadi kesalahan',
                              style: textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              productState.error!,
                              style: textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 64),
                              child: AppButton(
                                label: 'Coba Lagi',
                                onPressed: () {
                                  ref.read(productNotifierProvider.notifier).refreshProducts(_sellerId);
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    : productState.displayedProducts.isEmpty
                         ? Center(
                             child: Column(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 Icon(
                                   productState.isSearchMode ? Iconsax.search_normal : Iconsax.box,
                                   size: 64,
                                   color: Colors.grey,
                                 ),
                                 const SizedBox(height: 16),
                                 Text(
                                   productState.isSearchMode
                                       ? 'Produk tidak ditemukan'
                                       : 'Belum ada produk',
                                   style: textTheme.headlineSmall,
                                 ),
                                 const SizedBox(height: 8),
                                 Text(
                                   productState.isSearchMode
                                       ? 'Coba kata kunci lain'
                                       : 'Tambahkan produk pertama Anda',
                                   style: textTheme.bodyMedium,
                                 ),
                                 if (!productState.isSearchMode) ...[
                                   const SizedBox(height: 16),
                                   Padding(
                                     padding: const EdgeInsets.symmetric(horizontal: 48),
                                     child: AppButton(
                                         label: 'Tambah Produk',
                                         icon: const Icon(Iconsax.add),
                                        onPressed: () {
                                         Navigator.push(
                                           context,
                                           MaterialPageRoute(
                                             builder: (context) => const ProductFormPage(),
                                           ),
                                         );
                                       },
                                     ),
                                   ),
                                 ],
                               ],
                             ),
                           )
                         : RefreshIndicator(
                             onRefresh: _onRefresh,
                             child: ListView.builder(
                               controller: _scrollController,
                               padding: const EdgeInsets.all(16),
                               itemCount: productState.displayedProducts.length + (productState.hasMore && !productState.isSearchMode ? 1 : 0),
                               itemBuilder: (context, index) {
                                 if (index == productState.displayedProducts.length) {
                                   // Loading indicator for infinite scroll
                                   return Container(
                                     padding: const EdgeInsets.all(16),
                                     alignment: Alignment.center,
                                     child: productState.isLoadingMore
                                         ? const CircularProgressIndicator()
                                         : const SizedBox.shrink(),
                                   );
                                 }
                                 
                                 final product = productState.displayedProducts[index];
                                 return ProductCard(
                                   product: product,
                                   onEdit: () {
                                     Navigator.push(
                                       context,
                                       MaterialPageRoute(
                                         builder: (context) => ProductFormPage(product: product),
                                       ),
                                     );
                                   },
                                   onDelete: () {
                                     _showDeleteConfirmation(context, product.id);
                                   },
                                 );
                               },
                             ),
                           ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ProductFormPage(),
            ),
          );
        },
        icon: const Icon(Iconsax.add),
        label: const Text('Tambah Produk'),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String productId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Produk'),
        content: const Text('Apakah Anda yakin ingin menghapus produk ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(productNotifierProvider.notifier).removeProduct(productId);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}