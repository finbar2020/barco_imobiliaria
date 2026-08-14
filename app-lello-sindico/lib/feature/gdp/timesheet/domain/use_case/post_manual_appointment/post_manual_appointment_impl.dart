import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/timesheet/domain/repository/timesheet_repository.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/post_manual_appointment/post_manual_appointment.dart';

class PostManualAppointmentImpl extends PostManualAppointment {
  final TimesheetRepository repository;

  PostManualAppointmentImpl({required this.repository});

  @override
  Future<Try<String>> call(PostManualAppointmentParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.postAddManualAppointments(params.entitys);
  }

  Failure? _validate(PostManualAppointmentParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.entitys.isEmpty) return InvalidParamFailure();
    return null;
  }
}
