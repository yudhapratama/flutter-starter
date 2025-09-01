import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/entities/seller_entity.dart';

/// Widget form untuk mengedit profil seller
/// 
/// Widget ini menyediakan form lengkap untuk mengedit
/// informasi profil seller dengan validasi
class EditProfileForm extends StatefulWidget {
  final SellerEntity? seller;
  final Function(SellerEntity) onSave;
  final VoidCallback? onCancel;
  final bool isLoading;

  const EditProfileForm({
    super.key,
    this.seller,
    required this.onSave,
    this.onCancel,
    this.isLoading = false,
  });

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  final _formKey = GlobalKey<FormState>();
  
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _cityController;
  late final TextEditingController _provinceController;
  late final TextEditingController _postalCodeController;

  
  @override
  void initState() {
    super.initState();
    
    _nameController = TextEditingController(text: widget.seller?.name ?? '');
    _emailController = TextEditingController(text: widget.seller?.email ?? '');
    _phoneController = TextEditingController(text: widget.seller?.phone ?? '');
    _addressController = TextEditingController(text: widget.seller?.address ?? '');
    _cityController = TextEditingController(text: widget.seller?.city ?? '');
    _provinceController = TextEditingController(text: widget.seller?.province ?? '');
    _postalCodeController = TextEditingController(text: widget.seller?.postalCode ?? '');

  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _provinceController.dispose();
    _postalCodeController.dispose();

    super.dispose();
  }
  
  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedSeller = SellerEntity(
        id: widget.seller?.id ?? '',
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        city: _cityController.text.trim(),
        province: _provinceController.text.trim(),
        postalCode: _postalCodeController.text.trim(),
        avatar: widget.seller?.avatar,
        isVerified: widget.seller?.isVerified ?? false,
        status: widget.seller?.status ?? 'active',
        createdAt: widget.seller?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      widget.onSave(updatedSeller);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Iconsax.edit,
                color: AppTheme.primarySwatch,
                size: 24,
              ),
              SizedBox(width: AppTheme.spacingS),
              Text(
                'Edit Profil',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          
          SizedBox(height: AppTheme.spacingL),
          
          // Informasi Pribadi
          Text(
            'Informasi Pribadi',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppTheme.spacingM),
          
          AppTextField(
            controller: _nameController,
            label: 'Nama Lengkap',
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Nama lengkap tidak boleh kosong';
              }
              if (value.trim().length < 2) {
                return 'Nama lengkap minimal 2 karakter';
              }
              return null;
            },
          ),
          
          SizedBox(height: AppTheme.spacingM),
          
          AppTextField(
            controller: _emailController,
            label: 'Email',
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Email tidak boleh kosong';
              }
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailRegex.hasMatch(value.trim())) {
                return 'Format email tidak valid';
              }
              return null;
            },
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
          
          SizedBox(height: AppTheme.spacingL),
          
          // Alamat
          Text(
            'Alamat',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppTheme.spacingM),
          
          AppTextField(
            controller: _addressController,
            label: 'Alamat Lengkap',
            keyboardType: TextInputType.streetAddress,
            maxLines: 2,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Alamat tidak boleh kosong';
              }
              return null;
            },
          ),
          
          SizedBox(height: AppTheme.spacingM),
          
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _cityController,
                  label: 'Kota',
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Kota tidak boleh kosong';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(width: AppTheme.spacingM),
              Expanded(
                child: AppTextField(
                  controller: _provinceController,
                  label: 'Provinsi',
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Provinsi tidak boleh kosong';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          
          SizedBox(height: AppTheme.spacingM),
          
          AppTextField(
            controller: _postalCodeController,
            label: 'Kode Pos',
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Kode pos tidak boleh kosong';
              }
              final postalCodeRegex = RegExp(r'^[0-9]{5}$');
              if (!postalCodeRegex.hasMatch(value.trim())) {
                return 'Kode pos harus 5 digit angka';
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