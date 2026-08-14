import 'package:colaborador/feature/timesheet/domain/entity/timesheet_element_detail.dart';
import 'package:essentials/essentials.dart';

abstract class GetTimesheetDetailUsecase
    extends UseCase<List<TimesheetElementDetail>, GetTimesheetDetailParam> {}

class GetTimesheetDetailParam {
  final String condoId;
  final DateTime period;

  GetTimesheetDetailParam({
    required this.condoId,
    required this.period,
  });
}
