import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/app_button.dart';
import '../providers/product_providers.dart';

class ProductFilterWidget extends ConsumerStatefulWidget {
  final String sellerId;
  final Function(Map<String, dynamic>)? onFilterChanged;
  final VoidCallback? onClearFilters;

  const ProductFilterWidget({
    super.key,
    required this.sellerId,
    this.onFilterChanged,
    this.onClearFilters,
  });

  @override
  ConsumerState<ProductFilterWidget> createState() =>
      _ProductFilterWidgetState();
}

class _ProductFilterWidgetState extends ConsumerState<ProductFilterWidget> {
  final List<String> _availableCategories = [
    'Umum',
    'Makanan Pokok',
    'Ikan & Seafood',
    'Camilan',
    'Bumbu Masak',
    'Minuman',
    'Makanan Olahan',
    'Protein Nabati',
    'Dairy',
    'Roti & Kue',
    'Selai & Spread',
    'Makanan Instan',
    'Telur & Unggas',
    'Sambal & Saus',
    'Minyak & Bumbu',
    'Bahan Kue',
    'Makanan Siap Saji',
    'Pemanis Alami',
    'Lainnya',
  ];

  final List<String> _availableTags = [
    'premium',
    'organik',
    'halal',
    'import',
    'lokal',
    'bestseller',
    'promo',
    'terbaru',
    'limited',
    'handmade',
  ];

  Set<String> _selectedCategories = {};
  Set<String> _selectedStatuses = {};
  Set<String> _selectedTags = {};
  RangeValues _currentRangeValues = const RangeValues(0, 1000000);
  bool _isLoading = false;
  bool _hasHalalCertification = false;
  bool _isOrganic = false;

