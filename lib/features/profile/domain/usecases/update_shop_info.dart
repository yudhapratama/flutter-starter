import '../entities/shop_entity.dart';
import '../repositories/shop_repository.dart';

/// Use case untuk memperbarui informasi toko
/// 
/// Use case ini mengelola logika bisnis untuk memperbarui
/// data toko dengan validasi yang diperlukan
class UpdateShopInfo {
  final ShopRepository _repository;

  const UpdateShopInfo(this._repository);

  /// Memperbarui informasi toko
  /// 
  /// [shop] data toko yang akan diupdate
  /// Returns [ShopEntity] data toko yang sudah diupdate
  /// Throws [Exception] jika terjadi error atau validasi gagal
  Future<ShopEntity> call(ShopEntity shop) async {
    try {
      // Validasi data toko
      _validateShopData(shop);
      
      // Update timestamp
      final updatedShop = shop.copyWith(
        updatedAt: DateTime.now(),
      );
      
      return await _repository.updateShop(updatedShop);
    } catch (e) {
      throw Exception('Failed to update shop info: $e');
    }
  }

  /// Membuat toko baru
  /// 
  /// [shop] data toko yang akan dibuat
  /// Returns [ShopEntity] data toko yang sudah dibuat
  /// Throws [Exception] jika terjadi error atau validasi gagal
  Future<ShopEntity> create(ShopEntity shop) async {
    try {
      // Validasi data toko
      _validateShopData(shop);
      
      // Set timestamps untuk toko baru
      final newShop = shop.copyWith(
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isActive: true,
        isVerified: false,
        status: 'pending',
      );
      
      return await _repository.createShop(newShop);
    } catch (e) {
      throw Exception('Failed to create shop: $e');
    }
  }

  /// Mengaktifkan/menonaktifkan toko
  /// 
  /// [shopId] ID toko
  /// [isActive] status aktif toko
  /// Returns [bool] true jika berhasil
  /// Throws [Exception] jika terjadi error
  Future<bool> toggleStatus(String shopId, bool isActive) async {
    try {
      return await _repository.toggleShopStatus(shopId, isActive);
    } catch (e) {
      throw Exception('Failed to toggle shop status: $e');
    }
  }

  /// Validasi data toko sebelum update/create
  void _validateShopData(ShopEntity shop) {
    // Validasi nama toko tidak boleh kosong
    if (shop.name.trim().isEmpty) {
      throw Exception('Nama toko tidak boleh kosong');
    }

    // Validasi nama toko minimal 3 karakter
    if (shop.name.trim().length < 3) {
      throw Exception('Nama toko minimal 3 karakter');
    }

    // Validasi minimal satu alamat
    if (shop.addresses.isEmpty) {
      throw Exception('Toko harus memiliki minimal satu alamat');
    }

    // Validasi harus ada alamat utama
    final primaryAddresses = shop.addresses.where((addr) => addr.isPrimary).toList();
    if (primaryAddresses.isEmpty) {
      throw Exception('Toko harus memiliki satu alamat utama');
    }

    // Validasi hanya boleh ada satu alamat utama
    if (primaryAddresses.length > 1) {
      throw Exception('Toko hanya boleh memiliki satu alamat utama');
    }

    // Validasi setiap alamat
    for (final address in shop.addresses) {
      _validateAddressData(address);
    }

    // Validasi email jika diisi
    if (shop.email != null && shop.email!.isNotEmpty) {
      if (!_isValidEmail(shop.email!)) {
        throw Exception('Format email tidak valid');
      }
    }

    // Validasi nomor telepon jika diisi
    if (shop.phone.isNotEmpty) {
      if (!_isValidPhoneNumber(shop.phone)) {
        throw Exception('Format nomor telepon tidak valid');
      }
    }

    // Validasi website jika diisi
    if (shop.website != null && shop.website!.isNotEmpty) {
      if (!_isValidWebsite(shop.website!)) {
        throw Exception('Format website tidak valid');
      }
    }

    // Validasi minimal satu kategori
    if (shop.categories.isEmpty) {
      throw Exception('Pilih minimal satu kategori toko');
    }

    // Validasi maksimal 5 kategori
    if (shop.categories.length > 5) {
      throw Exception('Maksimal 5 kategori yang dapat dipilih');
    }
  }

  /// Validasi format email
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Validasi format nomor telepon Indonesia
  bool _isValidPhoneNumber(String phone) {
    // Format: +62xxx atau 08xxx atau 62xxx
    final phoneRegex = RegExp(
      r'^(\+62|62|0)8[1-9][0-9]{6,9}$',
    );
    return phoneRegex.hasMatch(phone.replaceAll(RegExp(r'[\s-]'), ''));
  }

  /// Validasi format kode pos Indonesia (5 digit)
  bool _isValidPostalCode(String postalCode) {
    final postalCodeRegex = RegExp(r'^[0-9]{5}$');
    return postalCodeRegex.hasMatch(postalCode);
  }

  /// Validasi format website
  bool _isValidWebsite(String website) {
    final websiteRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );
    return websiteRegex.hasMatch(website);
  }

  /// Validasi data alamat
  void _validateAddressData(dynamic address) {
    // Validasi label alamat tidak boleh kosong
    if (address.label.trim().isEmpty) {
      throw Exception('Label alamat tidak boleh kosong');
    }

    // Validasi alamat tidak boleh kosong
    if (address.address.trim().isEmpty) {
      throw Exception('Alamat tidak boleh kosong');
    }

    // Validasi kota tidak boleh kosong
    if (address.city.trim().isEmpty) {
      throw Exception('Kota tidak boleh kosong');
    }

    // Validasi provinsi tidak boleh kosong
    if (address.province.trim().isEmpty) {
      throw Exception('Provinsi tidak boleh kosong');
    }

    // Validasi kode pos
    if (!_isValidPostalCode(address.postalCode)) {
      throw Exception('Format kode pos tidak valid (harus 5 digit)');
    }

    // Validasi nomor telepon alamat jika diisi
    if (address.phone.isNotEmpty) {
      if (!_isValidPhoneNumber(address.phone)) {
        throw Exception('Format nomor telepon alamat tidak valid');
      }
    }
  }
}