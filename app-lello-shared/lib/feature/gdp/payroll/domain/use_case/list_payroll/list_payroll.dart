import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/gdp/payroll/domain/entity/payroll.dart';

abstract class ListPayroll extends UseCase<List<Payroll>, ListPayrollParam> {}

class ListPayrollParam {
  final String condominiumId;
  ListPayrollParam({required this.condominiumId});
}
