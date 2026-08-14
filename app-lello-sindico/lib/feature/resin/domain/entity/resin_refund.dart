import 'package:intl/intl.dart';
import 'package:lello/feature/resin/domain/entity/resin_bank_account.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_inconcistency.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_receipt.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_status.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_type.dart';

class ResinRefund {
  String? id;
  DateTime? requestDate;
  String requester;
  ResinRefundStatus? status;
  ResinRefundType? type;
  double value;
  String protocol;
  String? description;
  bool canEdit;
  bool canCancel;
  ResinRefundInconcistency? inconcistency;
  List<ResinRefundReceipt> receipts;
  ResinBankAccount? destinationAccount;
  String? requesterId;

  ResinRefund({
    this.id,
    required this.requestDate,
    required this.requester,
    required this.status,
    required this.type,
    required this.value,
    this.protocol = "",
    this.receipts = const [],
    this.inconcistency,
    this.destinationAccount,
    this.canEdit = false,
    this.canCancel = false,
    this.description,
    this.requesterId,
  });

  double get getTotalReceiptsValue {
    double value = 0.0;
    receipts.forEach((element) {
      value += element.receiptValue;
    });
    return value;
  }

  String get getTotalReceiptsValueFormatted {
    double value = 0.0;
    receipts.forEach((element) {
      value += element.receiptValue;
    });
    NumberFormat format = NumberFormat.currency(symbol: "R\$");
    return format.format(value);
  }

  String get requestDateFormatted {
    if (requestDate == null) {
      return " - ";
    }
    DateFormat format = DateFormat("dd/MM/yyyy - HH:mm");
    return '${format.format(requestDate!)}h';
  }
}
