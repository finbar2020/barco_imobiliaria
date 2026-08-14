import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/me/presentation/bloc/me_event.dart';
import 'package:lello/feature/me/presentation/bloc/me_state.dart';

class MeBloc extends Bloc<MeEvent, MeState> {
  MeBloc() : super(MeLoadingState()) {
    on<MeLoadingEvent>(handleMeLoadingEvent);
    on<MeLoadedEvent>(handleMeLoadedEvent);
    on<MeLoadedCacheEvent>(handleMeLoadedCacheEvent);
    on<MeLoadFailedEvent>(handleMeLoadFailedEvent);
    on<LogMeOutEvent>(handleLogMeOutEvent);

    //Delete
    on<MeDeleteLoadingEvent>(handleMeDeleteLoadingEvent);
    on<MeDeleteAccountFailedEvent>(handleMeDeleteAccountFailedEvent);
    on<MeDeleteAccountSuccessEvent>(handleMeDeleteAccountSuccessEvent);

    //Edit
    on<MeEditEvent>(handleMeEditEvent);
    on<MeBeginEditEvent>(handleMeBeginEditEvent);
    on<MeEditPasswordEvent>(handleMeEditPasswordEvent);
    on<MeEditPasswordLoadingEvent>(handleMeEditPasswordLoadingEvent);
    on<MeEditPasswordFailedEvent>(handleMeEditPasswordFailedEvent);
    on<MeEditPasswordSucceededEvent>(handleMeEditPasswordSucceededEvent);
    on<MeEditPhoneChangedEvent>(handleMeEditPhoneChangedEvent);
    on<MeEditLoadingEvent>(handleMeEditLoadingEvent);
    on<MeEditSucceededEvent>(handleMeEditSucceededEvent);
    on<MeEditFailedEvent>(handleMeEditFailedEvent);
    on<MeUploadProfileLoadingEvent>(handleMeUploadProfileLoadingEvent);
    on<MeUploadProfileSucceededEvent>(handleMeUploadProfileSucceededEvent);
    on<MeUploadProfileFailedEvent>(handleMeUploadProfileFailedEvent);
    on<MeEditRequestingCodeEvent>(handleMeEditRequestingCodeEvent);
    on<MeEditRequestCodeFailedEvent>(handleMeEditRequestCodeFailedEvent);
    on<MeEditNoContactAvailableEvent>(handleMeEditNoContactAvailableEvent);
    on<MeEditValidateCodeEvent>(handleMeEditValidateCodeEvent);
  }

  void handleMeLoadingEvent(MeLoadingEvent event, Emitter emit) {
    emit(
      MeLoadingState(),
    );
  }

  void handleMeLoadedEvent(MeLoadedEvent event, Emitter emit) {
    emit(
      MeLoadedState(me: event.me),
    );
  }

  void handleMeLoadedCacheEvent(MeLoadedCacheEvent event, Emitter emit) {
    emit(
      MeLoadedCacheState(me: event.me),
    );
  }

  void handleMeLoadFailedEvent(MeLoadFailedEvent event, Emitter emit) {
    emit(
      MeLoadFailedState(failure: event.failure),
    );
  }

  void handleLogMeOutEvent(LogMeOutEvent event, Emitter emit) {
    emit(
      MeUnauthenticatedState(),
    );
  }

  //Delete
  void handleMeDeleteLoadingEvent(MeDeleteLoadingEvent event, Emitter emit) {
    emit(
      MeDeleteLoadingState(),
    );
  }

  void handleMeDeleteAccountFailedEvent(
      MeDeleteAccountFailedEvent event, Emitter emit) {
    emit(
      MeDeleteAccountFailedState(failure: event.failure),
    );
  }

  void handleMeDeleteAccountSuccessEvent(
      MeDeleteAccountSuccessEvent event, Emitter emit) {
    emit(
      MeDeleteAccountSuccessState(),
    );
  }

  //Edit
  void handleMeEditEvent(MeEditEvent event, Emitter emit) {
    emit(
      MeEditState(me: event.me),
    );
  }

  void handleMeBeginEditEvent(MeBeginEditEvent event, Emitter emit) {
    emit(
      MeBeginEditState(),
    );
  }

  void handleMeEditPasswordEvent(MeEditPasswordEvent event, Emitter emit) {
    emit(
      MeEditPasswordState(),
    );
  }

  void handleMeEditPasswordLoadingEvent(
      MeEditPasswordLoadingEvent event, Emitter emit) {
    emit(
      MeEditPasswordLoadingState(),
    );
  }

  void handleMeEditPasswordFailedEvent(
      MeEditPasswordFailedEvent event, Emitter emit) {
    emit(
      MeEditPasswordFailedState(failure: event.failure),
    );
  }

  void handleMeEditPasswordSucceededEvent(
      MeEditPasswordSucceededEvent event, Emitter emit) {
    emit(
      MeEditPasswordSucceededState(),
    );
  }

  void handleMeEditPhoneChangedEvent(
      MeEditPhoneChangedEvent event, Emitter emit) {
    emit(
      MeEditPhoneChangedState(
        isChangingEmail: event.isChangingEmail,
        isChangingPhone: event.isChangingPhone,
      ),
    );
  }

  void handleMeEditLoadingEvent(MeEditLoadingEvent event, Emitter emit) {
    emit(
      MeEditLoadingState(),
    );
  }

  void handleMeEditSucceededEvent(MeEditSucceededEvent event, Emitter emit) {
    emit(
      MeEditSucceededState(),
    );
  }

  void handleMeEditFailedEvent(MeEditFailedEvent event, Emitter emit) {
    emit(
      MeEditFailedState(failure: event.failure),
    );
  }

  void handleMeUploadProfileLoadingEvent(
      MeUploadProfileLoadingEvent event, Emitter emit) {
    emit(
      MeUploadProfileLoadingState(),
    );
  }

  void handleMeUploadProfileSucceededEvent(
      MeUploadProfileSucceededEvent event, Emitter emit) {
    emit(
      MeUploadProfileSucceededState(),
    );
  }

  void handleMeUploadProfileFailedEvent(
      MeUploadProfileFailedEvent event, Emitter emit) {
    emit(
      MeUploadProfileFailedState(failure: event.failure),
    );
  }

  void handleMeEditRequestingCodeEvent(
      MeEditRequestingCodeEvent event, Emitter emit) {
    emit(
      MeEditRequestingCodeState(),
    );
  }

  void handleMeEditRequestCodeFailedEvent(
      MeEditRequestCodeFailedEvent event, Emitter emit) {
    emit(
      MeEditRequestCodeFailedState(failure: event.failure),
    );
  }

  void handleMeEditNoContactAvailableEvent(
      MeEditNoContactAvailableEvent event, Emitter emit) {
    emit(
      MeEditNoContactAvailableState(),
    );
  }

  void handleMeEditValidateCodeEvent(
      MeEditValidateCodeEvent event, Emitter emit) {
    emit(
      MeEditValidateCodeState(),
    );
  }
}
