import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_occurrence_request_entity.dart';

abstract class PostControlOccurrence
    extends UseCase<String, PostControlOccurrenceParam> {}

class PostControlOccurrenceParam {
  final List<TimesheetOccurrenceRequestEntity> actions;

  PostControlOccurrenceParam({required this.actions});
}
