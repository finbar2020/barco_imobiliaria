import 'package:colaborador/feature/timesheet/domain/entity/timesheet.dart';
import 'package:essentials/essentials.dart';

abstract class GetTimesheetUsecase
    extends UseCase<Timesheet, GetTimesheetParam> {}

class GetTimesheetParam {
  final String condoId;
  final DateTime period;

  GetTimesheetParam({
    required this.condoId,
    required this.period,
  });
}
