import 'package:essentials/essentials.dart';
import 'package:morar/feature/sub_user/domain/entity/pending_request.dart';
import 'package:morar/feature/sub_user/presentation/bloc/sub_user_edit_bloc.dart';

import '../../domain/entity/sub_user.dart';

class SubUsersBloc extends Bloc {
  SubUsersBloc() : super(SubUserEmptyState()) {
    on<SubUserLoadingEvent>(handleSubUserLoadingEvent);
    on<SubUserErrorEvent>(handleSubUserErrorEvent);
    on<SubUserLoadedEvent>(handleSubUserLoadedEvent);

    on<SubUserInviteResidentFailureEvent>(
        handleSubUserInviteResidentFailureEvent);
    on<SubUserInviteResidentLoadingEvent>(
        handleSubUserInviteResidentLoadingEvent);
    on<SubUserInviteResidentSuccessEvent>(
        handleSubUserInviteResidentSuccessEvent);
    on<SubUserInviteLoadedEvent>(handleSubUserInviteLoadedEvent);
    on<SubUserServiceOnEvent>(handleSubUserServiceOnEvent);
    on<SubUserServiceOffEvent>(handleSubUserServiceOffEvent);
    on<SubUserFacialLoadingEvent>(handleSubUserFacialLoadingEvent);
    on<SubUserFacialLoadedEvent>(handleSubUserFacialLoadedEvent);
    on<SubUserFacialErrorEvent>(handleSubUserFacialErrorEvent);
    on<SubUserSendInviteErrorEvent>(handleSubUserSendInviteErrorEvent);
    on<SubUserSendInviteLoadedEvent>(handleSubUserSendInviteLoadedEvent);
    on<UpdateStatusRequestLoadingEvent>((event, emit) {
      emit(UpdateStatusRequestLoadingState());
    });
    on<UpdateAccessStatusRequestSuccessState>(
      (event, emit) => emit(
        UpdateAccessStatusRequestSuccessState(status: event.status),
      ),
    );
    on<UpdateAccessStatusRequestErrorState>(
      (event, emit) => emit(
        UpdateAccessStatusRequestErrorState(error: event.error),
      ),
    );
  }

  void handleSubUserLoadingEvent(SubUserLoadingEvent event, Emitter emit) {
    emit(SubUserLoadingState());
  }

  void handleSubUserErrorEvent(SubUserErrorEvent event, Emitter emit) {
    emit(SubUserErrorState(error: event.error));
  }

  void handleSubUserLoadedEvent(SubUserLoadedEvent event, Emitter emit) {
    emit(
      SubUserLoadedState(
        subUsers: event.subUsers,
        pendingRequests: event.pendingRequests,
      ),
    );
  }

  void handleSubUserInviteResidentFailureEvent(
      SubUserInviteResidentFailureEvent event, Emitter emit) {
    emit(InsertSubUserErrorState(
        failure: event.failure, subUser: event.subUser));
  }

  void handleSubUserInviteResidentLoadingEvent(
      SubUserInviteResidentLoadingEvent event, Emitter emit) {
    emit(SubUserInviteLoadingState());
  }

  void handleSubUserInviteResidentSuccessEvent(
      SubUserInviteResidentSuccessEvent event, Emitter emit) {
    emit(SubUserInviteSuccessState());
  }

  void handleSubUserInviteLoadedEvent(
      SubUserInviteLoadedEvent event, Emitter emit) {
    emit(SubUserInviteLoadedState(subUser: event.subUser));
  }

  void handleSubUserServiceOnEvent(SubUserServiceOnEvent event, Emitter emit) {
    emit(CheckServiceOnlineState());
  }

  void handleSubUserServiceOffEvent(
      SubUserServiceOffEvent event, Emitter emit) {
    emit(CheckServiceOfflineState());
  }

  void handleSubUserFacialLoadingEvent(
      SubUserFacialLoadingEvent event, Emitter emit) {
    emit(FacialBiometricLoadingState());
  }

  void handleSubUserFacialLoadedEvent(
      SubUserFacialLoadedEvent event, Emitter emit) {
    emit(FacialBiometricLoadedState());
  }

  void handleSubUserFacialErrorEvent(
      SubUserFacialErrorEvent event, Emitter emit) {
    emit(FacialBiometricErrorState(code: event.code, message: event.message));
  }

  void handleSubUserSendInviteErrorEvent(
      SubUserSendInviteErrorEvent event, Emitter emit) {
    emit(SendInviteFailedState());
  }

