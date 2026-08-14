import 'package:flutter_bloc/flutter_bloc.dart';

import 'sample_bloc_page_event.dart';
import 'sample_bloc_page_state.dart';

class SampleBlocPageBloc
    extends Bloc<SampleBlocPageEvent, SampleBlocPageState> {
  SampleBlocPageBloc() : super(SampleBlocPageEmptyState()) {
    on<SampleBlocPageEmptyEvent>(handleSampleBlocPageEmptyEvent);
    on<SampleBlocPageLoadingEvent>(handleSampleBlocPageLoadingEvent);
    on<SampleBlocPageSuccessEvent>(handleSampleBlocPageSuccessEvent);
    on<SampleBlocPageFailureEvent>(handleSampleBlocPageFailureEvent);
  }

  void handleSampleBlocPageEmptyEvent(
          SampleBlocPageEmptyEvent event, Emitter emit) =>
      emit(SampleBlocPageEmptyState());

  void handleSampleBlocPageLoadingEvent(
          SampleBlocPageLoadingEvent event, Emitter emit) =>
      emit(SampleBlocPageLoadingState());

  void handleSampleBlocPageSuccessEvent(
          SampleBlocPageSuccessEvent event, Emitter emit) =>
      emit(SampleBlocPageSuccessState(value: event.value));

  void handleSampleBlocPageFailureEvent(
          SampleBlocPageFailureEvent event, Emitter emit) =>
      emit(SampleBlocPageFailureState(error: event.error));
}
