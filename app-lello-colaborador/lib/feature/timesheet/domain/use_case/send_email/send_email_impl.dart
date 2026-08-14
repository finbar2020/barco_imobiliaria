import 'package:colaborador/feature/timesheet/domain/repository/timesheet_repository.dart';
import 'package:colaborador/feature/timesheet/domain/use_case/send_email/send_email.dart';
import 'package:essentials/essentials.dart';

class TimesheetSendEmailUsecaseImpl extends TimesheetSendEmailUsecase {
  final TimesheetRepository repository;

  TimesheetSendEmailUsecaseImpl({required this.repository});
  @override
  Future<Try<bool>> call(TimesheetSendEmailParam params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    return await repository.sendEmail(
        params.condoId, params.email, params.period);
  }

  Failure? validate(TimesheetSendEmailParam? params) {
    if (params == null) return InvalidParamFailure();
    if (params.condoId.isEmpty) return InvalidParamFailure();
    if (params.email.isEmpty) return InvalidParamFailure();

    return null;
  }
}
