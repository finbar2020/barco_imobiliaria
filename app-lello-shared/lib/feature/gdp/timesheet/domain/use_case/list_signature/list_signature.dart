import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_filter.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_signature.dart';

abstract class ListSignature
    extends UseCase<List<TimesheetSignature>, ListSignatureParam> {}

class ListSignatureParam {
  final String condominiumId;
  final TimesheetFilter filter;

  ListSignatureParam({required this.condominiumId, required this.filter});
}
