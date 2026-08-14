import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/gdp/payroll/domain/entity/payroll_entry.dart';
import 'package:shared_features/feature/gdp/payroll/domain/repository/payroll_entry_repository.dart';
import 'package:shared_features/feature/gdp/payroll/domain/use_case/list_payroll_entry/list_payroll_entry.dart';

class ListPayrollEntryImpl extends ListPayrollEntry {
  final PayrollEntryRepository repository;

  ListPayrollEntryImpl({required this.repository});

  @override
  Future<Try<List<PayrollEntry>>> call(ListPayrollEntryParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return repository.list(params.condominiumId, params.period);
  }

  Failure? _validate(ListPayrollEntryParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
