import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_signature.dart';

abstract class SignTimesheet
    extends UseCase<List<TimesheetSignature>, SignTimesheetParam> {}

class SignTimesheetParam {
  final String condominiumId;
  final List<TimesheetSignature> signatures;

  SignTimesheetParam({required this.condominiumId, required this.signatures});
}
