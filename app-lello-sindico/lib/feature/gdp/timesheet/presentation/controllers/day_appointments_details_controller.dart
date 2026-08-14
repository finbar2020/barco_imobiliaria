import 'package:flutter/material.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_day_appointments_check_in_data_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_day_appointments_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_check_in_data/get_check_in_data.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_day_appointments_details_bloc/timesheet_day_appointments_details_bloc.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_day_appointments_details_bloc/timesheet_day_appointments_details_event.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';

class DayAppointmentsDetailsController {
  final SessionBloc sessionBloc;
  final GetCheckInData getCheckInData;

  DayAppointmentsEntity? appointmentsEntity;
  final TimesheetDayAppointmentsDetailsBloc bloc;

  List<TimesheetDayAppointmentsCheckInData> cacheData = [];
  String selectedCra = "";
  DateTime selectedDate = DateTime.now();

  DayAppointmentsDetailsController({
    required this.sessionBloc,
    required this.getCheckInData,
    required this.bloc,
  });

  void setDate(DateTime date) {
    selectedDate = date;
  }

  void setCra(String numcra) {
    selectedCra = numcra;
  }

  Future<void> getDetails() async {
    bloc.add(TimesheetDayAppointmentsDetailsLoadingEvent());

    var cache = cacheData
        .where((element) =>
            element.craNumber == selectedCra &&
            element.checkInDays.any(
                (element) => DateUtils.isSameDay(element.date, selectedDate)))
        .toList();
    if (cache.isNotEmpty) {
      //mock request delay para acreditar que atualizou os dados
      Future.delayed(const Duration(milliseconds: 100), () {
        bloc.add(TimesheetDayAppointmentsDetailsLoadedEvent(details: cache));
      });
      return;
    }

    final result = await getCheckInData
        .call(GetCheckInDataParam(numCra: selectedCra, date: selectedDate));

    result.fold(
      (err) => bloc.add(TimesheetDayAppointmentsDetailsFailedEvent()),
      (data) {
        cacheData.addAll(data);
        bloc.add(TimesheetDayAppointmentsDetailsLoadedEvent(details: data));
      },
    );
  }

  setDayAppointment(DayAppointmentsEntity appointmentsEntity) {
    this.appointmentsEntity = appointmentsEntity;
  }
}
