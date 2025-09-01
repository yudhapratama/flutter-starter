import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/entities/shop_entity.dart';
import '../../domain/entities/address_entity.dart';

/// Widget form untuk mengedit informasi toko
/// 
/// Widget ini menyediakan form lengkap untuk mengedit
/// informasi toko dengan validasi
class EditShopForm extends StatefulWidget {
  final ShopEntity? shop;
  final Function(ShopEntity) onSave;
  final VoidCallback? onCancel;
  final bool isLoading;
  final List<String> availableCategories;

  const EditShopForm({
    super.key,
    this.shop,
    required this.onSave,
    this.onCancel,
    this.isLoading = false,
    this.availableCategories = const [],
  });

  @override
  State<EditShopForm> createState() => _EditShopFormState();
}

class _EditShopFormState extends State<EditShopForm> {
  final _formKey = GlobalKey<FormState>();
  
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _websiteController;
  
  List<String> _selectedCategories = [];
  List<AddressEntity> _addresses = [];
  
  @override
  void initState() {
    super.initState();
    
    _nameController = TextEditingController(text: widget.shop?.name ?? '');
    _descriptionController = TextEditingController(text: widget.shop?.description ?? '');
    _phoneController = TextEditingController(text: widget.shop?.phone ?? '');
    _emailController = TextEditingController(text: widget.shop?.email ?? '');
    _websiteController = TextEditingController(text: widget.shop?.website ?? '');
    
    _selectedCategories = List.from(widget.shop?.categories ?? []);
    _addresses = List.from(widget.shop?.addresses ?? []);
    
    // Jika tidak ada alamat, buat alamat default
    if (_addresses.isEmpty) {
      _addresses.add(AddressEntity(
        id: '',
        shopId: '',
        label: 'Alamat Utama',
        address: '',
        city: '',
        province: '',
        postalCode: '',
        phone: '',
        isPrimary: true,
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));
    }
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    super.dispose();
  }
  
  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedCategories.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pilih minimal satu kategori toko'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      // Validasi alamat
      if (_addresses.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Minimal harus ada satu alamat'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      final hasPrimary = _addresses.any((addr) => addr.isPrimary);
      if (!hasPrimary) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Harus ada satu alamat utama'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      final updatedShop = ShopEntity(
        id: widget.shop?.id ?? '',
        sellerId: widget.shop?.sellerId ?? '',
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        logo: widget.shop?.logo,
        banner: widget.shop?.banner,
        addresses: _addresses,
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
        website: _websiteController.text.trim().isEmpty ? null : _websiteController.text.trim(),
        socialMedia: widget.shop?.socialMedia ?? {},
        businessHours: widget.shop?.businessHours ?? {},
        categories: _selectedCategories,
        rating: widget.shop?.rating ?? 0.0,
        totalReviews: widget.shop?.totalReviews ?? 0,
        totalProducts: widget.shop?.totalProducts ?? 0,
        totalOrders: widget.shop?.totalOrders ?? 0,
        revenue: widget.shop?.revenue ?? 0.0,
        createdAt: widget.shop?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
        isActive: widget.shop?.isActive ?? true,
        isVerified: widget.shop?.isVerified ?? false,
        status: widget.shop?.status ?? 'pending',
      );
      
