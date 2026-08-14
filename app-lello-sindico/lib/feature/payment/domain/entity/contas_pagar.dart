class ContasPagarEntity {
  int? installmentId;
  int? supplierId;
  int? transactionId;
  int? transactionQuantity;
  String? supplierName;
  String? supplierCnpj;
  String? documentNumber;
  String? status;
  String? statusDescription;
  String? type;
  String? sendType;
  String? releaseDate;
  String? dueDate;
  String? withdrawalDate;
  double? value;
  double? totalValue;
  String? checkNumber;
  String? typeCode;
  String? account;
  String? ledgerAccountDescription;
  String? historical;
  bool? receiptFlag;
  double? inss;
  double? csll;
  double? irrf;
  double? iss;

  ContasPagarEntity({
    this.installmentId,
    this.supplierId,
    this.transactionId,
    this.transactionQuantity,
    this.supplierName,
    this.supplierCnpj,
    this.documentNumber,
    this.status,
    this.statusDescription,
    this.type,
    this.sendType,
    this.releaseDate,
    this.dueDate,
    this.withdrawalDate,
    this.value,
    this.totalValue,
    this.checkNumber,
    this.typeCode,
    this.account,
    this.ledgerAccountDescription,
    this.historical,
    this.receiptFlag,
    this.inss,
    this.csll,
    this.irrf,
    this.iss,
  });

  ContasPagarEntity copyWith({
    int? installmentId,
    int? supplierId,
    int? transactionId,
    int? transactionQuantity,
    String? supplierName,
    String? supplierCnpj,
    String? documentNumber,
    String? status,
    String? statusDescription,
    String? type,
    String? sendType,
    String? releaseDate,
    String? dueDate,
    String? withdrawalDate,
    double? value,
    double? totalValue,
    String? checkNumber,
    String? typeCode,
    String? account,
    String? ledgerAccountDescription,
    String? historical,
    bool? receiptFlag,
    double? inss,
    double? csll,
    double? irrf,
    double? iss,
  }) {
    return ContasPagarEntity(
      installmentId: installmentId ?? this.installmentId,
      supplierId: supplierId ?? this.supplierId,
      transactionId: transactionId ?? this.transactionId,
      transactionQuantity: transactionQuantity ?? this.transactionQuantity,
      supplierName: supplierName ?? this.supplierName,
      supplierCnpj: supplierCnpj ?? this.supplierCnpj,
      documentNumber: documentNumber ?? this.documentNumber,
      status: status ?? this.status,
      statusDescription: statusDescription ?? this.statusDescription,
      type: type ?? this.type,
      sendType: sendType ?? this.sendType,
      releaseDate: releaseDate ?? this.releaseDate,
      dueDate: dueDate ?? this.dueDate,
      withdrawalDate: withdrawalDate ?? this.withdrawalDate,
      value: value ?? this.value,
      totalValue: totalValue ?? this.totalValue,
      checkNumber: checkNumber ?? this.checkNumber,
      typeCode: typeCode ?? this.typeCode,
      account: account ?? this.account,
      ledgerAccountDescription:
          ledgerAccountDescription ?? this.ledgerAccountDescription,
      historical: historical ?? this.historical,
      receiptFlag: receiptFlag ?? this.receiptFlag,
      inss: inss ?? this.inss,
      csll: csll ?? this.csll,
      irrf: irrf ?? this.irrf,
      iss: iss ?? this.iss,
    );
  }
}
