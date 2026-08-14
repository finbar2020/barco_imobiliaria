import 'package:colaborador/core/analytics/analytics_log_events.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_sign_type_enum.dart';
import 'package:colaborador/feature/timesheet/domain/use_case/sign_timesheet/sign_timesheet.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_assign_dialog/bloc/timesheet_sign_event.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_assign_dialog/bloc/timesheet_sign_state.dart';
import 'package:essentials/analytics/events/analytics_events_employee.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimesheetSignBloc extends Bloc<TimesheetSignEvent, TimesheetSignState> {
  final SignTimesheetUsecase timesheetSignUsecase;
  final SessionBloc sessionBloc;

  TimesheetSignBloc({
    required this.timesheetSignUsecase,
    required this.sessionBloc,
  }) : super(const TimesheetSignInitialState()) {
    on<SignEvent>(_mapTimesheetSign);
  }

  void timesheetSign(DateTime period) {
    add(SignEvent(period));
  }

  Future<void> _mapTimesheetSign(
    SignEvent event,
    Emitter<TimesheetSignState> emit,
  ) async {
    emit(const TimesheetSignLoadingState());
    String condoId = sessionBloc.getSession?.condominium.id ?? "";

    EmployeeAnalyticsLogEvents.logEvent(
      event: AnalyticsEventsEmployee.pontoDigitalEspelhoPontoAssinar(),
      referenceValue:
          sessionBloc.getSession?.condominium.reference.toString() ?? "",
    );

    final result = await timesheetSignUsecase.call(SignTimesheetParam(
      condoId: condoId,
      period: event.period,
      timesheetSignTypeEnum: TimesheetSignTypeEnum.espelho,
    ));

    TimesheetSignState response = result.fold(
      (err) => const TimesheetSignFailedState(),
      (res) => const TimesheetSignSuccessState(),
    );

    emit(response);
  }
}
