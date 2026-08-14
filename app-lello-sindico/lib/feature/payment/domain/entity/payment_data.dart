import 'package:lello/feature/payment/domain/entity/installment.dart';
import 'package:lello/feature/payment/domain/entity/payment_document_type.dart';

class PaymentDataEntity {
  int? idSupplier;
  String? documentSupplier;
  int? idContract;
  String? documentNumber;
  PaymentDocumentType? documentType;
  DateTime? dueDate;
  int? installmentQuantity;
  double? totalValue;
  String? observation;
  String? filePathLaunch;
  int? totalPages;
  int? ledgerAccount;
  bool? isUtilityAccount;
  bool? isSendFinancial;
  List<InstallmentEntity>? installments;

  PaymentDataEntity({
    this.idSupplier,
    this.documentSupplier,
    this.idContract,
    this.documentNumber,
    this.documentType,
    this.dueDate,
    this.installmentQuantity,
    this.totalValue,
    this.observation,
    this.filePathLaunch,
    this.totalPages,
    this.ledgerAccount,
    this.installments,
    this.isUtilityAccount,
    this.isSendFinancial,
  });

  PaymentDataEntity copyWith({
    int? idSupplier,
    String? documentSupplier,
    int? idContract,
    String? documentNumber,
    PaymentDocumentType? documentType,
    DateTime? dueDate,
    int? installmentQuantity,
    double? totalValue,
    String? observation,
    String? filePathLaunch,
    int? totalPages,
    int? ledgerAccount,
    List<InstallmentEntity>? installments,
    bool? isUtilityAccount,
    bool? isSendFinancial,
  }) {
    return PaymentDataEntity(
      idSupplier: idSupplier ?? this.idSupplier,
      documentSupplier: documentSupplier ?? this.documentSupplier,
      idContract: idContract ?? this.idContract,
      documentNumber: documentNumber ?? this.documentNumber,
      documentType: documentType ?? this.documentType,
      dueDate: dueDate ?? this.dueDate,
      installmentQuantity: installmentQuantity ?? this.installmentQuantity,
      totalValue: totalValue ?? this.totalValue,
      observation: observation ?? this.observation,
      filePathLaunch: filePathLaunch ?? this.filePathLaunch,
      totalPages: totalPages ?? this.totalPages,
      ledgerAccount: ledgerAccount ?? this.ledgerAccount,
      installments: installments ?? this.installments,
      isUtilityAccount: isUtilityAccount ?? this.isUtilityAccount,
      isSendFinancial: isSendFinancial ?? this.isSendFinancial,
    );
  }

  toJson() {
    return {
      'idSupplier': idSupplier,
      'documentSupplier': documentSupplier,
      'idContract': idContract,
      'documentNumber': documentNumber,
      'documentType': documentType?.index,
      'dueDate': dueDate?.toIso8601String(),
      'installmentQuantity': installmentQuantity,
      'totalValue': totalValue,
      'observation': observation,
      'filePathLaunch': filePathLaunch,
      'totalPages': totalPages,
      'ledgerAccount': ledgerAccount,
      'isUtilityAccount': isUtilityAccount,
      'isSendFinancial': isSendFinancial,
    };
  }

  bool checkStep(int step) {
    switch (step) {
      case 0:
        return documentSupplier?.isNotEmpty == true &&
            documentType != null &&
            dueDate != null &&
            dueDate!
                .isAfter(DateTime.now().subtract(const Duration(days: 1))) &&
            totalValue != null &&
            totalValue! > 0;
      case 1:
        return installmentQuantity != null &&
            totalValue != null &&
            totalValue! > 0 &&
            checkTotalInstallmentValue;
      case 2:
        return true;
      case 3:
        return true;
      default:
        return false;
    }
  }

  bool get checkTotalInstallmentValue {
    if (installments == null) return false;
    double sum = 0.0;
    for (var item in installments!) {
      sum += item.value;
    }
    return (sum - totalValue!).abs() < 0.001;
  }
}
