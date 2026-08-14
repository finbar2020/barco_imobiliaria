import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet/timesheet_event.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet/timesheet_state.dart';

class TimesheetBloc extends Bloc<TimesheetEvent, TimesheetState> {
  TimesheetBloc() : super(TimesheetLoadingState()) {
    on<TimesheetLoadingEvent>(handleLoadingEvent);
    on<TimesheetLoadedEvent>(handleLoadedEvent);
    on<TimesheetDetailLoadedEvent>(handleDetailLoadedEvent);
    on<TimesheetFailedEvent>(handleFailedEvent);
  }

  void handleLoadingEvent(TimesheetLoadingEvent event, Emitter emit) {
    emit(TimesheetLoadingState());
  }

  void handleLoadedEvent(TimesheetLoadedEvent event, Emitter emit) {
    emit(TimesheetLoadedState(
      list: event.list,
      getDetailFailed: event.getDetailFailed,
      saveSignatureOrNotify: event.saveSignatureOrNotify,
    ));
  }

  void handleDetailLoadedEvent(TimesheetDetailLoadedEvent event, Emitter emit) {
    emit(TimesheetDetailLoadedState(
      entity: event.entity,
      employee: event.employee,
      pdf: event.pdf,
      putFailed: event.putFailed,
    ));
  }

  void handleFailedEvent(TimesheetFailedEvent event, Emitter emit) {
    emit(TimesheetFailedState());
  }
}
