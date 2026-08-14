class PaymentInstallmentSupplier {
  final int? supplierId;
  final String? supplierDocument;
  final String? cellPhone;
  final String? block;
  final String? email;
  final String? tradeName;
  final String? legalName;
  final String? phone1;
  final String? phone2;

  PaymentInstallmentSupplier({
    this.supplierId,
    this.supplierDocument,
    this.cellPhone,
    this.block,
    this.email,
    this.tradeName,
    this.legalName,
    this.phone1,
    this.phone2,
  });

  PaymentInstallmentSupplier copyWith({
    int? supplierId,
    String? supplierDocument,
    String? cellPhone,
    String? block,
    String? email,
    String? tradeName,
    String? legalName,
    String? phone1,
    String? phone2,
  }) {
    return PaymentInstallmentSupplier(
      supplierId: supplierId ?? this.supplierId,
      supplierDocument: supplierDocument ?? this.supplierDocument,
      cellPhone: cellPhone ?? this.cellPhone,
      block: block ?? this.block,
      email: email ?? this.email,
      tradeName: tradeName ?? this.tradeName,
      legalName: legalName ?? this.legalName,
      phone1: phone1 ?? this.phone1,
      phone2: phone2 ?? this.phone2,
    );
  }
}
