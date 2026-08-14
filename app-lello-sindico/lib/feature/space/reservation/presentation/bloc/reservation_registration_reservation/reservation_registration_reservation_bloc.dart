import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:essentials/essentials.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_registration.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_registration_data.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_rule.dart';
import 'package:lello/feature/space/reservation/domain/use_case/get_reservation_rule/get_reservation_rule.dart';
import 'package:lello/feature/space/reservation/domain/use_case/register_reservation/register_reservation.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_registration_reservation/reservation_registration_reservation_event.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_registration_reservation/reservation_registration_reservation_state.dart';
import 'package:lello/feature/unit/domain/entity/unit.dart';
import 'package:lello/feature/unit/domain/use_case/list_units/list_units_usecase.dart';

class ReservationRegistrationReservationBloc extends Bloc<
    ReservationRegistrationReservationEvent,
    ReservationRegistrationReservationState> {
  final SessionBloc sessionBloc;
  final RegisterReservation registerReservation;
  final GetReservationRule getReservationRule;
  final ListUnitsUsecase listUnits;

  StreamSubscription? _subscription;
  ReservationRegistration? _pendingRegistration;

  ReservationRegistrationReservationBloc(
      {required this.sessionBloc,
      required this.registerReservation,
      required this.getReservationRule,
      required this.listUnits})
      : super(ReservationRegistrationReservationLoadingState(null, null)) {
    on<ReservationRegistrationReservationSetupEvent>(_mapSetup);
    on<ReservationRegistrationReservationRegisterEvent>(_mapRegister);
    if (sessionBloc.state is SessionLoadedState) {
      _onSessionChanged(sessionBloc.state);
    } else {
      _subscription = this.sessionBloc.stream.listen(_onSessionChanged);
    }
  }

  Future<void> _mapSetup(
    ReservationRegistrationReservationSetupEvent event,
    Emitter<ReservationRegistrationReservationState> emit,
  ) async {
    final condominiumId = event.condominiumId;
    final registration = event.registration;

    emit(ReservationRegistrationReservationLoadingState(
        registration, condominiumId));

    final results = await Future.wait([
      getReservationRule.call(GetReservationRuleParam(
          condominiumId: condominiumId, spaceId: registration.space!.id!)),
      listUnits.call(ListUnitsParam(
          condominiumId: condominiumId,
          origin: DataOrigin.remote,
          loadAll: true))
    ]);

    final ruleResult = results[0];
    final unitsResult = results[1];

    emit(ruleResult.foldAlong(
        unitsResult,
        (err) => ReservationRegistrationReservationLoadFailedState(
            registration, condominiumId, err),
        (rule, units) => ReservationRegistrationReservationLoadedState(
            registration,
            condominiumId,
            rule as ReservationRule,
            units as List<Unit>)));
  }

  Future<void> _mapRegister(
    ReservationRegistrationReservationRegisterEvent event,
    Emitter<ReservationRegistrationReservationState> emit,
  ) async {
    final condominiumId = state.condominiumId!;
    final registration = state.registration!;
    final rule = _getRule()!;
    final units = _getUnits()!;

    emit(ReservationRegistrationReservationRegisteringState(
        registration, condominiumId, rule, units));

    //final result = await registerReservation.call(RegisterReservationParam(condominiumId: condominiumId, registration: registration, data: event.data));

    // yield result.fold((err) => ReservationRegistrationReservationRegisterFailedState(registration, condominiumId, rule, units, err),
    // 		(res) => ReservationRegistrationReservationRegisteredState(res, registration, rule, units, condominiumId));
  }

  ReservationRule? _getRule() {
    if (state is ReservationRegistrationReservationLoadedState) {
      return (state as ReservationRegistrationReservationLoadedState).rule;
    }
    return null;
  }

  List<Unit>? _getUnits() {
    if (state is ReservationRegistrationReservationLoadedState) {
      return (state as ReservationRegistrationReservationLoadedState).units;
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

  void beginRegister(ReservationRegistrationData data) {
    add(ReservationRegistrationReservationRegisterEvent(data: data));
  }

  void beginSetup(ReservationRegistration registration) {
    final sessionState = sessionBloc.state;
    if (sessionState is SessionLoadedState) {
      final condominium = sessionState.session?.selectedCondominium;
      if (condominium != null) {
        add(ReservationRegistrationReservationSetupEvent(
            registration: registration, condominiumId: condominium.id));
      }
      _pendingRegistration = null;
    } else {
      _pendingRegistration = registration;
    }
  }
}
