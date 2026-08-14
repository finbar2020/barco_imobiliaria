import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/gdp/payroll/domain/entity/payroll.dart';

abstract class PayrollRepository {
  Future<Try<Payroll>> select(String condominiumId, DateTime period);
  Future<Try<List<Payroll>>> list(String condominiumId);
}
