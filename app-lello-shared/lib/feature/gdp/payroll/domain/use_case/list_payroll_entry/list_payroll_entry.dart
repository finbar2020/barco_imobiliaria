import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/gdp/payroll/domain/entity/payroll_entry.dart';

abstract class ListPayrollEntry
    extends UseCase<List<PayrollEntry>, ListPayrollEntryParam> {}

class ListPayrollEntryParam {
  final String condominiumId;
  final DateTime period;

  ListPayrollEntryParam({required this.condominiumId, required this.period});
}
