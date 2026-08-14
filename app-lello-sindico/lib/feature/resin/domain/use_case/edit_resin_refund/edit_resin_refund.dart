import 'package:essentials/essentials.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund.dart';

abstract class EditResinRefund extends UseCase<bool, EditResinRefundParams> {}

class EditResinRefundParams {
  final String condominiumId;
  final ResinRefund refund;

  EditResinRefundParams({required this.condominiumId, required this.refund});
}
