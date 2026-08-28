import 'dart:async';

import 'package:essentials/essentials.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation_locked_days.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation_params.dart';
import 'package:shared_features/feature/gdp/vacation/domain/use_case/get_vacation/get_vacation.dart';
import 'package:shared_features/feature/gdp/vacation/domain/use_case/get_vacation_locked_days/get_vacation_locked_days.dart';
import 'package:shared_features/feature/gdp/vacation/domain/use_case/get_vacation_period/get_vacation_period.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/bloc/details/vacation_event.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/bloc/details/vacation_state.dart';
import 'package:shared_features/shared_features.dart';

class VacationGDPBloc extends Bloc<VacationGDPEvent, VacationGDPState> {
  final SharedSession? sessionBloc;
  final GetVacation getVacation;
  final GetVacationPeriod getVacationPeriod;
  final GetLockedDays getLockedDays;
  String? pendingEmployeeId;

  StreamSubscription? _subscription;

  VacationParams? vacationParams;
  List<VacationLockedDays>? vacationLockedDays;

  VacationGDPBloc(
      {required this.sessionBloc,
      required this.getVacation,
      required this.getVacationPeriod,
      required this.getLockedDays})
      : super(const VacationGDPLoadingState(null)) {
    on<VacationGDPLoadEvent>(_mapLoad);
    on<GetLockedDaysEvent>(_mapLockedDays);
    _onSessionChanged();
  }

  Future<void> _mapLoad(
    VacationGDPLoadEvent event,
    Emitter<VacationGDPState> emit,
  ) async {
    final condominiumId = event.condominiumId;

    emit(VacationGDPLoadingState(condominiumId));

    final vacationsTask = await getVacation.call(GetVacationParam(
        condominiumId: condominiumId, employeeId: event.employeeId));

    final periodsTask = await getVacationPeriod.call(GetVacationPeriodParam(
        condominiumId: condominiumId, employeeId: event.employeeId));

    final lockedDaysTask = await getLockedDays.call(GetLockedDaysParam(
        condominiumId: condominiumId,
        employeeId: event.employeeId,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(Duration(days: 1095))));

    var result = Try.foldAll<VacationGDPState>(
        [vacationsTask, periodsTask, lockedDaysTask],
        (l) => VacationGDPLoadFailedState(condominiumId, error: l), (data) {
      Vacation? v;
      VacationParams? p;
      VacationLockedDays? l;
      data.forEach((element) {
        if (element is Vacation) v = element;
        if (element is VacationParams) p = element;
        if (element is VacationLockedDays) l = element;
      });
      vacationParams = p;
      if (l != null) vacationLockedDays = [l!];
      return VacationGDPLoadedState(v, condominiumId, p, l!);
    });

    emit(result);
  }

  Future<void> _mapLockedDays(
    GetLockedDaysEvent event,
    Emitter<VacationGDPState> emit,
  ) async {
    final condominiumId = sessionBloc?.condominiumId;
    if (condominiumId == null) return;

    final result = await getLockedDays.call(GetLockedDaysParam(
        condominiumId: condominiumId,
        employeeId: event.employeeId,
        startDate: event.startDate,
        endDate: event.endDate));

    emit(result.fold(
        (err) => VacationGDPLoadFailedState(condominiumId, error: err),
        (data) {
      vacationLockedDays = [data];
      return VacationGDPLockedDaysState(
          vacationLockedDays, event.startDate, event.endDate, condominiumId);
    }));
  }

  void _onSessionChanged() {
    if (sessionBloc?.condominiumId != null && pendingEmployeeId != null) {
      add(VacationGDPLoadEvent(
          condominiumId: sessionBloc!.condominiumId,
          employeeId: pendingEmployeeId!));
      pendingEmployeeId = null;
    }
  }

  void beginLoad(String employeeId) {
    pendingEmployeeId = employeeId;
    if (sessionBloc?.condominiumId != null) {
      add(VacationGDPLoadEvent(
          condominiumId: sessionBloc!.condominiumId, employeeId: employeeId));
    }
  }

  void getVacationLockedDays(
      String employeeId, DateTime startDate, DateTime endDate) {
    pendingEmployeeId = employeeId;
    add(GetLockedDaysEvent(
        employeeId: employeeId, startDate: startDate, endDate: endDate));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  VacationParams getVacationParams() {
    return vacationParams!;
  }
}
