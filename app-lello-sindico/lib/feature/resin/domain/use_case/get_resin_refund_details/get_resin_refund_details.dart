import 'package:essentials/essentials.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund.dart';

abstract class GetResinRefundDetails
    extends UseCase<ResinRefund, GetResinRefundDetailsParams> {}

class GetResinRefundDetailsParams {
  final String condominiumId;
  final String refundId;

  GetResinRefundDetailsParams({
    required this.condominiumId,
    required this.refundId,
  });
}
