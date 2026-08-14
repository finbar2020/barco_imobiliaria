import 'package:essentials/essentials.dart';
import 'package:lello/feature/payroll/domain/entity/payroll_entry.dart';

abstract class PayrollEntryRepository {
  Future<Try<List<PayrollEntry>>> list(String condominiumId, DateTime period);
}
