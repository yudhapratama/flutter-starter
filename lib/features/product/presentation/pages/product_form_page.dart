import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/entities/product_entity.dart';
import '../providers/product_providers.dart';

class ProductFormPage extends ConsumerStatefulWidget {
  final ProductEntity? product;
  const ProductFormPage({super.key, this.product});

  @override
  ConsumerState<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends ConsumerState<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Basic Information Controllers
  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _skuCtrl;
  
  // Pricing Controllers
  late final TextEditingController _priceCtrl;
  late final TextEditingController _discountPriceCtrl;
  
  // Stock & Order Controllers
  late final TextEditingController _stockCtrl;
  late final TextEditingController _minOrderCtrl;
  late final TextEditingController _maxOrderCtrl;
  
  // Shipping Controllers
  late final TextEditingController _weightCtrl;
  late final TextEditingController _lengthCtrl;
  late final TextEditingController _widthCtrl;
  late final TextEditingController _heightCtrl;
  
  // Tags Controller
  late final TextEditingController _tagsCtrl;
  
  // State Variables
  String _category = 'Umum';
  String _status = 'active';
  bool _hasDiscount = false;
  bool _hasHalalCertification = false;
  DateTime? _discountStartDate;
  DateTime? _discountEndDate;
  List<String> _images = [];
  int? _mainImageIndex;
  List<String> _tags = [];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadProductData();
  }

  void _initializeControllers() {
    _nameCtrl = TextEditingController();
    _descCtrl = TextEditingController();
    _skuCtrl = TextEditingController();
    _priceCtrl = TextEditingController();
    _discountPriceCtrl = TextEditingController();
    _stockCtrl = TextEditingController();
    _minOrderCtrl = TextEditingController(text: '1');
    _maxOrderCtrl = TextEditingController(text: '999');
    _weightCtrl = TextEditingController();
    _lengthCtrl = TextEditingController();
    _widthCtrl = TextEditingController();
    _heightCtrl = TextEditingController();
    _tagsCtrl = TextEditingController();
  }

  void _loadProductData() {
    if (widget.product != null) {
      final product = widget.product!;
      _nameCtrl.text = product.name;
      _descCtrl.text = product.description;
      _skuCtrl.text = product.sku ?? '';
      _priceCtrl.text = product.price.toString();
      _stockCtrl.text = product.stock.toString();
      _minOrderCtrl.text = product.minOrder.toString();
      _maxOrderCtrl.text = product.maxOrder.toString();
      _weightCtrl.text = product.weightInGrams.toString();
      _lengthCtrl.text = product.length?.toString() ?? '';
      _widthCtrl.text = product.width?.toString() ?? '';
      _heightCtrl.text = product.height?.toString() ?? '';
      _tagsCtrl.text = product.tags.join(', ');
      
      _category = product.category;
      _status = product.status;
      _hasDiscount = product.hasDiscount;
      _hasHalalCertification = product.hasHalalCertification;
      _discountStartDate = product.discountStartDate;
      _discountEndDate = product.discountEndDate;
      _images = List.from(product.images);
      _mainImageIndex = product.mainImageIndex;
      _tags = List.from(product.tags);
      
      if (product.discountPrice != null) {
        _discountPriceCtrl.text = product.discountPrice.toString();
      }
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _skuCtrl.dispose();
    _priceCtrl.dispose();
    _discountPriceCtrl.dispose();
    _stockCtrl.dispose();
    _minOrderCtrl.dispose();
    _maxOrderCtrl.dispose();
    _weightCtrl.dispose();
    _lengthCtrl.dispose();
    _widthCtrl.dispose();
    _heightCtrl.dispose();
    _tagsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.product == null ? 'Tambah Produk' : 'Edit Produk',
          style: textTheme.titleLarge,
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 1. Photo Section
            _buildPhotoSection(colorScheme),
            const SizedBox(height: 24),
            
            // 2. Basic Information
            _buildSectionHeader('Informasi Dasar', textTheme),
            _buildBasicInfoSection(),
            const SizedBox(height: 24),
            
            // 3. Pricing
            _buildSectionHeader('Harga', textTheme),
            _buildPricingSection(colorScheme),
            const SizedBox(height: 24),
            
            // 4. Stock & Orders
            _buildSectionHeader('Stok & Pesanan', textTheme),
            _buildStockSection(),
            const SizedBox(height: 24),
            
            // 5. Shipping
            _buildSectionHeader('Pengiriman', textTheme),
            _buildShippingSection(),
            const SizedBox(height: 24),
            
            // 6. Status & Certification
            _buildSectionHeader('Status & Sertifikasi', textTheme),
            _buildStatusSection(colorScheme),
            const SizedBox(height: 24),
            
            // 7. Tags
            _buildSectionHeader('Tag Produk', textTheme),
            _buildTagsSection(),
            const SizedBox(height: 32),
            
            // 8. Action Buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildPhotoSection(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Iconsax.camera, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text('Foto Produk (Maksimal 5 foto)', style: Theme.of(context).textTheme.titleSmall),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Iconsax.add_circle, color: colorScheme.primary),
                  const SizedBox(height: 4),
                  Text('Tambah Foto', style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Column(
      children: [
        AppTextField(
          controller: _nameCtrl,
          label: 'Nama Produk *',
          validator: (v) => v == null || v.isEmpty ? 'Nama produk wajib diisi' : null,
        ),
        const SizedBox(height: 12),
        AppTextField(
          controller: _descCtrl,
          label: 'Deskripsi Produk *',
          maxLines: 3,
          validator: (v) => v == null || v.isEmpty ? 'Deskripsi wajib diisi' : null,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: _category,
          decoration: const InputDecoration(labelText: 'Kategori Produk *'),
          items: const [
            DropdownMenuItem(value: 'Umum', child: Text('Umum')),
            DropdownMenuItem(value: 'Makanan Pokok', child: Text('Makanan Pokok')),
            DropdownMenuItem(value: 'Ikan & Seafood', child: Text('Ikan & Seafood')),
            DropdownMenuItem(value: 'Camilan', child: Text('Camilan')),
            DropdownMenuItem(value: 'Bumbu Masak', child: Text('Bumbu Masak')),
            DropdownMenuItem(value: 'Minuman', child: Text('Minuman')),
            DropdownMenuItem(value: 'Makanan Olahan', child: Text('Makanan Olahan')),
            DropdownMenuItem(value: 'Protein Nabati', child: Text('Protein Nabati')),
            DropdownMenuItem(value: 'Dairy', child: Text('Dairy')),
            DropdownMenuItem(value: 'Roti & Kue', child: Text('Roti & Kue')),
            DropdownMenuItem(value: 'Selai & Spread', child: Text('Selai & Spread')),
            DropdownMenuItem(value: 'Makanan Instan', child: Text('Makanan Instan')),
            DropdownMenuItem(value: 'Telur & Unggas', child: Text('Telur & Unggas')),
            DropdownMenuItem(value: 'Sambal & Saus', child: Text('Sambal & Saus')),
            DropdownMenuItem(value: 'Minyak & Bumbu', child: Text('Minyak & Bumbu')),
            DropdownMenuItem(value: 'Bahan Kue', child: Text('Bahan Kue')),
            DropdownMenuItem(value: 'Makanan Siap Saji', child: Text('Makanan Siap Saji')),
            DropdownMenuItem(value: 'Pemanis Alami', child: Text('Pemanis Alami')),
            DropdownMenuItem(value: 'Lainnya', child: Text('Lainnya')),
          ],
          onChanged: (v) => setState(() => _category = v ?? 'Umum'),
        ),
        const SizedBox(height: 12),
        AppTextField(
          controller: _skuCtrl,
          label: 'SKU (Opsional)',
        ),
      ],
    );
  }

  Widget _buildPricingSection(ColorScheme colorScheme) {
    return Column(
      children: [
        AppTextField(
          controller: _priceCtrl,
          label: 'Harga Produk *',
          keyboardType: TextInputType.number,
          validator: (v) {
            if (v == null || v.isEmpty) return 'Harga wajib diisi';
            final n = num.tryParse(v);
            if (n == null || n <= 0) return 'Harga tidak valid';
            return null;
          },
        ),
        const SizedBox(height: 12),
        SwitchListTile.adaptive(
          value: _hasDiscount,
          title: const Text('Beri Diskon'),
          secondary: Icon(
            _hasDiscount ? Iconsax.discount_shape : Iconsax.discount_shape,
            color: _hasDiscount ? colorScheme.primary : colorScheme.outline,
          ),
          onChanged: (v) => setState(() => _hasDiscount = v),
        ),
        if (_hasDiscount) ...[
          const SizedBox(height: 12),
          AppTextField(
            controller: _discountPriceCtrl,
            label: 'Harga Diskon *',
            keyboardType: TextInputType.number,
            validator: (v) {
              if (_hasDiscount && (v == null || v.isEmpty)) {
                return 'Harga diskon wajib diisi';
              }
              if (v != null && v.isNotEmpty) {
                final n = num.tryParse(v);
                if (n == null || n <= 0) return 'Harga diskon tidak valid';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => _selectDiscountStartDate(),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: colorScheme.outline.withValues(alpha: 0.5)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tanggal Mulai Diskon', style: Theme.of(context).textTheme.bodySmall),
                        const SizedBox(height: 4),
                        Text(
                          _discountStartDate != null
                              ? '${_discountStartDate!.day}/${_discountStartDate!.month}/${_discountStartDate!.year}'
                              : 'Pilih tanggal',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InkWell(
                  onTap: () => _selectDiscountEndDate(),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: colorScheme.outline.withValues(alpha: 0.5)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tanggal Berakhir Diskon', style: Theme.of(context).textTheme.bodySmall),
                        const SizedBox(height: 4),
                        Text(
                          _discountEndDate != null
                              ? '${_discountEndDate!.day}/${_discountEndDate!.month}/${_discountEndDate!.year}'
                              : 'Pilih tanggal',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildStockSection() {
    return Column(
      children: [
        AppTextField(
          controller: _stockCtrl,
          label: 'Jumlah Stok *',
          keyboardType: TextInputType.number,
          validator: (v) {
            if (v == null || v.isEmpty) return 'Stok wajib diisi';
            final n = int.tryParse(v);
            if (n == null || n < 0) return 'Stok tidak valid';
            return null;
          },
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: AppTextField(
                controller: _minOrderCtrl,
                label: 'Minimal Pemesanan',
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v != null && v.isNotEmpty) {
                    final n = int.tryParse(v);
                    if (n == null || n <= 0) return 'Minimal order tidak valid';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppTextField(
                controller: _maxOrderCtrl,
                label: 'Maksimal Pemesanan',
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v != null && v.isNotEmpty) {
                    final n = int.tryParse(v);
                    if (n == null || n <= 0) return 'Maksimal order tidak valid';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildShippingSection() {
    return Column(
      children: [
        AppTextField(
          controller: _weightCtrl,
          label: 'Berat Produk (gram) *',
          keyboardType: TextInputType.number,
          validator: (v) {
            if (v == null || v.isEmpty) return 'Berat wajib diisi';
            final n = num.tryParse(v);
            if (n == null || n <= 0) return 'Berat tidak valid';
            return null;
          },
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: AppTextField(
                controller: _lengthCtrl,
                label: 'Panjang (cm)',
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AppTextField(
                controller: _widthCtrl,
                label: 'Lebar (cm)',
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AppTextField(
                controller: _heightCtrl,
                label: 'Tinggi (cm)',
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusSection(ColorScheme colorScheme) {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          initialValue: _status,
          decoration: const InputDecoration(labelText: 'Status Produk'),
          items: const [
            DropdownMenuItem(value: 'active', child: Text('Aktif')),
            DropdownMenuItem(value: 'inactive', child: Text('Tidak Aktif')),
            DropdownMenuItem(value: 'draft', child: Text('Draft')),
          ],
          onChanged: (v) => setState(() => _status = v ?? 'active'),
        ),
        const SizedBox(height: 12),
        CheckboxListTile(
          value: _hasHalalCertification,
          title: const Text('Memiliki Sertifikasi Halal'),
          secondary: Icon(
            Iconsax.shield_tick,
            color: _hasHalalCertification ? colorScheme.primary : colorScheme.outline,
          ),
          onChanged: (v) => setState(() => _hasHalalCertification = v ?? false),
        ),
      ],
    );
  }

  Widget _buildTagsSection() {
    return AppTextField(
      controller: _tagsCtrl,
      label: 'Tag Produk (pisahkan dengan koma)',
      maxLines: 2,
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: AppButton(
            label: widget.product == null ? 'Simpan dan Tambahkan Produk' : 'Update Produk',
            onPressed: () => _onSubmit(false),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => _onSubmit(true),
            child: const Text('Simpan Sebagai Draft'),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDiscountStartDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _discountStartDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() => _discountStartDate = date);
    }
  }

  Future<void> _selectDiscountEndDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _discountEndDate ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: _discountStartDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() => _discountEndDate = date);
    }
  }

  void _onSubmit(bool isDraft) async {
    if (!_formKey.currentState!.validate()) return;

    // Parse tags
    _tags = _tagsCtrl.text
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList();

    final product = ProductEntity(
      id: widget.product?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      sellerId: widget.product?.sellerId ?? 'seller-1', // TODO: ambil dari auth
      name: _nameCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      price: double.parse(_priceCtrl.text.trim()),
      stock: int.parse(_stockCtrl.text.trim()),
      category: _category,
      images: _images,
      mainImageIndex: _mainImageIndex,
      sku: _skuCtrl.text.trim().isEmpty ? null : _skuCtrl.text.trim(),
      hasDiscount: _hasDiscount,
      discountPrice: _hasDiscount && _discountPriceCtrl.text.isNotEmpty
          ? double.parse(_discountPriceCtrl.text.trim())
          : null,
      discountStartDate: _hasDiscount ? _discountStartDate : null,
      discountEndDate: _hasDiscount ? _discountEndDate : null,
      minOrder: int.parse(_minOrderCtrl.text.trim()),
      maxOrder: int.parse(_maxOrderCtrl.text.trim()),
      weightInGrams: double.parse(_weightCtrl.text.trim()),
      length: _lengthCtrl.text.trim().isEmpty ? null : double.parse(_lengthCtrl.text.trim()),
      width: _widthCtrl.text.trim().isEmpty ? null : double.parse(_widthCtrl.text.trim()),
      height: _heightCtrl.text.trim().isEmpty ? null : double.parse(_heightCtrl.text.trim()),
      status: isDraft ? 'draft' : _status,
      hasHalalCertification: _hasHalalCertification,
      tags: _tags,
      createdAt: widget.product?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    if (widget.product == null) {
      final ok = await ref.read(productNotifierProvider.notifier).addProduct(product);
      if (ok && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isDraft ? 'Produk disimpan sebagai draft' : 'Produk berhasil ditambahkan'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } else {
      final ok = await ref.read(productNotifierProvider.notifier).editProduct(product);
      if (ok && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isDraft ? 'Produk disimpan sebagai draft' : 'Produk berhasil diupdate'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    }
  }
}