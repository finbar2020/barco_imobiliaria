import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_appointments_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_collaborator_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_condo_location_entity.dart';

class DayAppointmentsEntity {
  final CollaboratorEntity collaborator;
  final List<AppointmentsEntity> appointments;
  final CondoLocationEntity condoLocation;
  DayAppointmentsEntity({
    required this.collaborator,
    required this.appointments,
    required this.condoLocation,
  });

  bool get showItem => appointments.isNotEmpty;

  String get marks {
    var format = DateFormat.Hm();
    if (appointments.isEmpty) {
      return "Sem marcação";
    } else {
      return "Marcação: ${appointments.map((x) => format.format(x.date)).join(" - ")}";
    }
  }

  String get pictureLink =>
      collaborator.photo.isNotEmpty == true ? collaborator.photo : "";
}
