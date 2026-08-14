import 'package:colaborador/feature/timesheet/domain/entity/timesheet_sign_type_enum.dart';
import 'package:essentials/essentials.dart';

abstract class SignTimesheetUsecase extends UseCase<bool, SignTimesheetParam> {}

class SignTimesheetParam {
  final String condoId;
  final TimesheetSignTypeEnum timesheetSignTypeEnum;
  final DateTime period;

  SignTimesheetParam({
    required this.condoId,
    required this.timesheetSignTypeEnum,
    required this.period,
  });
}
