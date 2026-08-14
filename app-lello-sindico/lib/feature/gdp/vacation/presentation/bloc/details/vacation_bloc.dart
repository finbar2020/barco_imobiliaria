import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/vacation/domain/entity/vacation.dart';
import 'package:lello/feature/gdp/vacation/domain/entity/vacation_locked_days.dart';
import 'package:lello/feature/gdp/vacation/domain/entity/vacation_params.dart';
import 'package:lello/feature/gdp/vacation/domain/use_case/get_vacation/get_vacation.dart';
import 'package:lello/feature/gdp/vacation/domain/use_case/get_vacation_locked_days/get_vacation_locked_days.dart';
import 'package:lello/feature/gdp/vacation/domain/use_case/get_vacation_period/get_vacation_period.dart';
import 'package:lello/feature/gdp/vacation/presentation/bloc/details/vacation_event.dart';
import 'package:lello/feature/gdp/vacation/presentation/bloc/details/vacation_state.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';

class VacationBloc extends Bloc<VacationEvent, VacationState> {
  final SessionBloc sessionBloc;
  final GetVacation getVacation;
  final GetVacationPeriod getVacationPeriod;
  final GetLockedDays getLockedDays;
  String? pendingEmployeeId;

  StreamSubscription? _subscription;

  VacationParams? vacationParams;
  List<VacationLockedDays>? vacationLockedDays;

  VacationBloc(
      {required this.sessionBloc,
      required this.getVacation,
      required this.getVacationPeriod,
      required this.getLockedDays})
      : super(VacationLoadingState(null)) {
    on<VacationLoadEvent>(_mapLoad);
    _subscription = this.sessionBloc.stream.listen(_onSessionChanged);
  }

  Future<void> _mapLoad(
    VacationLoadEvent event,
    Emitter<VacationState> emit,
  ) async {
    final condominiumId = event.condominiumId;

    emit(VacationLoadingState(condominiumId));

    final vacationsTask = await getVacation.call(GetVacationParam(
        condominiumId: condominiumId, employeeId: event.employeeId));

    final periodsTask = await getVacationPeriod.call(GetVacationPeriodParam(
        condominiumId: condominiumId, employeeId: event.employeeId));

    final lockedDaysTask = await getLockedDays.call(GetLockedDaysParam(
        condominiumId: condominiumId,
        employeeId: event.employeeId,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(Duration(days: 1095))));

    var result = Try.foldAll<VacationState>(
        [vacationsTask, periodsTask, lockedDaysTask],
        (l) => VacationLoadFailedState(condominiumId, error: l), (data) {
      Vacation? v;
      VacationParams? p;
      VacationLockedDays? l;
      data.forEach((element) {
        if (element is Vacation) v = element;
        if (element is VacationParams) p = element;
        if (element is VacationLockedDays) l = element;
      });
      return VacationLoadedState(v, condominiumId, p, l!);
    });

    emit(result);
  }

  void _onSessionChanged(SessionState sessionState) {
    if (sessionState is SessionLoadedState) {
      final condominium = sessionState.session?.selectedCondominium;
      if (condominium != null && pendingEmployeeId != null) {
        add(VacationLoadEvent(
            condominiumId: condominium.id, employeeId: pendingEmployeeId!));
        pendingEmployeeId = null;
      }
    }
  }

  void beginLoad(String employeeId) {
    if (!(sessionBloc.state is SessionLoadedState)) {
      pendingEmployeeId = employeeId;
    } else {
      add(VacationLoadEvent(
          condominiumId: sessionBloc.state.session!.selectedCondominium!.id,
          employeeId: employeeId));
    }
  }

  void getVacationLockedDays(
      String employeeId, DateTime startDate, DateTime endDate) {
    if (!(sessionBloc.state is SessionLoadedState)) {
      pendingEmployeeId = employeeId;
    } else {
      add(GetLockedDaysEvent(
          employeeId: employeeId, startDate: startDate, endDate: endDate));
    }
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
