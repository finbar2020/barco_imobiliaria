// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:lello/feature/income/domain/entity/billet_status_enum.dart';

class BilletFilter {
  final String? query;
  final BilletStatus? status;
  final DateTime? period;
  final String? lastUnitId;

  BilletFilter({
    this.query,
    this.period,
    this.lastUnitId,
    this.status,
  });

  BilletFilter copyWith({
    String? query,
    BilletStatus? status,
    DateTime? period,
    String? lastUnitId,
  }) {
    return BilletFilter(
      query: query ?? this.query,
      status: status ?? this.status,
      period: period ?? this.period,
      lastUnitId: lastUnitId ?? this.lastUnitId,
    );
  }
}
