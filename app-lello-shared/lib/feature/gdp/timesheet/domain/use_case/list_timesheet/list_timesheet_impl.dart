import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/repository/timesheet_repository.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/use_case/list_timesheet/list_timesheet.dart';

class ListTimesheetImpl extends ListTimesheet {
  final TimesheetGDPRepository repository;

  ListTimesheetImpl({required this.repository});

  @override
  Future<Try<List<Timesheet>>> call(ListTimesheetParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.list(params.condominiumId, params.filter);
  }

  Failure? _validate(ListTimesheetParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
