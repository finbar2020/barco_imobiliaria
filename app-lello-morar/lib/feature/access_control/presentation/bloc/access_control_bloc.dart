import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morar/feature/access_control/presentation/bloc/access_control_event.dart';
import 'package:morar/feature/access_control/presentation/bloc/access_control_state.dart';

class AccessControlBloc extends Bloc {
  AccessControlBloc() : super(const AccessControlLoadingState()) {
    on<AccessControlLoadingEvent>(handleAccessControlLoadingEvent);
    on<AccessControlFailureEvent>(handleAccessControlFailureEvent);
    on<AccessControlOnBoardingEvent>(handleAccessControlOnboardingEvent);
    on<AccessControlLoadedEvent>(handleAccessControlLoadedEvent);
    on<SaveVisitantFailureEvent>(handleSaveVisitantFailureEvent);
    on<SaveVisitantLoadedEvent>(handleSaveVisitantLoadedeEvent);
    on<EditVisitantEvent>(handleEditVisitantEvent);
    on<DeleteVisitantEvent>(handleDeleteVisitantEvent);
    on<DeleteFailureVisitEvent>(handleDeleteFailureVisitEvent);
    on<DeleteVisitEvent>(handleDeleteVisitEvent);
    on<SearchingVisitantEvent>(handleSearchingVisitantEvent);
    on<SearchingProviderEvent>(handleSearchingProviderEvent);
  }

  void handleSearchingVisitantEvent(
      SearchingVisitantEvent event, Emitter emit) {
    emit(
      SearchingVisitantState(
          visitants: event.visitants, providers: event.providers),
    );
  }

  void handleSearchingProviderEvent(
      SearchingProviderEvent event, Emitter emit) {
    emit(
      SearchingProviderState(
          visitants: event.visitants, providers: event.providers),
    );
  }

  void handleDeleteVisitEvent(DeleteVisitEvent event, Emitter emit) {
    emit(
      DeleteVisitState(isVisitant: event.isVisitant),
    );
  }

  void handleDeleteFailureVisitEvent(
      DeleteFailureVisitEvent event, Emitter emit) {
    emit(
      DeleteFailureVisitState(
          visitant: event.visitant,
          visitants: event.visitants,
          providers: event.providers,
          model: event.model),
    );
  }

  void handleDeleteVisitantEvent(DeleteVisitantEvent event, Emitter emit) {
    emit(
      DeleteVisitantState(
          visitant: event.visitant,
          visitants: event.visitants,
          providers: event.providers),
    );
  }

  void handleEditVisitantEvent(EditVisitantEvent event, Emitter emit) {
    emit(
      EditVisitantState(
          visitant: event.visitant,
          model: event.model,
          visitants: event.visitants,
          providers: event.providers),
    );
  }

  void handleAccessControlLoadingEvent(
      AccessControlLoadingEvent event, Emitter emit) {
    emit(
      const AccessControlLoadingState(),
    );
  }

  void handleAccessControlFailureEvent(
      AccessControlFailureEvent event, Emitter emit) {
    emit(
      const AccessControlFailureState(),
    );
  }

  void handleAccessControlOnboardingEvent(
      AccessControlOnBoardingEvent event, Emitter emit) {
    emit(
      const AccessControlOnBoardingState(),
    );
  }

  void handleAccessControlLoadedEvent(
      AccessControlLoadedEvent event, Emitter emit) {
    emit(
      AccessControlLoadedState(
        providers: event.providers,
        visitants: event.visitants,
      ),
    );
  }

  void handleSaveVisitantFailureEvent(
      SaveVisitantFailureEvent event, Emitter emit) {
    emit(
      SaveVisitantFailureState(
        visitants: event.visitants,
        providers: event.providers,
        visitant: event.visitant,
        model: event.model,
        failureInvite: event.failureInvite,
        deletVisitant: event.deletVisitant,
      ),
    );
  }

  void handleSaveVisitantLoadedeEvent(
      SaveVisitantLoadedEvent event, Emitter emit) {
    emit(
      SaveVisitantLoadedState(
        visitants: event.visitants,
        providers: event.providers,
        isVisitant: event.isVisitant,
        useFacial: event.useFacial,
        link: event.link,
        edit: event.edit,
        newVisit: event.newVisit,
        sendInvite: event.sendInvite,
      ),
    );
  }
}
