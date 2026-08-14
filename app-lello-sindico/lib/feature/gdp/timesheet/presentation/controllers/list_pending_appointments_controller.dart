import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_ocurrence_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_manual_appointments/get_manual_appointments.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_list_pending_appointments/timesheet_list_pending_appointments_bloc.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_list_pending_appointments/timesheet_list_pending_appointments_event.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';

class ListPendingAppointmentsController {
  final SessionBloc sessionBloc;
  final GetManualAppointments getManualAppointments;
  final TimesheetListPendingAppointmentsBloc bloc;

  late final TimesheetOccurrenceEntity occurrence;

  ListPendingAppointmentsController({
    required this.sessionBloc,
    required this.getManualAppointments,
    required this.bloc,
  });

  void setOcurrence(occurrence) {
    this.occurrence = occurrence;
  }

  Future<void> getAppointments() async {
    bloc.add(TimesheetListPendingAppointmentsLoadingEvent());

    final result = await getManualAppointments.call(GetManualAppointmentsParam(
      numCra: occurrence.numCra,
      date: DateTime.parse(occurrence.referenceDate),
    ));

    result.fold(
      (err) => bloc.add(TimesheetListPendingAppointmentsFailedEvent(err)),
      (data) {
        bloc.add(
            TimesheetListPendingAppointmentsLoadedEvent(appointments: data));
      },
    );
  }
}
