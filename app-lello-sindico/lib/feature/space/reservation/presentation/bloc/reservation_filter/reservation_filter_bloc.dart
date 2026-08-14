import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:essentials/essentials.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';
import 'package:lello/feature/space/domain/entity/space.dart';
import 'package:lello/feature/space/domain/use_case/list_space/list_space.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_filter/reservation_filter_event.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_filter/reservation_filter_state.dart';
import 'package:lello/feature/unit/domain/entity/unit.dart';

import '../../../../../unit/domain/use_case/list_units/list_units_usecase.dart';

class ReservationFilterBloc
    extends Bloc<ReservationFilterEvent, ReservationFilterState> {
  final SessionBloc sessionBloc;
  final ListUnitsUsecase listUnits;
  final ListSpace listSpace;

  StreamSubscription? _subscription;

  ReservationFilterBloc(
      {required this.sessionBloc,
      required this.listUnits,
      required this.listSpace})
      : super(ReservationFilterLoadingState([], [], "")) {
    on<ReservationFilterLoadEvent>(_mapLoad);
    if (sessionBloc.state is SessionLoadedState) {
      _onSessionChanged(sessionBloc.state);
    } else {
      _subscription = this.sessionBloc.stream.listen(_onSessionChanged);
    }
  }

  Future<void> _mapLoad(
    ReservationFilterLoadEvent event,
    Emitter<ReservationFilterState> emit,
  ) async {
    final condominiumId = event.condominiumId;
    final spaces = state.spaces;
    final units = state.units;

    emit(ReservationFilterLoadingState(spaces, units, condominiumId));

    final unitsFuture = listUnits.call(ListUnitsParam(
        condominiumId: condominiumId,
        origin: DataOrigin.remote,
        loadAll: true));
    final spacesFuture = listSpace.call(ListSpaceParam(
        condominiumId: condominiumId, origin: DataOrigin.remote));

    final results =
        await Future.wait([unitsFuture, spacesFuture], eagerError: true);
    final unitsResult = results[0];
    final spacesResult = results[1];

    emit(unitsResult.foldAlong(
        spacesResult,
        (err) =>
            ReservationFilterLoadFailedState(spaces, units, condominiumId, err),
        (newUntis, newSpaces) => ReservationFilterLoadedState(
            newSpaces as List<Space>, newUntis as List<Unit>, condominiumId)));
  }

  void _onSessionChanged(SessionState sessionState) {
    if (sessionState is SessionLoadedState) {
      final condominium = sessionState.session?.selectedCondominium;
      if (condominium != null) {
        add(ReservationFilterLoadEvent(condominiumId: condominium.id));
      }
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
