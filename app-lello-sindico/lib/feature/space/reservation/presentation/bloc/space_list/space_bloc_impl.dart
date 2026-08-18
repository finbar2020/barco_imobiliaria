import 'dart:async';

import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:essentials/essentials.dart';
import 'package:lello/core/analytics/analytics_log_events.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';
import 'package:lello/feature/space/domain/entity/space.dart';
import 'package:lello/feature/space/domain/use_case/list_space/list_space.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/space_list/space_bloc.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/space_list/space_event.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/space_list/space_state.dart';
import 'package:lello/feature/unit/domain/use_case/list_units/list_units_usecase.dart';

class SpaceBlocImpl extends SpaceBloc {
  final SessionBloc sessionBloc;
  final ListSpace listSpace;
  final ListUnitsUsecase listUnits;
  var loadedCache = false;

  StreamSubscription? _subscription;

  SpaceBlocImpl(
      {required this.sessionBloc,
      required this.listSpace,
      required this.listUnits})
      : super(SpaceLoadingState([], "", [])) {
    if (sessionBloc.state is SessionLoadedState) {
      _onSessionChanged(sessionBloc.state);
    } else {
      _subscription = this.sessionBloc.stream.listen(_onSessionChanged);
    }
  }

  @override
  Stream<SpaceState> mapEventToState(SpaceEvent event) async* {
    if (event is SpaceLoadEvent) yield* _mapLoad(event);
  }

  Stream<SpaceState> _mapLoad(SpaceLoadEvent event) async* {
    final condominiumId = event.condominiumId;
    var data = state.data;

    yield SpaceLoadingState(data, condominiumId, state.unitsList);

    final spaces = await listSpace.call(ListSpaceParam(
        condominiumId: condominiumId, origin: DataOrigin.remote));

    final units = await listUnits.call(ListUnitsParam(
        loadAll: true,
        condominiumId: condominiumId,
        origin: DataOrigin.remote));

    List<Space> spaceList = [];

    spaces.fold(
        (err) =>
            SpaceLoadFailedState(data, condominiumId, state.unitsList, err),
        (data) {
      spaceList = data;
      spaceList.forEach((element) {
        element.name = wordAdjust(element.name!);
      });
    });

    var resultYield = units.fold(
        (err) =>
            SpaceLoadFailedState(data, condominiumId, state.unitsList, err),
        (units) {
      String reference = sessionBloc
              .state.session!.selectedCondominium?.reference
              .toString() ??
          "";
      ManagerAnalyticsLogEvents.logEvent(
          event: AnalyticsEventsManager.condAreasReservarAcessar(),
          referenceValue: reference);
      return SpaceLoadedState(spaceList, condominiumId, units);
    });

    yield resultYield;
  }

  void _onSessionChanged(SessionState sessionState) {
    if (sessionState is SessionLoadedState) {
      final condominium = sessionState.session?.selectedCondominium;
      if (condominium != null) {
        add(SpaceLoadEvent(condominiumId: condominium.id));
      }
    }
  }

  @override
  void beginRefresh() {
    if (!(state is SpaceLoadingState)) {
      add(SpaceLoadEvent(condominiumId: state.condominiumId));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  String wordAdjust(String word) {
    if (word == 'Mudanca') {
      return "Mudança";
    }
    String text = word.toLowerCase();
    return "${text[0].toUpperCase()}${text.substring(1).toLowerCase()}";
  }
}
