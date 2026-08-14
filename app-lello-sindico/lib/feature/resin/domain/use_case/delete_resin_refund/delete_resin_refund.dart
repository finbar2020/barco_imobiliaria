import 'package:essentials/essentials.dart';

abstract class DeleteResinRefund
    extends UseCase<bool, DeleteResinRefundParams> {}

class DeleteResinRefundParams {
  final String condominiumId;
  final String refundId;

  DeleteResinRefundParams({
    required this.condominiumId,
    required this.refundId,
  });
}
