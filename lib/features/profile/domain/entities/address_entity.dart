/// Entity yang merepresentasikan alamat toko
/// 
/// Entity ini berisi informasi alamat yang dapat digunakan
/// untuk toko dengan dukungan multi alamat
class AddressEntity {
  final String id;
  final String shopId;
  final String label; // "Alamat Utama", "Gudang", "Cabang Jakarta", etc.
  final String address;
  final String city;
  final String province;
  final String postalCode;
  final String? phone;
  final double? latitude;
  final double? longitude;
  final bool isPrimary; // alamat utama
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AddressEntity({
    required this.id,
    required this.shopId,
    required this.label,
    required this.address,
    required this.city,
    required this.province,
    required this.postalCode,
    this.phone,
    this.latitude,
    this.longitude,
    required this.isPrimary,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Membuat copy dari entity dengan beberapa field yang diubah
  AddressEntity copyWith({
    String? id,
    String? shopId,
    String? label,
    String? address,
    String? city,
    String? province,
    String? postalCode,
    String? phone,
    double? latitude,
    double? longitude,
    bool? isPrimary,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AddressEntity(
      id: id ?? this.id,
      shopId: shopId ?? this.shopId,
      label: label ?? this.label,
      address: address ?? this.address,
      city: city ?? this.city,
      province: province ?? this.province,
      postalCode: postalCode ?? this.postalCode,
      phone: phone ?? this.phone,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isPrimary: isPrimary ?? this.isPrimary,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AddressEntity &&
        other.id == id &&
        other.shopId == shopId &&
        other.label == label &&
        other.address == address &&
        other.city == city &&
        other.province == province &&
        other.postalCode == postalCode &&
        other.phone == phone &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.isPrimary == isPrimary &&
        other.isActive == isActive &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hashAll([
      id,
      shopId,
      label,
      address,
      city,
      province,
      postalCode,
      phone,
      latitude,
      longitude,
      isPrimary,
      isActive,
      createdAt,
      updatedAt,
    ]);
  }

  @override
  String toString() {
    return 'AddressEntity(id: $id, shopId: $shopId, label: $label, address: $address, city: $city, province: $province, postalCode: $postalCode, phone: $phone, latitude: $latitude, longitude: $longitude, isPrimary: $isPrimary, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}