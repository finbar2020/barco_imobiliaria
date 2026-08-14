import 'dart:async';

import 'package:essentials/essentials.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_change_calendar/reservation_change_calendar_event.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_change_calendar/reservation_change_calendar_state.dart';
import 'package:lello/feature/unit/domain/use_case/list_units/list_units_usecase.dart';

class ReservationChangeCalendarBloc extends Bloc<
    ReservationChangeCalendarEvent, ReservationChangeCalendarState> {
  final SessionBloc sessionBloc;
  final ListUnitsUsecase listUnits;

  StreamSubscription? _subscription;

  ReservationChangeCalendarBloc({
    required this.sessionBloc,
    required this.listUnits,
  }) : super(ReservationChangeCalendarEmptyState()) {
    on<GetListUnitsEvent>(_mapGetListUnits);
    if (sessionBloc.state is SessionLoadedState) {
      _onSessionChanged(sessionBloc.state);
    } else {
      _subscription = sessionBloc.stream.listen(_onSessionChanged);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  Future<void> _mapGetListUnits(
    GetListUnitsEvent event,
    Emitter<ReservationChangeCalendarState> emit,
  ) async {
    emit(ListUnitsLoadingState());

    final units = await listUnits.call(ListUnitsParam(
        loadAll: true,
        condominiumId: sessionBloc.state.session!.selectedCondominium!.id,
        origin: DataOrigin.remote));

    var resultYield = units.fold((err) => ListUnitsFailedState(), (units) {
      return ListUnitsLoadedState(unitsList: units);
    });

    emit(resultYield);
  }

  void _onSessionChanged(SessionState sessionState) {
    if (sessionState is SessionLoadedState) {
      add(GetListUnitsEvent());
    }
  }
}
