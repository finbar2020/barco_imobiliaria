import 'package:lello/feature/payment/domain/entity/payment_history_item_status.dart';

class PaymentHistoryItem {
  int documentId;
  String? fileName;
  String? releaseId;
  String? reference;
  PaymentHistoryItemStatus processingStatus;
  DateTime? inclusionDate;
  double? totalValue;
  String? supplierName;
  int? installments;
  String? documentOrigin;

  PaymentHistoryItem({
    this.documentId = 0,
    this.fileName,
    this.releaseId,
    this.reference,
    this.processingStatus = PaymentHistoryItemStatus.progress,
    this.inclusionDate,
    this.totalValue,
    this.supplierName,
    this.installments,
    this.documentOrigin,
  });
}
