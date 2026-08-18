import 'dart:async';

import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:lello/core/analytics/analytics_log_events.dart';
import 'package:lello/feature/gdp/quick_fix/domain/entity/employee_report_filter.dart';
import 'package:lello/feature/gdp/quick_fix/domain/entity/employee_report_type.dart';
import 'package:lello/feature/gdp/quick_fix/domain/use_case/get_report/get_employee_report.dart';
import 'package:lello/feature/gdp/quick_fix/presentation/bloc/report/quick_fix_report_bloc.dart';
import 'package:lello/feature/gdp/quick_fix/presentation/bloc/report/quick_fix_report_event.dart';
import 'package:lello/feature/gdp/quick_fix/presentation/bloc/report/quick_fix_report_state.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';

class QuickFixReportBlocImpl extends QuickFixReportBloc {
  final SessionBloc sessionBloc;
  final GetEmployeeReport getEmployeeReport;

  StreamSubscription? _subscription;
  EmployeeReportFilter? _pendingFilter;

  QuickFixReportBlocImpl(
      {required this.sessionBloc, required this.getEmployeeReport})
      : super(QuickFixReportLoadingState(null, null)) {
    _subscription = this.sessionBloc.stream.listen(_onSessionChanged);
  }

  @override
  Stream<QuickFixReportState> mapEventToState(
      QuickFixReportEvent event) async* {
    if (event is QuickFixReportLoadEvent) yield* _mapLoad(event);
  }

  Stream<QuickFixReportState> _mapLoad(QuickFixReportLoadEvent event) async* {
    final condominium = event.condominium;
    final data = state.data;

    yield QuickFixReportLoadingState(data, condominium, filter: state.filter);

    final result = await getEmployeeReport.call(GetEmployeeReportParam(
        condominiumId: condominium.id,
        employeeId: event.filter!.employee!.id!,
        reportType: event.filter!.reportType!));
    var resultYield = result.fold(
        (err) => QuickFixReportLoadFailedState(data, condominium, err,
            filter: event.filter), (res) {
      String reference = sessionBloc
              .state.session!.selectedCondominium?.reference
              .toString() ??
          "";
      ManagerAnalyticsLogEvents.logEvent(
          event: AnalyticsEventsManager.resolvaRapidoFinalizado(
              EmployeeReportTypeHelper.parseString(event.filter!.reportType!)),
          referenceValue: reference);
      return QuickFixReportLoadedState(res, condominium, filter: event.filter);
    });

    yield resultYield;
  }

  void _onSessionChanged(SessionState sessionState) {
    if (sessionState is SessionLoadedState) {
      final condominium = sessionState.session?.selectedCondominium;
      if (condominium != null && _pendingFilter != null) {
        add(QuickFixReportLoadEvent(
            condominium: condominium, filter: _pendingFilter));
      }
    }
  }

  @override
  void beginLoad(EmployeeReportFilter filter) {
    if (!(sessionBloc.state is SessionLoadedState)) {
      _pendingFilter = filter;
    } else {
      add(QuickFixReportLoadEvent(
          condominium: sessionBloc.state.session!.selectedCondominium!,
          filter: filter));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
