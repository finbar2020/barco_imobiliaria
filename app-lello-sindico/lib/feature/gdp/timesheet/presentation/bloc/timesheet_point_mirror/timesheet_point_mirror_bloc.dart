import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_point_mirror/timesheet_point_mirror_event.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_point_mirror/timesheet_point_mirror_state.dart';

class TimesheetPointMirrorBloc
    extends Bloc<TimesheetPointMirrorEvent, TimesheetPointMirrorState> {
  TimesheetPointMirrorBloc() : super(TimesheetPointMirrorLoadingState()) {
    on<TimesheetPointMirrorLoadingEvent>(handleLoadingEvent);
    on<TimesheetPointMirrorLoadedEvent>(handleLoadedEvent);
    on<TimesheetPointMirrorFailedEvent>(handleFailedEvent);
  }

  void handleLoadingEvent(
      TimesheetPointMirrorLoadingEvent event, Emitter emit) {
    emit(TimesheetPointMirrorLoadingState());
  }

  void handleLoadedEvent(TimesheetPointMirrorLoadedEvent event, Emitter emit) {
    emit(TimesheetPointMirrorLoadedState(
      list: event.list,
      saveFailed: event.saveFailed,
      saveSuccess: event.saveSuccess,
    ));
  }

  void handleFailedEvent(TimesheetPointMirrorFailedEvent event, Emitter emit) {
    emit(TimesheetPointMirrorFailedState());
  }
}
