import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_occurrence_vacation_entity.dart';

abstract class GetOccurrenceVacation extends UseCase<
    List<TimesheetOccurrenceVacationEntity>, GetOccurrenceVacationParam> {}

class GetOccurrenceVacationParam {
  final String date;

  GetOccurrenceVacationParam({required this.date});
}
