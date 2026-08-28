import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_requests/bloc/comfort_my_requests_event.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_requests/bloc/comfort_my_requests_state.dart';

class ComfortMyRequestsBloc
    extends Bloc<ComfortMyRequestsEvent, ComfortMyRequestsState> {
  ComfortMyRequestsBloc() : super(const LoadingComfortMyRequestsState()) {
    on<EmptyComfortMyRequestsEvent>(handleEmptyComfortMyRequestsEvent);
    on<SuccessComfortMyRequestsEvent>(handleSuccessComfortMyRequestsEvent);
    on<ErrorComfortMyRequestsEvent>(handleErrorComfortMyRequestsEvent);
    on<LoadedMyRequestsEvent>(handleLoadedMyRequestsEvent);
    on<LoadedRateRequestEvent>(handleLoadedRateRequestEvent);
    on<LoadingComfortMyRequestsEvent>(handleComfortMyRequestsLoadingEvent);
    on<LoadedSubcategoriesMyRequestEvent>(handleLoadedSubcategoriesMyRequests);
  }

  void handleComfortMyRequestsLoadingEvent(LoadingComfortMyRequestsEvent event,
      Emitter<ComfortMyRequestsState> emit) {
    emit(
      const LoadingComfortMyRequestsState(),
    );
  }

  void handleLoadedSubcategoriesMyRequests(
      LoadedSubcategoriesMyRequestEvent event,
      Emitter<ComfortMyRequestsState> emit) {
    emit(LoadedSubcategoriesMyRequestState(
      subcategories: event.subcategories,
      flushbarMessage: event.flushbarMessage,
    ));
  }

  void handleLoadedRateRequestEvent(
      LoadedRateRequestEvent event, Emitter<ComfortMyRequestsState> emit) {
    emit(
      LoadedRateRequestState(
        selectedRequest: event.selectedRequest,
        flushbarMessage: event.flushbarMessage,
      ),
    );
  }

  void handleLoadedMyRequestsEvent(
      LoadedMyRequestsEvent event, Emitter<ComfortMyRequestsState> emit) {
    emit(
      LoadedMyRequestsState(
        myRequests: event.myRequests,
        flushbarMessage: event.flushbarMessage,
        selectedRequest: event.selectedRequest,
      ),
    );
  }

  void handleErrorComfortMyRequestsEvent(
      ErrorComfortMyRequestsEvent event, Emitter<ComfortMyRequestsState> emit) {
    emit(
      ErrorComfortMyRequestsState(
        errorMessageKey: event.errorMessageKey,
        errorCode: event.errorCode,
        errorDescription: event.errorDescription,
      ),
    );
  }

  void handleSuccessComfortMyRequestsEvent(SuccessComfortMyRequestsEvent event,
      Emitter<ComfortMyRequestsState> emit) {
    emit(
      const SuccessComfortMyRequestsState(),
    );
  }

  void handleEmptyComfortMyRequestsEvent(
      EmptyComfortMyRequestsEvent event, Emitter<ComfortMyRequestsState> emit) {
    emit(
      const EmptyComfortMyRequestsState(),
    );
  }
}