      widget.onSave(updatedShop);
    }
  }
  
  void _showCategorySelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(AppTheme.spacingM),
          child: Column(
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.only(bottom: AppTheme.spacingM),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Title
              Text(
                'Pilih Kategori Toko',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              SizedBox(height: AppTheme.spacingM),
              
              // Categories list
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: widget.availableCategories.length,
                  itemBuilder: (context, index) {
                    final category = widget.availableCategories[index];
                    final isSelected = _selectedCategories.contains(category);
                    
                    return CheckboxListTile(
                      title: Text(category),
                      value: isSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            if (_selectedCategories.length < 5) {
                              _selectedCategories.add(category);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Maksimal 5 kategori yang dapat dipilih'),
                                ),
                              );
                            }
                          } else {
                            _selectedCategories.remove(category);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
              
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'Batal',
                      onPressed: () => Navigator.pop(context),
                      isOutlined: true,
                    ),
                  ),
                  SizedBox(width: AppTheme.spacingM),
                  Expanded(
                    child: AppButton(
                      label: 'Selesai',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _showAddressManager() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(AppTheme.spacingM),
          child: Column(
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.only(bottom: AppTheme.spacingM),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Title
              Row(
                children: [
                  Text(
                    'Kelola Alamat Toko',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: _addNewAddress,
                    icon: const Icon(Iconsax.add),
                  ),
                ],
              ),
              
              SizedBox(height: AppTheme.spacingM),
              
              // Addresses list
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: _addresses.length,
                  itemBuilder: (context, index) {
                    final address = _addresses[index];
                    
                    return Card(
                      margin: EdgeInsets.only(bottom: AppTheme.spacingS),
                      child: ListTile(
                        title: Text(address.label),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(address.address),
                            Text('${address.city}, ${address.province} ${address.postalCode}'),
                            if (address.phone?.isNotEmpty == true) Text('Tel: ${address.phone}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (address.isPrimary)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppTheme.primarySwatch,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'Utama',
                                  style: TextStyle(color: Colors.white, fontSize: 12),
                                ),
                              ),
                            PopupMenuButton(
                              itemBuilder: (context) => [
                                if (!address.isPrimary)
                                  PopupMenuItem(
                                    value: 'primary',
                                    child: const Text('Jadikan Utama'),
                                  ),
                                PopupMenuItem(
                                  value: 'edit',
                                  child: const Text('Edit'),
                                ),
                                if (_addresses.length > 1)
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: const Text('Hapus'),
                                  ),
                              ],
                              onSelected: (value) {
                                switch (value) {
                                  case 'primary':
                                    _setPrimaryAddress(index);
                                    break;
                                  case 'edit':
                                    _editAddress(index);
                                    break;
                                  case 'delete':
                                    _deleteAddress(index);
                                    break;
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // Close button
              AppButton(
                label: 'Selesai',
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _addNewAddress() {
    _showAddressDialog();
  }
  
  void _editAddress(int index) {
    _showAddressDialog(address: _addresses[index], index: index);
  }
  
  void _showAddressDialog({AddressEntity? address, int? index}) {
    final isEdit = address != null;
    final labelController = TextEditingController(text: address?.label ?? '');
    final addressController = TextEditingController(text: address?.address ?? '');
    final cityController = TextEditingController(text: address?.city ?? '');
    final provinceController = TextEditingController(text: address?.province ?? '');
    final postalCodeController = TextEditingController(text: address?.postalCode ?? '');
    final phoneController = TextEditingController(text: address?.phone ?? '');
    bool isPrimary = address?.isPrimary ?? false;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEdit ? 'Edit Alamat' : 'Tambah Alamat'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppTextField(
                  controller: labelController,
                  label: 'Label Alamat',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Label alamat tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppTheme.spacingM),
                AppTextField(
                  controller: addressController,
                  label: 'Alamat Lengkap',
                  maxLines: 2,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Alamat tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppTheme.spacingM),
                AppTextField(
                  controller: cityController,
                  label: 'Kota',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Kota tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppTheme.spacingM),
                AppTextField(
                  controller: provinceController,
                  label: 'Provinsi',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Provinsi tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppTheme.spacingM),
                AppTextField(
                  controller: postalCodeController,
                  label: 'Kode Pos',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Kode pos tidak boleh kosong';
                    }
                    if (value.trim().length != 5) {
                      return 'Kode pos harus 5 digit';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppTheme.spacingM),
                AppTextField(
                  controller: phoneController,
                  label: 'Nomor Telepon (Opsional)',
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: AppTheme.spacingM),
                CheckboxListTile(
                  title: const Text('Jadikan alamat utama'),
                  value: isPrimary,
                  onChanged: (value) {
                    setDialogState(() {
                      isPrimary = value ?? false;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (labelController.text.trim().isEmpty ||
                    addressController.text.trim().isEmpty ||
                    cityController.text.trim().isEmpty ||
                    provinceController.text.trim().isEmpty ||
                    postalCodeController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Semua field wajib harus diisi'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                
                final newAddress = AddressEntity(
                  id: address?.id ?? '',
                  shopId: address?.shopId ?? '',
                  label: labelController.text.trim(),
                  address: addressController.text.trim(),
                  city: cityController.text.trim(),
                  province: provinceController.text.trim(),
                  postalCode: postalCodeController.text.trim(),
                  phone: phoneController.text.trim().isEmpty ? null : phoneController.text.trim(),
                  isPrimary: isPrimary,
                  isActive: address?.isActive ?? true,
                  createdAt: address?.createdAt ?? DateTime.now(),
                  updatedAt: DateTime.now(),
                );
                
                setState(() {
                  if (isEdit && index != null) {
                    _addresses[index] = newAddress;
                  } else {
                    _addresses.add(newAddress);
                  }
                  
                  // Jika alamat ini dijadikan utama, ubah alamat lain menjadi tidak utama
                  if (isPrimary) {
                    for (int i = 0; i < _addresses.length; i++) {
                      if (i != (index ?? _addresses.length - 1)) {
                        _addresses[i] = _addresses[i].copyWith(isPrimary: false);
                      }
                    }
                  }
                });
                
                Navigator.pop(context);
              },
              child: Text(isEdit ? 'Simpan' : 'Tambah'),
            ),
          ],
        ),
      ),
    );
  }
  
  void _setPrimaryAddress(int index) {
    setState(() {
      for (int i = 0; i < _addresses.length; i++) {
        _addresses[i] = _addresses[i].copyWith(isPrimary: i == index);
      }
    });
  }
  
  void _deleteAddress(int index) {
    if (_addresses.length > 1) {
      setState(() {
        final wasDeleted = _addresses[index];
        _addresses.removeAt(index);
        
        // Jika alamat yang dihapus adalah alamat utama, jadikan alamat pertama sebagai utama
        if (wasDeleted.isPrimary && _addresses.isNotEmpty) {
          _addresses[0] = _addresses[0].copyWith(isPrimary: true);
        }
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final primaryAddress = _addresses.isNotEmpty 
        ? _addresses.firstWhere((addr) => addr.isPrimary, orElse: () => _addresses.first)
        : null;
    
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Iconsax.shop,
                color: AppTheme.primarySwatch,
                size: 24,
              ),
              SizedBox(width: AppTheme.spacingS),
              Text(
                'Edit Informasi Toko',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          
          SizedBox(height: AppTheme.spacingL),
          
          // Informasi Dasar
          Text(
            'Informasi Dasar',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppTheme.spacingM),
          
          AppTextField(
            controller: _nameController,
            label: 'Nama Toko',
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Nama toko tidak boleh kosong';
              }
              if (value.trim().length < 3) {
                return 'Nama toko minimal 3 karakter';
              }
              return null;
            },
          ),
          
          SizedBox(height: AppTheme.spacingM),
          
          AppTextField(
            controller: _descriptionController,
            label: 'Deskripsi Toko',
            keyboardType: TextInputType.multiline,
            maxLines: 3,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Deskripsi toko tidak boleh kosong';
              }
              return null;
            },
          ),
          
          SizedBox(height: AppTheme.spacingM),
          
          // Categories selector
          InkWell(
            onTap: _showCategorySelector,
            child: Container(
              padding: EdgeInsets.all(AppTheme.spacingM),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kategori Toko',
                          style: textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: AppTheme.spacingXS),
                        Text(
                          _selectedCategories.isEmpty
                              ? 'Pilih kategori toko'
                              : _selectedCategories.join(', '),
                          style: textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Iconsax.arrow_right_3,
                    color: Colors.grey[600],
                  ),
                ],
              ),
            ),
          ),
          
          SizedBox(height: AppTheme.spacingL),
          
          // Alamat
          Row(
            children: [
              Text(
                'Alamat Toko',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: _showAddressManager,
                child: const Text('Kelola Alamat'),
              ),
            ],
          ),
          SizedBox(height: AppTheme.spacingM),
          
          // Primary address display
          if (primaryAddress != null)
            Container(
              padding: EdgeInsets.all(AppTheme.spacingM),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        primaryAddress.label,
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primarySwatch,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Utama',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppTheme.spacingS),
                  Text(primaryAddress.address),
                  Text('${primaryAddress.city}, ${primaryAddress.province} ${primaryAddress.postalCode}'),
                  if (primaryAddress.phone?.isNotEmpty == true)
                     Text('Tel: ${primaryAddress.phone}'),
                ],
              ),
            ),
          
          SizedBox(height: AppTheme.spacingL),
          
          // Kontak
          Text(
            'Informasi Kontak',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppTheme.spacingM),
          
          AppTextField(
            controller: _phoneController,
            label: 'Nomor Telepon',
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Nomor telepon tidak boleh kosong';
              }
              final phoneRegex = RegExp(r'^(\+62|62|0)8[1-9][0-9]{6,9}$');
              final cleanPhone = value.replaceAll(RegExp(r'[\s-]'), '');
              if (!phoneRegex.hasMatch(cleanPhone)) {
                return 'Format nomor telepon tidak valid';
              }
              return null;
            },
          ),
          
          SizedBox(height: AppTheme.spacingM),
          
          AppTextField(
            controller: _emailController,
            label: 'Email (Opsional)',
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value != null && value.trim().isNotEmpty) {
                final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                if (!emailRegex.hasMatch(value.trim())) {
                  return 'Format email tidak valid';
                }
              }
              return null;
            },
          ),
          
          SizedBox(height: AppTheme.spacingM),
          
          AppTextField(
            controller: _websiteController,
            label: 'Website (Opsional)',
            keyboardType: TextInputType.url,
            validator: (value) {
              if (value != null && value.trim().isNotEmpty) {
                final websiteRegex = RegExp(
                  r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
                );
                if (!websiteRegex.hasMatch(value.trim())) {
                  return 'Format website tidak valid';
                }
              }
              return null;
            },
          ),
          
          SizedBox(height: AppTheme.spacingXL),
          
          // Action Buttons
          Row(
            children: [
              if (widget.onCancel != null) ...[
                Expanded(
                  child: AppButton(
                    label: 'Batal',
                    onPressed: widget.isLoading ? null : widget.onCancel,
                    isOutlined: true,
                  ),
                ),
                SizedBox(width: AppTheme.spacingM),
              ],
              Expanded(
                child: AppButton(
                  label: 'Simpan',
                  onPressed: widget.isLoading ? null : _handleSave,
                  loading: widget.isLoading,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}