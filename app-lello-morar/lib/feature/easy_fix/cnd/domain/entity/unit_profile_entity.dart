class UnitProfileEntity {
  final String email;
  final String mobilePhone;
  final String phone;

  UnitProfileEntity({
    this.email = "",
    this.mobilePhone = "",
    this.phone = "",
  });

  UnitProfileEntity copyWith({
    String? email,
    String? celular,
    String? telefone,
  }) {
    return UnitProfileEntity(
      email: email ?? this.email,
      mobilePhone: celular ?? this.mobilePhone,
      phone: telefone ?? this.phone,
    );
  }
}
