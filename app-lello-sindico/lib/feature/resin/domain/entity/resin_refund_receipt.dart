import 'package:intl/intl.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_digital_document.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_receipt_type.dart';

class ResinRefundReceipt {
  String? id;
  ResinRefundDigitalDocument? digitalDocument;
  DateTime? sendDate;
  double receiptValue;
  ResinRefundReceiptType? receiptType;

  ResinRefundReceipt({
    this.id,
    this.digitalDocument,
    this.sendDate,
    required this.receiptValue,
    this.receiptType,
  });

  String sendDateFormatted() {
    if (sendDate == null) {
      return " - ";
    }
    DateFormat format = DateFormat("dd/MM/yyyy - HH:mm");
    return format.format(sendDate!);
  }

  String valueFormatted() {
    NumberFormat format = NumberFormat.currency(symbol: "R\$");
    return format.format(receiptValue);
  }

  String get receiptTypeKey {
    if (receiptType == null) {
      return "";
    }
    switch (receiptType!) {
      case ResinRefundReceiptType.boleto_febraban:
        return "resin_refund_receipt_type_billet_febraban";
      case ResinRefundReceiptType.boleto_sem_codigo_febraban:
        return "resin_refund_receipt_type_billet_sem_codigo_febraban";
      case ResinRefundReceiptType.gps:
        return "resin_refund_receipt_type_gps";
      case ResinRefundReceiptType.coupon_fiscal:
        return "resin_refund_receipt_type_coupon_fiscal";
      case ResinRefundReceiptType.tax_note:
        return "resin_refund_receipt_type_tax_note";
      case ResinRefundReceiptType.papel_avulso:
        return "resin_refund_receipt_type_individual_paper";
      case ResinRefundReceiptType.receipt:
        return "resin_refund_receipt_type_receipt";
      case ResinRefundReceiptType.guide:
        return "resin_refund_receipt_type_tax_note";
    }
  }
}
