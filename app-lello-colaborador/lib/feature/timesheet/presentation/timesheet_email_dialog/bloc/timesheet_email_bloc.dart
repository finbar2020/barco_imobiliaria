import 'package:colaborador/core/analytics/analytics_log_events.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:colaborador/feature/timesheet/domain/use_case/send_email/send_email.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_email_dialog/bloc/timesheet_email_event.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_email_dialog/bloc/timesheet_email_state.dart';
import 'package:essentials/analytics/events/analytics_events_employee.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimesheetEmailBloc
    extends Bloc<TimesheetEmailEvent, TimesheetEmailState> {
  final TimesheetSendEmailUsecase sendEmailUsecase;
  final SessionBloc sessionBloc;

  TimesheetEmailBloc({
    required this.sendEmailUsecase,
    required this.sessionBloc,
  }) : super(const TimesheetEmailInitialState()) {
    on<SendEmailEvent>(_mapSendEmail);
    on<TryAgainEvent>(_mapTryAgain);
  }

  void sendEmail({required String email, required DateTime period}) {
    add(SendEmailEvent(email, period));
  }

  void tryAgain({String? email, required DateTime period}) {
    add(TryAgainEvent(email: email, period: period));
  }

  Future<void> _mapSendEmail(
    SendEmailEvent event,
    Emitter<TimesheetEmailState> emit,
  ) async {
    emit(TimesheetEmailLoadingState(email: event.email));
    String condoId = sessionBloc.getSession?.condominium.id ?? "";

    final result = await sendEmailUsecase.call(TimesheetSendEmailParam(
      condoId: condoId,
      email: event.email,
      period: event.period,
    ));

    TimesheetEmailState response = result
        .fold((err) => TimesheetEmailFailedState(email: event.email), (res) {
      EmployeeAnalyticsLogEvents.logEvent(
        event: AnalyticsEventsEmployee.pontoDigitalRelorioAcessar(),
        referenceValue:
            sessionBloc.getSession?.condominium.reference.toString() ?? "",
      );
      return TimesheetEmailSuccessState(email: event.email);
    });

    emit(response);
  }

  Future<void> _mapTryAgain(
    TryAgainEvent event,
    Emitter<TimesheetEmailState> emit,
  ) async {
    emit(TimesheetEmailInitialState(email: event.email));
  }
}
