import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/gdp/payroll/domain/entity/payroll.dart';

abstract class PayrollEntryEvent extends Equatable {
  const PayrollEntryEvent();

  @override
  List<Object?> get props => [];
}

class PayrollEntryLoadEvent extends PayrollEntryEvent {
  final String condominiumId;
  final Payroll payroll;

  const PayrollEntryLoadEvent({
    required this.condominiumId,
    required this.payroll,
  });

  @override
  List<Object?> get props => [condominiumId, payroll];
}
