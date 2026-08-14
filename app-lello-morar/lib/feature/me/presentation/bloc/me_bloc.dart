import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morar/feature/me/domain/entity/me.dart';
import 'package:morar/feature/me/presentation/bloc/me_event.dart';
import 'package:morar/feature/me/presentation/bloc/me_state.dart';

class MeBloc extends Bloc<MeEvent, MeState> {
  Me? originalMe;

  MeBloc() : super(MeState(Me.empty())) {
    on<MeLoadingEvent>(handleMeLoadingEvent);
    on<MeLoadedCacheEvent>(handleMeLoadedCacheEvent);
    on<MeLoadedEvent>(handleMeLoadedEvent);
    on<MeLoadFailedEvent>(handleMeLoadFailedEvent);
    on<MeEditLoadingEvent>(handleMeEditLoadingEvent);
    on<MeEditLoadedEvent>(handleMeEditLoadedEvent);
    on<MeEditPasswordEvent>(handleMeEditPasswordEvent);
    on<MeEditPasswordLoadingEvent>(handleMeEditPasswordLoadingEvent);
    on<MeEditPasswordFailedEvent>(handleMeEditPasswordFailedEvent);
    on<MeEditSucceededEvent>(handleMeEditSuccededEvent);
    on<MeEditFailedEvent>(handleMeEditFailedEvent);
    on<MeEditPhoneChangedEvent>(handleMePhoneChangedEvent);
    on<MeEditEmailChangedEvent>(handleMeEditEmailChangedEvent);
    on<MeEditRequestingCodeEvent>(handleMeRequestinCodeEvent);
    on<MeEditRequestingCodeFailedEvent>(handleMeRequestinCodeFailedEvent);
    on<MeEditNoContactAvailableEvent>(handleMeNoContactAvailableEvent);
    on<MeEditValidateCodeSuccessEvent>(handleMeRequestinCodeSuccessEvent);
    on<MeUploadProfileFailedEvent>(handleMeUploadPictureFailedEvent);
    on<MeUploadProfileSucceededEvent>(handleMeUploadPictureSuccessEvent);
    on<MeUnauthenticatedEvent>(handleMeUnauthenticatedEvent);
    on<MeDeleteSuccessEvent>(handleMeDeleteSucessEvent);
    on<MeDeleteFailedEvent>(handleMeDeleteFailedEvent);
  }

  void handleMeLoadingEvent(MeLoadingEvent event, Emitter emit) {
    emit(MeLoadingState(event.me));
  }

  void handleMeLoadedCacheEvent(MeLoadedCacheEvent event, Emitter emit) {
    emit(MeLoadedCacheState(event.me));
  }

  void handleMeLoadedEvent(MeLoadedEvent event, Emitter emit) {
    emit(MeLoadedState(event.me));
  }

  void handleMeLoadFailedEvent(MeLoadFailedEvent event, Emitter emit) {
    emit(MeLoadFailedState(event.me, event.failure));
  }

  void handleMeEditLoadingEvent(MeEditLoadingEvent event, Emitter emit) {
    emit(MeEditLoadingState(event.me));
  }

  void handleMeEditLoadedEvent(MeEditLoadedEvent event, Emitter emit) {
    emit(MeEditState(event.me));
  }

  void handleMeEditPasswordEvent(MeEditPasswordEvent event, Emitter emit) {
    emit(MeEditPasswordState(event.me, event.originPassword, event.password));
  }

  void handleMeEditPasswordLoadingEvent(
      MeEditPasswordLoadingEvent event, Emitter emit) {
    emit(MeEditPasswordLoadingState(
        event.me, event.originPassword, event.password));
  }

  void handleMeEditPasswordFailedEvent(
      MeEditPasswordFailedEvent event, Emitter emit) {
    emit(MeEditPasswordFailedState(
        event.me, event.originPassword, event.password, event.err));
  }

  void handleMeEditSuccededEvent(MeEditSucceededEvent event, Emitter emit) {
    emit(MeEditSucceededState(event.me));
  }

  void handleMeEditFailedEvent(MeEditFailedEvent event, Emitter emit) {
    emit(MeEditFailedState(event.me, event.err,
        codeValidation: event.codeValidation, codeRequest: event.codeRequest));
  }

  void handleMePhoneChangedEvent(MeEditPhoneChangedEvent event, Emitter emit) {
    emit(MeEditPhoneChangedState(event.me));
  }

  void handleMeEditEmailChangedEvent(
      MeEditEmailChangedEvent event, Emitter emit) {
    emit(MeEditEmailChangedState(event.me));
  }

  void handleMeRequestinCodeEvent(
      MeEditRequestingCodeEvent event, Emitter emit) {
    emit(MeEditRequestingCodeState(event.me));
  }

  void handleMeRequestinCodeFailedEvent(
      MeEditRequestingCodeFailedEvent event, Emitter emit) {
    emit(MeEditRequestCodeFailedState(event.me, event.err));
  }

  void handleMeNoContactAvailableEvent(
      MeEditNoContactAvailableEvent event, Emitter emit) {
    emit(MeEditNoContactAvailableState(event.me));
  }

  void handleMeRequestinCodeSuccessEvent(
      MeEditValidateCodeSuccessEvent event, Emitter emit) {
    emit(MeEditValidateCodeState(event.me, event.codeRequest));
  }

  void handleMeUploadPictureFailedEvent(
      MeUploadProfileFailedEvent event, Emitter emit) {
    emit(MeUploadProfileFailedState(event.me, event.err));
  }

  void handleMeUploadPictureSuccessEvent(
      MeUploadProfileSucceededEvent event, Emitter emit) {
    emit(MeUploadProfileSucceededState(event.me));
  }

  void handleMeUnauthenticatedEvent(
      MeUnauthenticatedEvent event, Emitter emit) {
    emit(MeUnauthenticatedState(event.me));
  }

  void handleMeDeleteSucessEvent(MeDeleteSuccessEvent event, Emitter emit) {
    emit(MeDeleteAccountSuccessState(event.me));
  }

  void handleMeDeleteFailedEvent(MeDeleteFailedEvent event, Emitter emit) {
    emit(MeDeleteAccountFailedState(event.me));
  }
}
