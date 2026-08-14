import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_ocurrence_entity.dart';

abstract class GetGroupedOccurrence extends UseCase<
    List<TimesheetOccurrenceEntity>, GetGroupedOccurrenceParam> {}

class GetGroupedOccurrenceParam {
  final String date;
  final String type;

  GetGroupedOccurrenceParam({required this.date, required this.type});
}