  void handleSubUserSendInviteLoadedEvent(
      SubUserSendInviteLoadedEvent event, Emitter emit) {
    emit(SendInviteSuccessState());
  }
}

// [EVENTS]

abstract class SubUserEvent {}

class SubUserLoadingEvent extends SubUserEvent {}

class UpdateStatusRequestLoadingEvent extends SubUserEvent {}

class SubUserErrorEvent extends SubUserEvent {
  final Failure? error;

  SubUserErrorEvent({required this.error});
}

class SubUserLoadedEvent extends SubUserEvent {
  final List<SubUser> subUsers;
  final List<PendingRequestEntity> pendingRequests;

  SubUserLoadedEvent({
    required this.subUsers,
    required this.pendingRequests,
  });
}

class SubUserInviteResidentFailureEvent extends SubUserEvent {
  final SubUser subUser;
  final Failure failure;

  SubUserInviteResidentFailureEvent(
      {required this.subUser, required this.failure});
}

class SubUserInviteResidentLoadingEvent extends SubUserEvent {}

class SubUserInviteResidentSuccessEvent extends SubUserEvent {}

class SubUserInviteLoadedEvent extends SubUserEvent {
  final SubUser subUser;

  SubUserInviteLoadedEvent({required this.subUser});
}

class SubUserServiceOnEvent extends SubUserEvent {}

class SubUserServiceOffEvent extends SubUserEvent {}

class SubUserFacialLoadingEvent extends SubUserEvent {}

class SubUserFacialLoadedEvent extends SubUserEvent {}

class SubUserFacialErrorEvent extends SubUserEvent {
  final String? code;
  final String? message;

  SubUserFacialErrorEvent({this.code, this.message});
}

class SubUserSendInviteLoadedEvent extends SubUserEvent {}

class SubUserSendInviteErrorEvent extends SubUserEvent {}

class UpdateSubUserAccessStatusRequestSuccessEvent extends SubUserEvent {}

class UpdateSubUserAccessStatusRequestErrorEvent extends SubUserEvent {
  final Failure? error;

  UpdateSubUserAccessStatusRequestErrorEvent({required this.error});
}

// [STATES]

abstract class SubUserState {
  List<SubUser>? list;
  SubUser? subUser;
}

class SubUserEmptyState extends SubUserState {}

class SubUserLoadingState extends SubUserState {}

class SubUserLoadedState extends SubUserState {
  final bool sucess;
  final List<SubUser> subUsers;
  final List<PendingRequestEntity> pendingRequests;

  SubUserLoadedState({
    required this.subUsers,
    required this.pendingRequests,
    this.sucess = false,
  }) : super();
}

class SubUserInviteLoadingState extends SubUserState {}

class SubUserInviteSuccessState extends SubUserState {}

class SubUserInviteLoadedState extends SubUserState {
  final SubUser subUser;

  SubUserInviteLoadedState({required this.subUser}) : super();
}

class SendInviteSubUserState extends SubUserState {
  final SubUser subUser;

  SendInviteSubUserState({required this.subUser}) : super();
}

class SubUserErrorState extends SubUserState {
  final Failure? error;

  SubUserErrorState({required this.error}) : super();
}

class InsertSubUserErrorState extends SubUserState {
  final Failure failure;
  final SubUser subUser;

  InsertSubUserErrorState({required this.failure, required this.subUser})
      : super();
}

class SendInviteSubUserErrorState extends SubUserState {
  final String error;

  SendInviteSubUserErrorState({required this.error}) : super();
}

class CheckServiceOnlineState extends SubUserState {
  CheckServiceOnlineState() : super();
}

class CheckServiceOfflineState extends SubUserState {
  CheckServiceOfflineState() : super();
}

class FacialBiometricLoadingState extends SubUserState {
  FacialBiometricLoadingState() : super();
}

class FacialBiometricLoadedState extends SubUserState {
  FacialBiometricLoadedState() : super();
}

class FacialBiometricErrorState extends SubUserState {
  String? message;
  String? code;

  FacialBiometricErrorState({
    this.message,
    this.code,
  }) : super();
}

class SendInviteFailedState extends SubUserState {}

class SendInviteSuccessState extends SubUserState {}

class UpdateAccessStatusRequestSuccessState extends SubUserState {
  final String status;

  UpdateAccessStatusRequestSuccessState({required this.status}) : super();
}

class UpdateAccessStatusRequestErrorState extends SubUserState {
  final Failure? error;

  UpdateAccessStatusRequestErrorState({required this.error}) : super();
}

class UpdateStatusRequestLoadingState extends SubUserState {
  UpdateStatusRequestLoadingState() : super();
}
