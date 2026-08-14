import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_occurrence/timesheet_occurrence_event.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_occurrence/timesheet_occurrence_state.dart';

class TimesheetOccurrenceBloc
    extends Bloc<TimesheetOccurrenceEvent, TimesheetOccurrenceState> {
  TimesheetOccurrenceBloc() : super(TimesheetOccurrenceLoadingState()) {
    on<TimesheetOccurrenceLoadingEvent>(handleLoadingEvent);
    on<TimesheetOccurrenceLoadedEvent>(handleLoadedEvent);
    on<TimesheetOccurrenceFailedEvent>(handleFailedEvent);
  }

  void handleLoadingEvent(TimesheetOccurrenceLoadingEvent event, Emitter emit) {
    emit(TimesheetOccurrenceLoadingState());
  }

  void handleLoadedEvent(TimesheetOccurrenceLoadedEvent event, Emitter emit) {
    emit(TimesheetOccurrenceLoadedState(
      list: event.list,
      saveFailed: event.saveFailed,
      saveSuccess: event.saveSuccess,
      employeeFiltered: event.employeeFiltered,
      typeFiltered: event.typeFiltered,
    ));
  }

  void handleFailedEvent(TimesheetOccurrenceFailedEvent event, Emitter emit) {
    emit(TimesheetOccurrenceFailedState());
  }
}
