import 'package:colaborador/feature/timesheet/domain/repository/timesheet_repository.dart';
import 'package:colaborador/feature/timesheet/domain/use_case/sign_timesheet/sign_timesheet.dart';
import 'package:essentials/essentials.dart';

class SignTimesheetUsecaseImpl extends SignTimesheetUsecase {
  final TimesheetRepository repository;

  SignTimesheetUsecaseImpl({required this.repository});
  @override
  Future<Try<bool>> call(SignTimesheetParam params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    return await repository.signTimesheet(
        params.condoId, params.timesheetSignTypeEnum, params.period);
  }

  Failure? validate(SignTimesheetParam? params) {
    if (params == null) return InvalidParamFailure();
    if (params.condoId.isEmpty) return InvalidParamFailure();

    return null;
  }
}
