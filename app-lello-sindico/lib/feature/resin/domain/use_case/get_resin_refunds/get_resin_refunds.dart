import 'package:essentials/essentials.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_filter.dart';

abstract class GetResinRefunds
    extends UseCase<List<ResinRefund>, GetResinRefundsParams> {}

class GetResinRefundsParams {
  final String condominiumId;
  final ResinRefundFilter filter;
  final DataOrigin origin;

  GetResinRefundsParams({
    required this.condominiumId,
    required this.filter,
    required this.origin,
  });
}
