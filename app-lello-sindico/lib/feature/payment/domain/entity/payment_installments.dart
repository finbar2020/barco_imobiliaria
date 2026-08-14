class PaymentInstallments {
  final double? value;
  final DateTime? dueDate;

  PaymentInstallments({this.value, this.dueDate});

  PaymentInstallments copyWith({
    double? value,
    DateTime? dueDate,
  }) {
    return PaymentInstallments(
      value: value ?? this.value,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}
