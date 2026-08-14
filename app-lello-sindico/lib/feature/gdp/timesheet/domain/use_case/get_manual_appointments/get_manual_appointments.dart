import 'package:essentials/essentials.dart';

abstract class GetManualAppointments
    extends UseCase<List<String>, GetManualAppointmentsParam> {}

class GetManualAppointmentsParam {
  final String numCra;
  final DateTime date;

  GetManualAppointmentsParam({required this.numCra, required this.date});
}
