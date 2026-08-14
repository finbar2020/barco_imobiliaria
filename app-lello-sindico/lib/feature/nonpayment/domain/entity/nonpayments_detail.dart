// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:lello/feature/nonpayment/domain/entity/nonpayments_receipts.dart';
import 'package:lello/feature/resident/domain/entity/resident.dart';

class NonPaymentsDetail {
  final DateTime? period;
  final double? valueLiquid;
  final double? interest;
  final double? penalty;
  final double? value;
  final Resident? resident;
  final List<NonPaymentsReceipts?>? receipts;

  NonPaymentsDetail({
    this.period,
    this.valueLiquid,
    this.interest,
    this.penalty,
    this.value,
    this.resident,
    this.receipts,
  });
}
