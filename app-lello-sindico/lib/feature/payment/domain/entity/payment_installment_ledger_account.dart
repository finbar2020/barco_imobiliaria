class PaymentInstallmentLedgerAccount {
  int? shortCode;
  String? name;
  String? recommendation;
  String? category;

  PaymentInstallmentLedgerAccount({
    this.shortCode,
    this.name,
    this.recommendation,
    this.category,
  });

  PaymentInstallmentLedgerAccount copyWith({
    int? shortCode,
    String? name,
    String? recommendation,
    String? category,
  }) {
    return PaymentInstallmentLedgerAccount(
      shortCode: shortCode ?? this.shortCode,
      name: name ?? this.name,
      recommendation: recommendation ?? this.recommendation,
      category: category ?? this.category,
    );
  }
}
