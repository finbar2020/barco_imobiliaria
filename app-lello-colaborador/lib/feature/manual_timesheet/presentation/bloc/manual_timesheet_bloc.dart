import 'dart:io';

import 'package:colaborador/core/analytics/analytics_log_events.dart';
import 'package:colaborador/feature/manual_timesheet/domain/entity/manual_timesheet.dart';
import 'package:colaborador/feature/manual_timesheet/domain/use_case/register_manual_timesheet/manual_timesheet.dart';
import 'package:colaborador/feature/manual_timesheet/presentation/bloc/manual_timesheet_event.dart';
import 'package:colaborador/feature/manual_timesheet/presentation/bloc/manual_timesheet_state.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:essentials/analytics/events/analytics_events_employee.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManualTimeSheetBloc
    extends Bloc<ManualTimeSheetEvent, ManualTimeSheetState> {
  final RegisterManualTimeSheetUsecase registerManualTimeSheetUsecase;
  final SessionBloc sessionBloc;

  List<DateTime> listOfMonths = [];

  ManualTimeSheetBloc({
    required this.registerManualTimeSheetUsecase,
    required this.sessionBloc,
  }) : super(const ManualTimeSheetInitialState()) {
    on<SendManualTimeSheetEvent>(_registerManualTimeSheet);
    _setListMonths();
  }

  Future<void> _registerManualTimeSheet(
    SendManualTimeSheetEvent event,
    Emitter<ManualTimeSheetState> emit,
  ) async {
    emit(const ManualTimeSheetLoadingState());

    String condoId = sessionBloc.getSession?.condominium.id ?? "";
    String meId = sessionBloc.getSession?.me.id ?? "";

    final result =
        await registerManualTimeSheetUsecase.call(RegisterManualTimeSheetParam(
      condoId: condoId,
      meId: meId,
      manualTimeSheetEntity: event.manualTimeSheetEntity,
    ));

    ManualTimeSheetState response = result.fold((error) {
      return const ManualTimeSheetRegisterFailedState();
    }, (s3) {
      EmployeeAnalyticsLogEvents.logEvent(
        event: AnalyticsEventsEmployee.homeEnvioFolhaPontoSucesso(),
        referenceValue:
            sessionBloc.getSession?.condominium.reference.toString() ?? "",
      );
      return const ManualTimeSheetRegisterLoadedState();
    });

    emit(response);
  }

  void sendManualTimeSheet(
      {required DateTime date,
      required File file,
      String? fileTempHash,
      String? typeFile}) {
    add(SendManualTimeSheetEvent(
        manualTimeSheetEntity: ManualTimeSheetEntity(date: date, file: file)));
  }

  void _setListMonths() {
    List<DateTime> list = List.generate(12, (index) {
      return DateTime(DateTime.now().year, index + 1);
    });
    list.sort((a, b) => a.compareTo(b));
    listOfMonths = list;
  }
}
