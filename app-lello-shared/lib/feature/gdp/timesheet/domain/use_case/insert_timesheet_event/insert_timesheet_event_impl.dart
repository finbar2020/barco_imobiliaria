import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_event.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/repository/timesheet_repository.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/use_case/insert_timesheet_event/insert_timesheet_event.dart';

class InsertTimesheetEventImpl extends InsertTimesheetEvent {
  final TimesheetGDPRepository repository;

  InsertTimesheetEventImpl({required this.repository});

  @override
  Future<Try<TimesheetEvent>> call(InsertTimesheetEventParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.insertTimesheetEvent(
        params.condominiumId, params.events);
  }

  Failure? _validate(InsertTimesheetEventParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
