import '../entities/seller_entity.dart';
import '../repositories/seller_repository.dart';

/// Use case untuk memperbarui seller profile
/// 
/// Use case ini mengelola logika bisnis untuk memperbarui
/// data profile seller dengan validasi yang diperlukan
class UpdateSellerProfile {
  final SellerRepository _repository;

  const UpdateSellerProfile(this._repository);

  /// Memperbarui seller profile
  /// 
  /// [seller] data seller yang akan diupdate
  /// Returns [SellerEntity] data seller yang sudah diupdate
  /// Throws [Exception] jika terjadi error atau validasi gagal
  Future<SellerEntity> call(SellerEntity seller) async {
    try {
      // Validasi data seller
      _validateSellerData(seller);
      
      // Update timestamp
      final updatedSeller = seller.copyWith(
        updatedAt: DateTime.now(),
      );
      
      return await _repository.updateSellerProfile(updatedSeller);
    } catch (e) {
      throw Exception('Failed to update seller profile: $e');
    }
  }

  /// Validasi data seller sebelum update
  void _validateSellerData(SellerEntity seller) {
    // Validasi nama tidak boleh kosong
    if (seller.name.trim().isEmpty) {
      throw Exception('Nama tidak boleh kosong');
    }

    // Validasi nama minimal 2 karakter
    if (seller.name.trim().length < 2) {
      throw Exception('Nama minimal 2 karakter');
    }

    // Validasi email format
    if (!_isValidEmail(seller.email)) {
      throw Exception('Format email tidak valid');
    }

    // Validasi nomor telepon jika diisi
    if (seller.phone != null && seller.phone!.isNotEmpty) {
      if (!_isValidPhoneNumber(seller.phone!)) {
        throw Exception('Format nomor telepon tidak valid');
      }
    }

    // Validasi kode pos jika diisi
    if (seller.postalCode != null && seller.postalCode!.isNotEmpty) {
      if (!_isValidPostalCode(seller.postalCode!)) {
        throw Exception('Format kode pos tidak valid');
      }
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
}