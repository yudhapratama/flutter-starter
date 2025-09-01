/// Entity yang merepresentasikan data seller profile
/// 
/// Entity ini berisi informasi lengkap tentang seller termasuk
/// data personal dan informasi kontak
class SellerEntity {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? avatar;
  final String? address;
  final String? city;
  final String? province;
  final String? postalCode;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isVerified;
  final String status; // active, inactive, suspended

  const SellerEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatar,
    this.address,
    this.city,
    this.province,
    this.postalCode,
    required this.createdAt,
    required this.updatedAt,
    required this.isVerified,
    required this.status,
  });

  /// Membuat copy dari entity dengan beberapa field yang diubah
  SellerEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatar,
    String? address,
    String? city,
    String? province,
    String? postalCode,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isVerified,
    String? status,
  }) {
    return SellerEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      address: address ?? this.address,
      city: city ?? this.city,
      province: province ?? this.province,
      postalCode: postalCode ?? this.postalCode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isVerified: isVerified ?? this.isVerified,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SellerEntity &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.phone == phone &&
        other.avatar == avatar &&
        other.address == address &&
        other.city == city &&
        other.province == province &&
        other.postalCode == postalCode &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.isVerified == isVerified &&
        other.status == status;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      email,
      phone,
      avatar,
      address,
      city,
      province,
      postalCode,
      createdAt,
      updatedAt,
      isVerified,
      status,
    );
  }

  @override
  String toString() {
    return 'SellerEntity(id: $id, name: $name, email: $email, phone: $phone, avatar: $avatar, address: $address, city: $city, province: $province, postalCode: $postalCode, createdAt: $createdAt, updatedAt: $updatedAt, isVerified: $isVerified, status: $status)';
  }
}