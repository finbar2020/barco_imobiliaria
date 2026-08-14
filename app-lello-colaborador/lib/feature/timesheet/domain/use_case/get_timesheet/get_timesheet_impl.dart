import 'package:colaborador/feature/timesheet/domain/entity/timesheet.dart';
import 'package:colaborador/feature/timesheet/domain/repository/timesheet_repository.dart';
import 'package:colaborador/feature/timesheet/domain/use_case/get_timesheet/get_timesheet.dart';
import 'package:essentials/essentials.dart';

class GetTimesheetUsecaseImpl extends GetTimesheetUsecase {
  final TimesheetRepository repository;

  GetTimesheetUsecaseImpl({required this.repository});
  @override
  Future<Try<Timesheet>> call(GetTimesheetParam params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    return await repository.getTimesheet(params.condoId, params.period);
  }

  Failure? validate(GetTimesheetParam? params) {
    if (params == null) return InvalidParamFailure();
    if (params.condoId.isEmpty) return InvalidParamFailure();

    return null;
  }
}
