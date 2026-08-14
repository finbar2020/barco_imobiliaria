import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/resident/bloc/residents_event.dart';
import 'package:lello/feature/resident/bloc/residents_state.dart';

class ResidentsBloc extends Bloc<ResidentsEvent, ResidentsState> {
  ResidentsBloc() : super(ResidentsLoadingState()) {
    on<ResidentsLoadingEvent>(handleResidentsLoadingEvent);
    on<ResidentsLoadFailedEvent>(handleResidentsLoadFailedEvent);
    on<ResidentsPagingEvent>(handleResidentsPagingEvent);
    on<ResidentsPageFailedEvent>(handleResidentsPageFailedEvent);
    on<ResidentsLoadedEvent>(handleResidentsLoadedEvent);
    on<ResidentsSearchingEvent>(handleResidentsSearchingEvent);
  }

  void handleResidentsLoadingEvent(ResidentsLoadingEvent event, Emitter emit) {
    emit(ResidentsLoadingState());
  }

  void handleResidentsLoadFailedEvent(
      ResidentsLoadFailedEvent event, Emitter emit) {
    emit(ResidentsLoadFailedState(failure: event.failure));
  }

  void handleResidentsPagingEvent(ResidentsPagingEvent event, Emitter emit) {
    emit(ResidentsPagingState());
  }

  void handleResidentsPageFailedEvent(
      ResidentsPageFailedEvent event, Emitter emit) {
    emit(ResidentsPageFailedState(failure: event.failure));
  }

  void handleResidentsLoadedEvent(ResidentsLoadedEvent event, Emitter emit) {
    emit(ResidentsLoadedState(
        blocks: event.blocks!,
        data: event.data!,
        query: event.query!,
        donePaging: event.donePaging));
  }

  void handleResidentsSearchingEvent(
      ResidentsSearchingEvent event, Emitter emit) {
    emit(ResidentsSearchingState());
  }
}
