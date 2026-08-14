import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_add_manual_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_add_manual_enum.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_ocurrence_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_manual_appointments/get_manual_appointments.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/post_manual_appointment/post_manual_appointment.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_add_appointment/timesheet_add_appointment_bloc.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_add_appointment/timesheet_add_appointment_event.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';

class TimeItem {
  TimeOfDay timeOfDay;
  TextEditingController? controller;
  TimeItem({required this.timeOfDay, required this.controller});
}

class TimesheetAddAppointmentController {
  final SessionBloc sessionBloc;
  final TimesheetAddAppointmentBloc bloc;
  final GetManualAppointments getManualAppointments;
  final PostManualAppointment postManualAppointment;
  late final TimesheetOccurrenceEntity occurrence;

  TimesheetAddManualEnum? selectedActionType;
  String selectedJustification = "Esquecimento";

  List<TimeItem> timeList = [];

  TimesheetAddAppointmentController({
    required this.sessionBloc,
    required this.bloc,
    required this.getManualAppointments,
    required this.postManualAppointment,
  });

  final AuthenticationStore authenticationStore =
      ApplicationContainer.instance().resolve();

  void dispose() {}

  void setOcurrence(occurrence) {
    this.occurrence = occurrence;
    initalList();
    if (onlymanual) {
      selectedActionType = TimesheetAddManualEnum.casual_schedule;
    }
  }

  void initalList() {
    timeList = occurrence.marksList
        .map((e) => TimeItem(
            timeOfDay: TimeOfDay(
                hour: int.parse(e.split(":")[0]),
                minute: int.parse(e.split(":")[0])),
            controller: null))
        .toList();
  }

  Future<void> send() async {
    bloc.add(TimesheetAddAppointmentLoadingEvent());

    var sendItem = TimesheetAddManualEntity(
      numCra: occurrence.numCra,
      date: DateTime.parse(occurrence.referenceDate),
      justification: selectedJustification,
      type: selectedActionType ?? TimesheetAddManualEnum.standard_schedule,
      single: true,
      marks: timeList
          .where((element) => element.controller != null)
          .map((e) => timeOfDayToString(e.timeOfDay))
          .toList(),
    );

    final result = await postManualAppointment
        .call(PostManualAppointmentParam(entitys: [sendItem]));

    result.fold(
      (err) => bloc.add(TimesheetAddAppointmentFailedEvent(
          message: (err is KnownFailure) ? err.message : null)),
      (data) {
        bloc.add(TimesheetAddAppointmentSuccessEvent());
      },
    );
  }

  bool get canAddNew =>
      selectedActionType == TimesheetAddManualEnum.casual_schedule;
  bool get onlymanual => occurrence.marksList.length >= 3;
  bool get showAddMarkingMessage =>
      canAddNew && !timeList.any((element) => element.controller != null);

  String timeOfDayToString(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
