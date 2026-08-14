import 'package:flutter/material.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_day_appointments_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_day_appointments/get_day_appointments.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_day_appointments/timesheet_day_appointments_bloc.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_day_appointments/timesheet_day_appointments_event.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';

class DayAppointmentsController {
  final SessionBloc sessionBloc;
  final GetDayAppointments getDayAppointments;
  final TimesheetDayAppointmentsBloc bloc;

  DayAppointmentsController({
    required this.sessionBloc,
    required this.getDayAppointments,
    required this.bloc,
  });

  final TextEditingController searchController = TextEditingController();
  List<DayAppointmentsEntity> appointments = [];

  Future<void> getAppointments() async {
    bloc.add(DayAppointmentsLoadingEvent());

    String date = setDate(DateTime.now());

    final result =
        await getDayAppointments.call(GetDayAppointmentsParam(date: date));

    result.fold(
      (err) => bloc.add(DayAppointmentsFailedEvent()),
      (data) {
        appointments = data;
        bloc.add(DayAppointmentsLoadedEvent(appointments: data));
      },
    );
  }

  searchCollaborator() {
    if (searchController.text.isEmpty) {
      bloc.add(DayAppointmentsLoadedEvent(appointments: appointments));
      return;
    }
    var searchList = appointments
        .where((element) => element.collaborator.name
            .toUpperCase()
            .contains(searchController.text.toUpperCase()))
        .toList();
    bloc.add(DayAppointmentsLoadedEvent(appointments: searchList));
  }

  setMonth(int month) {
    if (month < 10) {
      return "0$month";
    } else {
      return month.toString();
    }
  }

  setDay(int day) {
    if (day < 10) {
      return "0$day";
    } else {
      return day.toString();
    }
  }

  setDate(DateTime date) {
    return "${date.year}-${setMonth(date.month)}-${setDay(date.day)}";
  }
}
