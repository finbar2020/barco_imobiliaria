import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_ocurrence_entity.dart';

abstract class GetOccurrenceDetail extends UseCase<
    List<TimesheetOccurrenceEntity>, GetOccurrenceDetailParam> {}

class GetOccurrenceDetailParam {
  final String date;
  final String type;

  GetOccurrenceDetailParam({required this.date, required this.type});
}
