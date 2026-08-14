import 'package:essentials/essentials.dart';
import 'package:lello/feature/payroll/domain/entity/payroll.dart';

abstract class GetPayroll extends UseCase<Payroll, GetPayrollParam> {}

class GetPayrollParam {
  final String condominiumId;
  final DateTime period;
  GetPayrollParam({required this.condominiumId, required this.period});
}
