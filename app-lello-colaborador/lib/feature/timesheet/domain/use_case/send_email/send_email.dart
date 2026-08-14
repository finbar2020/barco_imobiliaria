import 'package:essentials/essentials.dart';

abstract class TimesheetSendEmailUsecase
    extends UseCase<bool, TimesheetSendEmailParam> {}

class TimesheetSendEmailParam {
  final String condoId;
  final String email;
  final DateTime period;

  TimesheetSendEmailParam({
    required this.condoId,
    required this.email,
    required this.period,
  });
}
