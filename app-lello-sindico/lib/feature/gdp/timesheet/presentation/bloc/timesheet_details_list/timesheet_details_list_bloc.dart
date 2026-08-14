import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_details_list/timesheet_details_list_event.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_details_list/timesheet_details_list_state.dart';

class TimesheetDetailListsBloc
    extends Bloc<DetailsListEvent, TimesheetDetailsListState> {
  TimesheetDetailListsBloc() : super(TimesheetDetailsListLoadingState()) {
    on<DetailsListLoadingEvent>(handleLoadingEvent);
    on<DetailsListLoadedEvent>(handleLoadedEvent);
    on<VacationsListLoadedEvent>(handleVacationLoadedEvent);
    on<DetailsListFailedEvent>(handleFailedEvent);
  }

  void handleLoadingEvent(DetailsListLoadingEvent event, Emitter emit) {
    emit(TimesheetDetailsListLoadingState());
  }

  void handleLoadedEvent(DetailsListLoadedEvent event, Emitter emit) {
    emit(TimesheetDetailsListLoadedState(
      list: event.list,
      saveFailed: event.saveFailed,
      saveSuccess: event.saveSuccess,
    ));
  }

  void handleVacationLoadedEvent(VacationsListLoadedEvent event, Emitter emit) {
    emit(TimesheetVacationsLoadedState(
      list: event.list,
      getArchiveFailed: event.getArchiveFailed,
      pdf: event.pdf,
      filename: event.filename,
    ));
  }

  void handleFailedEvent(DetailsListFailedEvent event, Emitter emit) {
    emit(TimesheetDetailsListFailedState());
  }
}
