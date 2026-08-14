import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_signature.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/repository/timesheet_repository.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/use_case/sign_timesheet/sign_timesheet.dart';

class SignTimesheetImpl extends SignTimesheet {
  final TimesheetGDPRepository repository;

  SignTimesheetImpl({required this.repository});

  @override
  Future<Try<List<TimesheetSignature>>> call(SignTimesheetParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.sign(params.condominiumId, params.signatures);
  }

  Failure? _validate(SignTimesheetParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    if (param.signatures.isEmpty) return InvalidParamFailure();
    return null;
  }
}