  @override
  void initState() {
    super.initState();
    // Delay the ref.read call to avoid StateNotifier lifecycle issues
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadInitialData();
      }
    });
  }

  @override
  void dispose() {
    // Clean up any pending operations
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Load product statistics
      if (mounted) {
        await ref
            .read(productNotifierProvider.notifier)
            .loadProductStatistics(widget.sellerId);
      }

      // Restore filter state from ProductState
      final productState = ref.read(productNotifierProvider);
      
      if (mounted) {
        setState(() {
          _selectedCategories = Set.from(productState.selectedCategories);
          _selectedStatuses = Set.from(productState.selectedStatuses);
          _selectedTags = Set.from(productState.selectedTags);
          _currentRangeValues = RangeValues(productState.minPrice, productState.maxPrice);
          _hasHalalCertification = productState.hasHalalCertification;
          _isOrganic = productState.isOrganic;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _applyFilters() {
    if (!mounted) return;

    final filters = {
      'categories': _selectedCategories.toList(),
      'statuses': _selectedStatuses.toList(),
      'tags': _selectedTags.toList(),
      'minPrice': _currentRangeValues.start,
      'maxPrice': _currentRangeValues.end,
      'hasHalalCertification': _hasHalalCertification,
      'isOrganic': _isOrganic,
    };

    // Apply filters using the notifier
    if (mounted) {
      ref
          .read(productNotifierProvider.notifier)
          .filterProductsWithParams(
            sellerId: widget.sellerId,
            category: _selectedCategories.isNotEmpty
                ? _selectedCategories.first
                : null,
            status: _selectedStatuses.isNotEmpty
                ? _selectedStatuses.first
                : null,
            tags: _selectedTags.isNotEmpty ? _selectedTags.toList() : null,
            minPrice: _currentRangeValues.start,
            maxPrice: _currentRangeValues.end,
            hasHalalCertification: _hasHalalCertification,
            isOrganic: _isOrganic,
            sortBy: 'name',
            sortOrder: 'asc',
          );
    }

    widget.onFilterChanged?.call(filters);
  }

  void _clearFilters() {
    if (!mounted) return;

    setState(() {
      _selectedCategories.clear();
      _selectedStatuses.clear();
      _selectedTags.clear();
      _currentRangeValues = const RangeValues(0, 1000000);
      _hasHalalCertification = false;
      _isOrganic = false;
    });

    // Clear filters using the notifier
    if (mounted) {
      ref
          .read(productNotifierProvider.notifier)
          .clearSearchAndLoadProducts(widget.sellerId);
    }

    widget.onClearFilters?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 16),
          _buildProductStatistics(context),
          const SizedBox(height: 24),
          _buildPriceRangeFilter(context),
          const SizedBox(height: 24),
          _buildStatusFilter(context),
          const SizedBox(height: 24),
          _buildCategoryFilter(context),
          const SizedBox(height: 24),
          _buildSpecialFilters(context),
          const SizedBox(height: 24),
          _buildTagFilter(context),
          const SizedBox(height: 32),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Text(
          'Filter Lanjutan',
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        // IconButton(
        //   onPressed: () => Navigator.of(context).pop(),
        //   icon: const Icon(Icons.close),
        // ),
      ],
    );
  }

  Widget _buildProductStatistics(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Consumer(
      builder: (context, ref, child) {
        final productState = ref.watch(productNotifierProvider);

        if (productState.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final stats = productState.productStatistics ?? {};

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Statistik Produk',
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.inventory_2_outlined,
                    label: 'Total',
                    value: stats['total']?.toString() ?? '0',
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatCard(
                    icon: Icons.check_circle_outline,
                    label: 'Aktif',
                    value: stats['active']?.toString() ?? '0',
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.warning_amber_outlined,
                    label: 'Stok Rendah',
                    value: stats['low_stock']?.toString() ?? '0',
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatCard(
                    icon: Icons.cancel_outlined,
                    label: 'Habis',
                    value: stats['out_of_stock']?.toString() ?? '0',
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildPriceRangeFilter(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rentang Harga',
          style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: colorScheme.primary,
            inactiveTrackColor: colorScheme.outline.withValues(alpha: 0.3),
            thumbColor: colorScheme.primary,
            overlayColor: colorScheme.primary.withValues(alpha: 0.1),
          ),
          child: RangeSlider(
            values: _currentRangeValues,
            min: 0,
            max: 1000000,
            divisions: 100,
            labels: RangeLabels(
              'Rp ${_formatPrice(_currentRangeValues.start)}',
              'Rp ${_formatPrice(_currentRangeValues.end)}',
            ),
            onChanged: (RangeValues values) {
              setState(() {
                _currentRangeValues = values;
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Rp ${_formatPrice(_currentRangeValues.start)}',
              style: textTheme.bodySmall,
            ),
            Text(
              'Rp ${_formatPrice(_currentRangeValues.end)}',
              style: textTheme.bodySmall,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusFilter(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Status Produk',
          style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _FilterChip(
              label: 'Semua',
              isSelected: _selectedStatuses.isEmpty,
              onTap: () {
                setState(() {
                  _selectedStatuses.clear();
                });
              },
            ),
            _FilterChip(
              label: 'Aktif',
              isSelected: _selectedStatuses.contains('active'),
              onTap: () {
                setState(() {
                  if (_selectedStatuses.contains('active')) {
                    _selectedStatuses.remove('active');
                  } else {
                    _selectedStatuses.add('active');
                  }
                });
              },
            ),
            _FilterChip(
              label: 'Tidak Aktif',
              isSelected: _selectedStatuses.contains('inactive'),
              onTap: () {
                setState(() {
                  if (_selectedStatuses.contains('inactive')) {
                    _selectedStatuses.remove('inactive');
                  } else {
                    _selectedStatuses.add('inactive');
                  }
                });
              },
            ),
            _FilterChip(
              label: 'Habis Stok',
              isSelected: _selectedStatuses.contains('out_of_stock'),
              onTap: () {
                setState(() {
                  if (_selectedStatuses.contains('out_of_stock')) {
                    _selectedStatuses.remove('out_of_stock');
                  } else {
                    _selectedStatuses.add('out_of_stock');
                  }
                });
              },
            ),
            _FilterChip(
              label: 'Draft',
              isSelected: _selectedStatuses.contains('draft'),
              onTap: () {
                setState(() {
                  if (_selectedStatuses.contains('draft')) {
                    _selectedStatuses.remove('draft');
                  } else {
                    _selectedStatuses.add('draft');
                  }
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryFilter(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kategori Produk',
          style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _FilterChip(
              label: 'Semua',
              isSelected: _selectedCategories.isEmpty,
              onTap: () {
                setState(() {
                  _selectedCategories.clear();
                });
              },
            ),
            ..._availableCategories.map(
              (category) => _FilterChip(
                label: category,
                isSelected: _selectedCategories.contains(category),
                onTap: () {
                  setState(() {
                    if (_selectedCategories.contains(category)) {
                      _selectedCategories.remove(category);
                    } else {
                      _selectedCategories.add(category);
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSpecialFilters(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Filter Khusus',
          style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        CheckboxListTile(
          title: Row(
            children: [
              const Icon(Icons.verified, size: 16, color: Colors.green),
              const SizedBox(width: 8),
              Text('Bersertifikat Halal', style: textTheme.bodyMedium),
            ],
          ),
          subtitle: Text(
            'Produk memiliki sertifikat halal resmi',
            style: textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          value: _hasHalalCertification,
          onChanged: (bool? value) {
            setState(() {
              _hasHalalCertification = value ?? false;
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
        CheckboxListTile(
          title: Row(
            children: [
              const Icon(Icons.eco, size: 16, color: Colors.green),
              const SizedBox(width: 8),
              Text('Produk Organik', style: textTheme.bodyMedium),
            ],
          ),
          subtitle: Text(
            'Produk diproduksi secara organik',
            style: textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          value: _isOrganic,
          onChanged: (bool? value) {
            setState(() {
              _isOrganic = value ?? false;
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildTagFilter(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.local_offer_outlined, size: 16),
            const SizedBox(width: 4),
            Text(
              'Tag Produk',
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Pilih tag yang sesuai untuk memudahkan pencarian',
          style: textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _availableTags.map((tag) {
            final isSelected = _selectedTags.contains(tag);
            return _FilterChip(
              label: tag,
              isSelected: isSelected,
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedTags.remove(tag);
                  } else {
                    _selectedTags.add(tag);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: AppButton(
            label: 'Terapkan Filter',
            onPressed: _applyFilters,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AppButton(
            label: 'Reset Filter',
            onPressed: _clearFilters,
            isOutlined: true,
            textColor: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  String _formatPrice(double price) {
    if (price >= 1000000) {
      return '${(price / 1000000).toStringAsFixed(1)}M';
    } else if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(0)}K';
    }
    return price.toStringAsFixed(0);
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : colorScheme.surface,
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outline.withValues(alpha: 0.3),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
