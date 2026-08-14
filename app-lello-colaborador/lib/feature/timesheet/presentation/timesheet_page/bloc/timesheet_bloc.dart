import 'dart:async';

import 'package:colaborador/core/stores/session_store.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_state.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_periods.dart';
import 'package:colaborador/feature/timesheet/domain/use_case/get_timesheet/get_timesheet.dart';
import 'package:colaborador/feature/timesheet/domain/use_case/get_timesheet_periods/get_timesheet_periods.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_page/bloc/timesheet_event.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_page/bloc/timesheet_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimesheetBloc extends Bloc<TimesheetEvent, TimesheetState> {
  final GetTimesheetUsecase getTimesheetUsecase;
  final GetTimesheetPeriodsUsecase getTimesheetPeriodsUsecase;
  final SessionStore store;
  final SessionBloc sessionBloc;

  StreamSubscription? _sessionSubscription;

  List<DateTime> availableDates = [];

  List<TimesheetPeriods> timesheetPeriods = [];

  TimesheetBloc({
    required this.sessionBloc,
    required this.getTimesheetUsecase,
    required this.getTimesheetPeriodsUsecase,
    required this.store,
  }) : super(const TimesheetInitialState()) {
    on<GetTimesheetEvent>(_mapGetTimesheet);
    on<GetTimesheetPeriodsEvent>(_mapGetTimesheetPeriods);
    if (sessionBloc.state is SessionLoadedState) {
      _onSessionChanged(sessionBloc.state);
    } else {
      _sessionSubscription = sessionBloc.stream.listen(_onSessionChanged);
    }
  }

  Future<void> _onSessionChanged(SessionState sessionState) async {
    if (sessionState is SessionLoadedState) {
      getTimesheetPeriods();
    }
  }

  @override
  Future<void> close() {
    _sessionSubscription?.cancel();
    return super.close();
  }

  void getTimesheetPeriods() {
    add(const GetTimesheetPeriodsEvent());
  }

  void getTimesheet({required DateTime period}) {
    add(GetTimesheetEvent(period));
  }

  Future<void> _mapGetTimesheet(
    GetTimesheetEvent event,
    Emitter<TimesheetState> emit,
  ) async {
    emit(const TimesheetLoadingState());
    String condoId = sessionBloc.getSession?.condominium.id ?? "";
    final result = await getTimesheetUsecase.call(GetTimesheetParam(
      condoId: condoId,
      period: event.period,
    ));

    TimesheetState response = result.fold(
      (err) {
        return const TimesheetFailedState();
      },
      (res) => TimesheetLoadedState(timesheet: res),
    );

    emit(response);
  }

  Future<void> _mapGetTimesheetPeriods(
    GetTimesheetPeriodsEvent event,
    Emitter<TimesheetState> emit,
  ) async {
    emit(const TimesheetPeriodsLoadingState());
    String condoId = sessionBloc.getSession?.condominium.id ?? "";
    final result =
        await getTimesheetPeriodsUsecase.call(GetTimesheetPeriodsParam(
      condoId: condoId,
    ));

    TimesheetState response = result.fold(
      (err) {
        return TimesheetPeriodsFailedState(
          errorDescription: err.error ?? "",
          errorCode: err.code.toString(),
        );
      },
      (res) {
        if (res.isNotEmpty) {
          timesheetPeriods = res;
          availableDates = res.map((e) => e.periodMonth).toList();
          return TimesheetPeriodsLoadedState(timesheetPeriods: res);
        }

        return const TimesheetPeriodsEmptyState();
      },
    );

    emit(response);
  }
}
