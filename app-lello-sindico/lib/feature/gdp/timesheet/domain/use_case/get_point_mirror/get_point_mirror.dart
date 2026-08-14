import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_entity.dart';

abstract class GetPointMirror
    extends UseCase<List<TimesheetEntity>, GetPointMirrorParam> {}

class GetPointMirrorParam {
  final DateTime date;

  GetPointMirrorParam({required this.date});
}
