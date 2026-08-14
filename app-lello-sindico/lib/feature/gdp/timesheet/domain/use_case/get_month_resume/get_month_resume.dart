import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_month_resume_entity.dart';

abstract class GetMonthResume
    extends UseCase<TimesheetMonthResumeEntity, GetMonthResumeParam> {}

class GetMonthResumeParam {
  final String date;

  GetMonthResumeParam({required this.date});
}
