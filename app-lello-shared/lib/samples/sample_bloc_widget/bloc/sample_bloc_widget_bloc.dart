import 'package:flutter_bloc/flutter_bloc.dart';

import 'sample_bloc_widget_event.dart';
import 'sample_bloc_widget_state.dart';

class SampleBlocWidgetBloc
    extends Bloc<SampleBlocWidgetEvent, SampleBlocWidgetState> {
  SampleBlocWidgetBloc() : super(SampleBlocWidgetEmptyState()) {
    on<SampleBlocWidgetEmptyEvent>(handleSampleBlocWidgetEmptyEvent);
    on<SampleBlocWidgetLoadingEvent>(handleSampleBlocWidgetLoadingEvent);
    on<SampleBlocWidgetSuccessEvent>(handleSampleBlocWidgetSuccessEvent);
    on<SampleBlocWidgetFailureEvent>(handleSampleBlocWidgetFailureEvent);
  }

  void handleSampleBlocWidgetEmptyEvent(
          SampleBlocWidgetEmptyEvent event, Emitter emit) =>
      emit(SampleBlocWidgetEmptyState());

  void handleSampleBlocWidgetLoadingEvent(
          SampleBlocWidgetLoadingEvent event, Emitter emit) =>
      emit(SampleBlocWidgetLoadingState());

  void handleSampleBlocWidgetSuccessEvent(
          SampleBlocWidgetSuccessEvent event, Emitter emit) =>
      emit(SampleBlocWidgetSuccessState(value: event.value));

  void handleSampleBlocWidgetFailureEvent(
          SampleBlocWidgetFailureEvent event, Emitter emit) =>
      emit(SampleBlocWidgetFailureState(error: event.error));
}
