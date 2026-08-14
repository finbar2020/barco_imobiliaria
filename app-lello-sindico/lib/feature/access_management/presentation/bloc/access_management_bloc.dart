import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/access_management/presentation/bloc/access_management_event.dart';
import 'package:lello/feature/access_management/presentation/bloc/access_management_state.dart';

class AccessManagementBloc
    extends Bloc<AccessManagementEvent, AccessManagementState> {
  AccessManagementBloc() : super(AccessManagementEmptyState()) {
    on<AccessManagementErrorEvent>(handleAccessManagementErrorEvent);
    on<AccessManagementEmptyEvent>(handleAccessManagementEmptyEvent);
    on<AccessManagementLoadingEvent>(handleAccessManagementLoadingEvent);
    on<AccessManagementServiceOnEvent>(handleAccessManagementServiceOnEvent);
    on<AccessManagementServiceOffEvent>(handleAccessManagementServiceOffEvent);
    on<AccessManagementFacialFailedEvent>(
        handleAccessManagementFacialFailedEvent);
    on<AccessManagementFacialSuccessEvent>(
        handleAccessManagementFacialSuccessEvent);
  }

  void handleAccessManagementErrorEvent(
      AccessManagementErrorEvent event, Emitter emit) {
    emit(AccessManagementErrorState());
  }

  void handleAccessManagementEmptyEvent(
      AccessManagementEmptyEvent event, Emitter emit) {
    emit(AccessManagementEmptyState());
  }

  void handleAccessManagementLoadingEvent(
      AccessManagementLoadingEvent event, Emitter emit) {
    emit(AccessManagementLoadingState());
  }

  void handleAccessManagementServiceOnEvent(
      AccessManagementServiceOnEvent event, Emitter emit) {
    emit(AccessManagementServiceOnState());
  }

  void handleAccessManagementServiceOffEvent(
      AccessManagementServiceOffEvent event, Emitter emit) {
    emit(AccessManagementServiceOffState());
  }

  void handleAccessManagementFacialFailedEvent(
      AccessManagementFacialFailedEvent event, Emitter emit) {
    emit(
      AccessManagementFacialFailedState(
        code: event.code,
        message: event.message,
      ),
    );
  }

  void handleAccessManagementFacialSuccessEvent(
      AccessManagementFacialSuccessEvent event, Emitter emit) {
    emit(AccessManagementFacialSuccessState());
  }
}
