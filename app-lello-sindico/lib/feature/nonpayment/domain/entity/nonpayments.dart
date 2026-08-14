// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:lello/feature/nonpayment/domain/entity/nonpayments_detail.dart';

class NonPayment {
  final DateTime? positionOfDay;
  final int? quotes;
  final double? value;
  final double? valueWithPenalty;
  final double? penalty;
  final List<NonPaymentsDetail?>? details;

  NonPayment({
    this.positionOfDay,
    this.quotes,
    this.value,
    this.valueWithPenalty,
    this.penalty,
    this.details,
  });
}
