import 'package:essentials/essentials.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_receipt.dart';

abstract class UploadNewReceipt
    extends UseCase<ResinRefundReceipt, UploadNewReceiptParams> {}

class UploadNewReceiptParams {
  final String condominiumId;
  final String refundId;
  final ResinRefundReceipt receipt;

  UploadNewReceiptParams({
    required this.condominiumId,
    required this.refundId,
    required this.receipt,
  });
}
