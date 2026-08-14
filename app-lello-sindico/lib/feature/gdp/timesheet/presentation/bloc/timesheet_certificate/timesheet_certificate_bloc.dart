import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_certificate/timesheet_certificate_event.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_certificate/timesheet_certificate_state.dart';

class TimesheetCertificateBloc
    extends Bloc<TimesheetCertificateEvent, TimesheetCertificateState> {
  TimesheetCertificateBloc() : super(TimesheetCertificateLoadingState()) {
    on<TimesheetCertificateLoadingEvent>(handleLoadingEvent);
    on<TimesheetCertificateLoadedEvent>(handleLoadedEvent);
    on<TimesheetCertificateFailedEvent>(handleFailedEvent);
  }

  void handleLoadingEvent(
      TimesheetCertificateLoadingEvent event, Emitter emit) {
    emit(TimesheetCertificateLoadingState());
  }

  void handleLoadedEvent(TimesheetCertificateLoadedEvent event, Emitter emit) {
    emit(TimesheetCertificateLoadedState(
      list: event.list,
      file: event.pdf,
      filename: event.filename,
      getArchiveFailed: event.getArchiveFailed,
    ));
  }

  void handleFailedEvent(TimesheetCertificateFailedEvent event, Emitter emit) {
    emit(TimesheetCertificateFailedState());
  }
}
