import 'package:lello/feature/resin/domain/entity/resin_refund_inconcistency.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_status.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_type.dart';

class ResinRefundFilter {
  DateTime? startDate;
  DateTime? endDate;
  String? protocol;
  ResinRefundStatus? status;
  ResinRefundInconcistency? inconsistency;
  ResinRefundType? type;

  ResinRefundFilter({
    this.startDate,
    this.endDate,
    this.protocol,
    this.status,
    this.inconsistency,
    this.type,
  });
}
