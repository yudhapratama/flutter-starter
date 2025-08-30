import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../../../core/widgets/app_text_field.dart';

/// Widget untuk pencarian produk
class ProductSearchWidget extends StatefulWidget {
  final String? initialQuery;
  final Function(String)? onSearchChanged;
  final Function()? onClearSearch;
  final bool isLoading;

  const ProductSearchWidget({
    super.key,
    this.initialQuery,
    this.onSearchChanged,
    this.onClearSearch,
    this.isLoading = false,
  });

  @override
  State<ProductSearchWidget> createState() => _ProductSearchWidgetState();
}

class _ProductSearchWidgetState extends State<ProductSearchWidget> {
  late final TextEditingController _searchController;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery ?? '');
    _hasText = _searchController.text.isNotEmpty;
    _searchController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onTextChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _searchController.text.isNotEmpty;
    if (_hasText != hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
    
    // Debounce search untuk menghindari terlalu banyak request
    widget.onSearchChanged?.call(_searchController.text);
  }

  void _clearSearch() {
    _searchController.clear();
    widget.onClearSearch?.call();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Stack(
        children: [
          AppTextField(
            controller: _searchController,
            label: 'Cari produk...',
            prefixIcon: widget.isLoading ? null : Iconsax.search_normal,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.search,
          ),
          // Loading indicator overlay
          if (widget.isLoading)
            Positioned(
              left: 16,
              top: 0,
              bottom: 0,
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
          // Clear button overlay
          if (_hasText)
            Positioned(
              right: 16,
              top: 0,
              bottom: 0,
              child: Center(
                child: IconButton(
                  onPressed: _clearSearch,
                  icon: const Icon(Iconsax.close_circle),
                  tooltip: 'Hapus pencarian',
                  iconSize: 20,
                ),
              ),
            ),
        ],
      ),
    );
  }
}