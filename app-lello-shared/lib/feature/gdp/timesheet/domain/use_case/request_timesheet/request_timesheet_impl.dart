import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/repository/timesheet_repository.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/use_case/request_timesheet/request_timesheet.dart';

class RequestTimesheetImpl extends RequestTimesheet {
  final TimesheetGDPRepository repository;

  RequestTimesheetImpl({required this.repository});

  @override
  Future<Try<String>> call(RequestTimesheetParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.requestTimesheet(params.condominiumId);
  }

  Failure? _validate(RequestTimesheetParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
