import 'package:lello/feature/resin/domain/entity/resin_refund_receipt.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_status.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_type.dart';

class ResinRefundDTO {
  String? id;
  double value;
  List<ResinRefundReceipt> receipts;
  String? description;
  ResinRefundStatus status;
  ResinRefundType type;
  String accountId;
  String requesterId;
  DateTime? requestDate;

  ResinRefundDTO({
    this.id,
    required this.value,
    required this.receipts,
    required this.status,
    required this.type,
    required this.accountId,
    required this.requesterId,
    required this.requestDate,
    this.description,
  });
}
