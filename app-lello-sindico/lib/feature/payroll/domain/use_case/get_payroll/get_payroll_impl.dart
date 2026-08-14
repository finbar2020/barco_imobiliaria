import 'package:essentials/essentials.dart';
import 'package:lello/feature/payroll/domain/entity/payroll.dart';
import 'package:lello/feature/payroll/domain/repository/payroll_repository.dart';
import 'package:lello/feature/payroll/domain/use_case/get_payroll/get_payroll.dart';

class GetPayrollImpl extends GetPayroll {
  final PayrollRepository repository;

  GetPayrollImpl({required this.repository});

  @override
  Future<Try<Payroll>> call(GetPayrollParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.select(params.condominiumId, params.period);
  }

  Failure? _validate(GetPayrollParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
