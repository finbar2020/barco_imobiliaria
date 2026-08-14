import 'package:essentials/essentials.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund.dart';

abstract class CreateResinRefund
    extends UseCase<ResinRefund, CreateResinRefundParams> {}

class CreateResinRefundParams {
  final String condominiumId;
  final ResinRefund refund;

  CreateResinRefundParams({required this.condominiumId, required this.refund});
}
