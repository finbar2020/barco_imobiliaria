import 'package:essentials/essentials.dart';
import 'package:lello/feature/payroll/domain/entity/payroll.dart';
import 'package:lello/feature/payroll/domain/repository/payroll_repository.dart';
import 'package:lello/feature/payroll/domain/use_case/list_payroll/list_payroll.dart';

class ListPayrollImpl extends ListPayroll {
  final PayrollRepository repository;

  ListPayrollImpl({required this.repository});

  @override
  Future<Try<List<Payroll>>> call(ListPayrollParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.list(params.condominiumId);
  }

  Failure? _validate(ListPayrollParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
