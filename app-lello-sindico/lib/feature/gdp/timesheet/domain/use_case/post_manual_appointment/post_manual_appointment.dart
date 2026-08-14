import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_add_manual_entity.dart';

abstract class PostManualAppointment
    extends UseCase<String, PostManualAppointmentParam> {}

class PostManualAppointmentParam {
  final List<TimesheetAddManualEntity> entitys;

  PostManualAppointmentParam({required this.entitys});
}
