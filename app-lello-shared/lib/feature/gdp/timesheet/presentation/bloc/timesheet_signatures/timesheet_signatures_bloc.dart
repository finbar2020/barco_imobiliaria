import 'dart:async';
import 'dart:core';

import 'package:essentials/analytics/analytics_log_events.dart';
import 'package:essentials/analytics/events/analytics_events_employee.dart';
import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/use_case/list_signature/list_signature.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/use_case/sign_timesheet/sign_timesheet.dart';
import 'package:shared_features/feature/gdp/timesheet/presentation/bloc/timesheet_signatures/timesheet_signatures_event.dart';
import 'package:shared_features/feature/gdp/timesheet/presentation/bloc/timesheet_signatures/timesheet_signatures_state.dart';
import 'package:shared_features/shared_features.dart';

class TimesheetSignaturesBloc
    extends Bloc<TimesheetSignaturesEvent, TimesheetSignaturesState> {
  final SharedSession? sessionBloc;
  final ListSignature listSignature;
  final SignTimesheet signTimesheet;
  final AppOriginEnum appOriginEnum;

  StreamSubscription? _subscription;

  TimesheetSignaturesBloc(
      {required this.sessionBloc,
      required this.listSignature,
      required this.signTimesheet,
      required this.appOriginEnum})
      : super(TimesheetSignaturesLoadingState(null, [], null, null, null)) {
    on<TimesheetSignaturesLoadEvent>(_mapLoad);
    on<TimesheetSignEvent>(_mapSign);
    _onSessionChanged();
  }
  DateTime today = new DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);

  Future<void> _mapLoad(
    TimesheetSignaturesLoadEvent event,
    Emitter<TimesheetSignaturesState> emit,
  ) async {
    final condominiumId = event.condominiumId ?? state.condominiumId;
    emit(TimesheetSignaturesLoadingState(state.signatures, state.listSign,
        state.query, condominiumId, state.selectedMonth));

    final result = await listSignature.call(ListSignatureParam(
        condominiumId: condominiumId!, filter: state.query!));

    final foldedResult = result.fold(
        (err) => TimesheetSignaturesLoadFailedState(
            state.signatures,
            state.listSign,
            state.query!,
            condominiumId,
            state.selectedMonth,
            err), (data) {
      AnalyticsLogEvents.logEvent(
        event: appOriginEnum == AppOriginEnum.manager
            ? AnalyticsEventsManager.pontoAssinaFolhaAcessar()
            : AnalyticsEventsEmployee.pontoAssinaFolhaAcessar(),
        unitValue: sessionBloc?.unitId.toString() ?? "",
        referenceValue: sessionBloc?.condominiumReference.toString() ?? "",
        appOrigin: appOriginEnum,
      );
      return TimesheetSignaturesLoadedState(data, state.listSign, state.query!,
          condominiumId, state.selectedMonth, data.length == 0);
    });

    emit(foldedResult);
  }

  Future<void> _mapSign(
    TimesheetSignEvent event,
    Emitter<TimesheetSignaturesState> emit,
  ) async {
    final condominiumId = state.condominiumId;
    emit(TimesheetSigningState(state.signatures, state.listSign, state.query!,
        condominiumId!, state.selectedMonth));

    final result = await signTimesheet.call(SignTimesheetParam(
        condominiumId: condominiumId, signatures: state.listSign));

    final foldedResult = result.fold(
        (err) => TimesheetSignFailedState(state.signatures, state.listSign,
            state.query!, condominiumId, state.selectedMonth, err), (data) {
      beginRefresh();
      AnalyticsLogEvents.logEvent(
        event: appOriginEnum == AppOriginEnum.manager
            ? AnalyticsEventsManager.pontoAssinaFolhaFinalizado()
            : AnalyticsEventsEmployee.pontoAssinaFolhaFinalizado(),
        unitValue: sessionBloc?.unitId.toString() ?? "",
        referenceValue: sessionBloc?.condominiumReference.toString() ?? "",
        appOrigin: appOriginEnum,
      );
      return TimesheetSignedState(state.signatures, state.listSign,
          state.query!, condominiumId, state.selectedMonth, true);
    });
    emit(foldedResult);
  }

  void _onSessionChanged() {
    if (sessionBloc?.condominiumId != null) {
      add(TimesheetSignaturesLoadEvent(
          condominiumId: sessionBloc!.condominiumId));
    }
  }

  void beginRefresh() {
    if (!(state is TimesheetSignaturesLoadingState)) {
      add(TimesheetSignaturesLoadEvent(condominiumId: state.condominiumId));
    }
  }

  void sign() {
    if (!(state is TimesheetSignaturesLoadingState)) {
      add(const TimesheetSignEvent());
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
