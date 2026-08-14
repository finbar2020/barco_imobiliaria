import 'package:essentials/essentials.dart';
import 'package:morar/feature/digital_meeting/presentation/bloc/digital_meeting_event.dart';
import 'package:morar/feature/digital_meeting/presentation/bloc/digital_meeting_state.dart';

class DigitalMeetingBloc
    extends Bloc<DigitalMeetingEvent, DigitalMeetingState> {
  DigitalMeetingBloc() : super(const DigitalMeetingInitialState()) {
    on<DigitalMeetingEmptyEvent>(handleDigitalMeetingEmptyEvent);
    on<DigitalMeetingLoadingEvent>(handleDigitalMeetingLoadingEvent);
    on<DigitalMeetingLoadedEvent>(handleDigitalMeetingLoadedEvent);
    on<DigitalMeetingShowAllEvent>(handleDigitalMeetingShowAllEvent);
    on<DigitalMeetingWebViewEvent>(handleDigitalMeetingWebViewEvent);
    on<DigitalMeetingFailureAssembliesEvent>(
        handleDigitalMeetingFailureAssembliesEvent);
    on<DigitalMeetingFailureEvent>(handleDigitalMeetingFailureEvent);
  }

  void handleDigitalMeetingEmptyEvent(
      DigitalMeetingEmptyEvent event, Emitter emit) {
    emit(const DigitalMeetingInitialState());
  }

  void handleDigitalMeetingLoadingEvent(
      DigitalMeetingLoadingEvent event, Emitter emit) {
    emit(const DigitalMeetingLoadingState());
  }

  void handleDigitalMeetingLoadedEvent(
      DigitalMeetingLoadedEvent event, Emitter emit) {
    emit(DigitalMeetingLoadedState(meetings: event.meetings));
  }

  void handleDigitalMeetingShowAllEvent(
      DigitalMeetingShowAllEvent event, Emitter emit) {
    emit(DigitalMeetingShowAllState(meetings: event.meetings));
  }

  void handleDigitalMeetingWebViewEvent(
      DigitalMeetingWebViewEvent event, Emitter emit) {
    emit(DigitalMeetingWebViewState(meeting: event.meeting));
  }

  void handleDigitalMeetingFailureAssembliesEvent(
      DigitalMeetingFailureAssembliesEvent event, Emitter emit) {
    emit(DigitalMeetingFailureAssembliesState(message: event.message));
  }

  void handleDigitalMeetingFailureEvent(
      DigitalMeetingFailureEvent event, Emitter emit) {
    emit(DigitalMeetingFailureState(message: event.message));
  }
}
