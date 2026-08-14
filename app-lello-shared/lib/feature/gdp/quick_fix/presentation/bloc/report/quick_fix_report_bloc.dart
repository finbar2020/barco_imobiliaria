import 'dart:async';

import 'package:essentials/analytics/analytics_log_events.dart';
import 'package:essentials/analytics/events/analytics_events_employee.dart';
import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_features/feature/gdp/domain/entity/condominium.dart';
import 'package:shared_features/feature/gdp/quick_fix/domain/entity/employee_report_filter.dart';
import 'package:shared_features/feature/gdp/quick_fix/domain/entity/employee_report_type.dart';
import 'package:shared_features/feature/gdp/quick_fix/domain/use_case/get_report/get_employee_report.dart';
import 'package:shared_features/feature/gdp/quick_fix/presentation/bloc/report/quick_fix_report_event.dart';
import 'package:shared_features/feature/gdp/quick_fix/presentation/bloc/report/quick_fix_report_state.dart';
import 'package:shared_features/shared_features.dart';

class QuickFixReportBloc
    extends Bloc<QuickFixReportEvent, QuickFixReportState> {
  final CondominiumGDP condominiumId;
  final GetEmployeeReport getEmployeeReport;
  final AppOriginEnum appOriginEnum;
  final SharedSession? sessionBloc;

  StreamSubscription? _subscription;
  EmployeeReportFilter? _pendingFilter;

  QuickFixReportBloc(
      {required this.condominiumId,
      required this.getEmployeeReport,
      required this.appOriginEnum,
      required this.sessionBloc})
      : super(const QuickFixReportLoadingState(null, null)) {
    on<QuickFixReportLoadEvent>(_mapLoad);
    _onSessionChanged();
  }

  Future<void> _mapLoad(
    QuickFixReportLoadEvent event,
    Emitter<QuickFixReportState> emit,
  ) async {
    final condominium = event.condominium;
    final data = state.data;

    if (event.filter?.employee?.id == null ||
        event.filter?.reportType == null) {
      emit(QuickFixReportLoadFailedState(
          data, condominium, UnknownFailure("no_filter"),
          filter: event.filter));
      return;
    }

    emit(QuickFixReportLoadingState(data, condominium, filter: state.filter));

    final result = await getEmployeeReport.call(GetEmployeeReportParam(
        condominiumId: condominium.id,
        employeeId: event.filter!.employee!.id!,
        reportType: event.filter!.reportType!));
    var resultYield = result.fold(
        (err) => QuickFixReportLoadFailedState(data, condominium, err,
            filter: event.filter), (res) {
      AnalyticsLogEvents.logEvent(
        event: appOriginEnum == AppOriginEnum.manager
            ? AnalyticsEventsManager.resolvaRapidoFinalizado(
                EmployeeReportTypeHelper.parseString(event.filter!.reportType!))
            : AnalyticsEventsEmployee.resolvaRapidoFinalizado(
                EmployeeReportTypeHelper.parseString(
                    event.filter!.reportType!)),
        unitValue: sessionBloc?.unitId.toString() ?? "",
        referenceValue: sessionBloc?.condominiumReference.toString() ?? "",
        appOrigin: appOriginEnum,
      );
      return QuickFixReportLoadedState(res, condominium, filter: event.filter);
    });

    emit(resultYield);
  }

  void _onSessionChanged() {
    add(QuickFixReportLoadEvent(
        condominium: condominiumId, filter: _pendingFilter));
  }

  void beginLoad(EmployeeReportFilter filter) {
    _pendingFilter = filter;
    add(QuickFixReportLoadEvent(condominium: condominiumId, filter: filter));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
