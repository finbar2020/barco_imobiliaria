class InstallmentEntity {
  final int? id;
  final DateTime dueDate;
  final double value;
  final int? paymentFormId;
  final int? paymentTypeId;
  final String? agency;
  final int? bankId;
  final String? accountDigit;
  final String? accountNumber;
  final String? accountType;

  InstallmentEntity({
    this.id,
    required this.dueDate,
    required this.value,
    this.paymentFormId,
    this.paymentTypeId,
    this.agency,
    this.bankId,
    this.accountDigit,
    this.accountNumber,
    this.accountType,
  });

  InstallmentEntity copyWith({
    int? id,
    required DateTime dueDate,
    required double value,
    int? paymentFormId,
    int? paymentTypeId,
    String? agency,
    int? bankId,
    String? accountDigit,
    String? accountNumber,
    String? accountType,
  }) {
    return InstallmentEntity(
      id: id ?? this.id,
      dueDate: dueDate,
      value: value,
      paymentFormId: paymentFormId ?? this.paymentFormId,
      paymentTypeId: paymentTypeId ?? this.paymentTypeId,
      agency: agency ?? this.agency,
      bankId: bankId ?? this.bankId,
      accountDigit: accountDigit ?? this.accountDigit,
      accountNumber: accountNumber ?? this.accountNumber,
      accountType: accountType ?? this.accountType,
    );
  }

  int get valueInt => (value * 100).toInt();
}
