import 'package:essentials/essentials.dart';
import 'package:shared_features/shared_features.dart';

import '../../domain/entity/sub_user.dart';

class SubUserEditBloc extends Bloc {
  SubUserEditBloc() : super(SubUserEditLoadingState()) {
    on<SubUserEditLoadingEvent>(handleSubUserEditLoadingEvent);
    on<SubUserEditConcludeEvent>(handleSubUserEditConcludeEvent);
    on<SubUserEditSuccessEvent>(handleSubUserEditSuccessEvent);
    on<SubUserEditErrorEvent>(handleSubUserEditErrorEvent);
    on<SubUserEditLoadedEvent>(handleSubUserEditLoadedEvent);
    on<SubUserEditSendInviteErrorEvent>(handleSubUserSendInviteErrorEvent);
    on<SubUserEditSendInviteSuccessEvent>(handleSubUserSendInviteSuccessEvent);
    on<SubUserEditSendTokenEvent>(handleSubUserSendTokenEvent);
    on<SubUserDeleteLoadingEvent>(
            (event, emit) => emit(SubUserDeleteLoadingState()));
    on<SubUserDeleteSuccessEvent>((event, emit) {
      emit(
        SubUserDeleteSuccessState(unitId: event.unitId),
      );
    });
    on<SubUserDeleteErrorEvent>((event, emit) {
      emit(
        SubUserDeleteErrorState(error: event.error),
      );
    });
  }

  void handleSubUserEditLoadingEvent(
      SubUserEditLoadingEvent event, Emitter emit) {
    emit(SubUserEditLoadingState());
  }

  void handleSubUserEditConcludeEvent(
      SubUserEditConcludeEvent event, Emitter emit) {
    emit(SubUserEditConcludeState(subUser: event.subUser));
  }

  void handleSubUserEditSuccessEvent(
      SubUserEditSuccessEvent event, Emitter emit) {
    emit(SubUserEditSuccessState(subUser: event.subUser));
  }

  void handleSubUserEditErrorEvent(SubUserEditErrorEvent event, Emitter emit) {
    emit(SubUserEditErrorState(error: event.error));
  }

  void handleSubUserEditLoadedEvent(
      SubUserEditLoadedEvent event, Emitter emit) {
    emit(SubUserEditLoadedState());
  }

  void handleSubUserSendInviteErrorEvent(
      SubUserEditSendInviteErrorEvent event, Emitter emit) {
    emit(SubUserEditSendInviteErrorState());
  }

  void handleSubUserSendInviteSuccessEvent(
      SubUserEditSendInviteSuccessEvent event, Emitter emit) {
    emit(SubUserEditSendInviteSuccessState());
  }

  void handleSubUserSendTokenEvent(
      SubUserEditSendTokenEvent event, Emitter emit) {
    emit(SubUserEditSendTokenState(codeRequest: event.codeRequest));
  }
}

// [EVENTS]

abstract class SubUserEditEvent {}

class SubUserEditLoadingEvent extends SubUserEditEvent {}

class SubUserEditLoadedEvent extends SubUserEditEvent {}

class SubUserEditConcludeEvent extends SubUserEditEvent {
  final SubUser subUser;
  SubUserEditConcludeEvent({required this.subUser});
}

class SubUserEditSuccessEvent extends SubUserEditEvent {
  final SubUser subUser;
  SubUserEditSuccessEvent({required this.subUser});
}

class SubUserEditErrorEvent extends SubUserEditEvent {
  final Failure? error;
  SubUserEditErrorEvent({
    this.error,
  });
}

class SubUserEditSendInviteSuccessEvent extends SubUserEditEvent {}

class SubUserEditSendInviteErrorEvent extends SubUserEditEvent {}

class SubUserEditSendTokenEvent extends SubUserEditEvent {
  CodeRequest codeRequest;
  SubUserEditSendTokenEvent({required this.codeRequest});
}

abstract class SubUserDeleteEvent {}

class SubUserDeleteLoadingEvent {}

class SubUserDeleteSuccessEvent {
  final String unitId;
  SubUserDeleteSuccessEvent({required this.unitId});
}

class SubUserDeleteErrorEvent {
  final Failure? error;
  SubUserDeleteErrorEvent({this.error});
}

// [STATES]

abstract class SubUserEditState {}

class SubUserEditLoadingState extends SubUserEditState {}

class SubUserEditLoadedState extends SubUserEditState {}

class SubUserEditSuccessState extends SubUserEditState {
  final SubUser subUser;
  SubUserEditSuccessState({required this.subUser});
}

class SubUserEditConcludeState extends SubUserEditState {
  final SubUser subUser;
  SubUserEditConcludeState({required this.subUser});
}

class SubUserEditErrorState extends SubUserEditState {
  final Failure? error;
  SubUserEditErrorState({
    this.error,
  });
}

abstract class SubUserDeleteState {}

class SubUserDeleteLoadingState extends SubUserDeleteState {}

class SubUserDeleteSuccessState extends SubUserDeleteState {
  final String unitId;
  SubUserDeleteSuccessState({required this.unitId});
}

class SubUserDeleteErrorState extends SubUserDeleteState {
  final Failure? error;
  SubUserDeleteErrorState({this.error});
}

class SubUserEditSendInviteSuccessState extends SubUserEditState {}

class SubUserEditSendInviteErrorState extends SubUserEditState {}

class SubUserEditSendTokenState extends SubUserEditState {
  CodeRequest codeRequest;
  SubUserEditSendTokenState({required this.codeRequest});
}
