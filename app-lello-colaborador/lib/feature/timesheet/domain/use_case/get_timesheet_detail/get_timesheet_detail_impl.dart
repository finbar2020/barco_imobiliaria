import 'package:colaborador/feature/timesheet/domain/entity/timesheet_element_detail.dart';
import 'package:colaborador/feature/timesheet/domain/repository/timesheet_repository.dart';
import 'package:colaborador/feature/timesheet/domain/use_case/get_timesheet_detail/get_timesheet_detail.dart';
import 'package:essentials/essentials.dart';

class GetTimesheetDetailUsecaseImpl extends GetTimesheetDetailUsecase {
  final TimesheetRepository repository;

  GetTimesheetDetailUsecaseImpl({required this.repository});
  @override
  Future<Try<List<TimesheetElementDetail>>> call(
      GetTimesheetDetailParam params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    return await repository.getTimesheetDetail(params.condoId, params.period);
  }

  Failure? validate(GetTimesheetDetailParam? params) {
    if (params == null) return InvalidParamFailure();
    if (params.condoId.isEmpty) return InvalidParamFailure();

    return null;
  }
}
