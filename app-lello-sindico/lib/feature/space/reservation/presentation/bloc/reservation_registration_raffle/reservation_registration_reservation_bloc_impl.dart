import 'dart:async';

import 'package:essentials/essentials.dart';
import 'package:lello/feature/resident/domain/entity/resident.dart';
import 'package:lello/feature/resident/domain/use_case/list_residents.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_raffle_data.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_registration.dart';
import 'package:lello/feature/space/reservation/domain/use_case/register_raffle/register_raffle.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_registration_raffle/reservation_registration_raffle_bloc.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_registration_raffle/reservation_registration_raffle_event.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_registration_raffle/reservation_registration_raffle_state.dart';
import 'package:lello/feature/unit/domain/entity/unit.dart';
import 'package:lello/feature/unit/domain/use_case/list_units/list_units_usecase.dart';

class ReservationRegistrationRaffleBlocImpl
    extends ReservationRegistrationRaffleBloc {
  final SessionBloc sessionBloc;
  final RegisterRaffle registerRaffle;
  final ListUnitsUsecase listUnits;
  final ListResidents listResidents;

  StreamSubscription? _subscription;
  ReservationRegistration? _pendingRegistration;

  ReservationRegistrationRaffleBlocImpl(
      {required this.sessionBloc,
      required this.registerRaffle,
      required this.listUnits,
      required this.listResidents})
      : super(ReservationRegistrationRaffleLoadingState(null, null)) {
    if (sessionBloc.state is SessionLoadedState) {
      _onSessionChanged(sessionBloc.state);
    } else {
      _subscription = this.sessionBloc.stream.listen(_onSessionChanged);
    }
  }

  @override
  Stream<ReservationRegistrationRaffleState> mapEventToState(
      ReservationRegistrationRaffleEvent event) async* {
    if (event is ReservationRegistrationRaffleSetupEvent)
      yield* _mapSetup(event);
    if (event is ReservationRegistrationRaffleRegisterEvent)
      yield* _mapRegister(event);
  }

  Stream<ReservationRegistrationRaffleState> _mapSetup(
      ReservationRegistrationRaffleSetupEvent event) async* {
    final condominiumId = event.condominiumId;
    final registration = event.registration;

    yield ReservationRegistrationRaffleLoadingState(
        registration, condominiumId);

    final results = await Future.wait([
      listUnits.call(ListUnitsParam(
          condominiumId: condominiumId,
          origin: DataOrigin.remote,
          loadAll: true)),
      listResidents.call(ListResidentsParam(
          condominiumId: condominiumId,
          origin: DataOrigin.remote,
          loadAll: true))
    ]);

    final unitsResult = results[0];
    final residentsResult = results[1];

    yield unitsResult.foldAlong(
        residentsResult,
        (err) => ReservationRegistrationRaffleLoadFailedState(
            registration, condominiumId, err),
        (units, residents) => ReservationRegistrationRaffleLoadedState(
            registration,
            condominiumId,
            residents as List<Resident>,
            units as List<Unit>));
  }

  Stream<ReservationRegistrationRaffleState> _mapRegister(
      ReservationRegistrationRaffleRegisterEvent event) async* {
    final condominiumId = state.condominiumId!;
    final registration = state.registration!;
    final rule = _getResidents()!;
    final units = _getUnits()!;

    yield ReservationRegistrationRaffleRegisteringState(
        registration, condominiumId, rule, units);

    final result = await registerRaffle.call(RegisterRaffleParam(
        condominiumId: condominiumId,
        registration: registration,
        data: event.data));
    yield result.fold(
        (err) => ReservationRegistrationRaffleRegisterFailedState(
            registration, condominiumId, rule, units, err),
        (res) => ReservationRegistrationRaffleRegisteredState(
            res, registration, rule, units, condominiumId));
  }

  List<Resident>? _getResidents() {
    if (state is ReservationRegistrationRaffleLoadedState) {
      return (state as ReservationRegistrationRaffleLoadedState).residents;
    }
    return null;
  }

  List<Unit>? _getUnits() {
    if (state is ReservationRegistrationRaffleLoadedState) {
      return (state as ReservationRegistrationRaffleLoadedState).units;
    }
    return null;
  }

  void _onSessionChanged(SessionState sessionState) {
    if (sessionState is SessionLoadedState && _pendingRegistration != null) {
      beginSetup(_pendingRegistration!);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  @override
  void beginRegister(ReservationRaffleData data) {
    add(ReservationRegistrationRaffleRegisterEvent(data: data));
  }

  @override
  void beginSetup(ReservationRegistration registration) {
    final sessionState = sessionBloc.state;
    if (sessionState is SessionLoadedState) {
      final condominium = sessionState.session?.selectedCondominium;
      if (condominium != null) {
        add(ReservationRegistrationRaffleSetupEvent(
            registration: registration, condominiumId: condominium.id));
      }
      _pendingRegistration = null;
    } else {
      _pendingRegistration = registration;
    }
  }
}
