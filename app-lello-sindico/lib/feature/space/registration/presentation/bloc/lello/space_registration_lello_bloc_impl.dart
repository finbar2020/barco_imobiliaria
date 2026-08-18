import 'dart:async';

import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';
import 'package:lello/feature/space/registration/domain/entity/space_registration_request.dart';
import 'package:lello/feature/space/registration/domain/use_case/request_space_registration/request_space_registration.dart';
import 'package:lello/feature/space/registration/presentation/bloc/lello/space_registration_lello_bloc.dart';
import 'package:lello/feature/space/registration/presentation/bloc/lello/space_registration_lello_event.dart';
import 'package:lello/feature/space/registration/presentation/bloc/lello/space_registration_lello_state.dart';

class SpaceRegistrationLelloBlocImpl extends SpaceRegistrationLelloBloc {
  final SessionBloc sessionBloc;
  final RequestSpaceRegistration requestSpaceRegistration;

  StreamSubscription? _subscription;
  SpaceRegistrationRequest? _pendingSpace;

  SpaceRegistrationLelloBlocImpl(
      {required this.sessionBloc, required this.requestSpaceRegistration})
      : super(SpaceRegistrationLelloIdleState(SpaceRegistrationRequest())) {
    if (sessionBloc.state is SessionLoadedState) {
      _onSessionChanged(sessionBloc.state);
    } else {
      _subscription = this.sessionBloc.stream.listen(_onSessionChanged);
    }
  }

  @override
  Stream<SpaceRegistrationLelloState> mapEventToState(
      SpaceRegistrationLelloEvent event) async* {
    if (event is SpaceRegistrationLelloSendEvent) yield* _mapSend(event);
  }

  Stream<SpaceRegistrationLelloState> _mapSend(
      SpaceRegistrationLelloSendEvent event) async* {
    final condominiumId = event.condominiumId;
    final data = event.request;

    yield SpaceRegistrationLelloRegisteringState(data, condominiumId);

    final result = await requestSpaceRegistration.call(
        RequestSpaceRegistrationParam(
            condominiumId: condominiumId, data: data));
    yield result.fold(
        (err) =>
            SpaceRegistrationLelloRegisterFailedState(data, condominiumId, err),
        (res) => SpaceRegistrationLelloRegisteredState(res, condominiumId));
  }

  void _onSessionChanged(SessionState sessionState) {
    if (sessionState is SessionLoadedState && _pendingSpace != null) {
      beginRegister(_pendingSpace!);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  @override
  void beginRegister(SpaceRegistrationRequest space) {
    final sessionState = sessionBloc.state;
    if (sessionState is SessionLoadedState) {
      final condominium = sessionState.session?.selectedCondominium;
      if (condominium != null) {
        add(SpaceRegistrationLelloSendEvent(
            condominiumId: condominium.id, request: space));
      }
      _pendingSpace = null;
    } else {
      _pendingSpace = space;
    }
  }
}
