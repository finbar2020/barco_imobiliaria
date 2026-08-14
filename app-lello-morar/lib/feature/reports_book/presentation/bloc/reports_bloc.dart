import 'package:essentials/essentials.dart';
import 'package:morar/feature/reports_book/presentation/bloc/reports_event.dart';
import 'package:morar/feature/reports_book/presentation/bloc/reports_state.dart';

class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  ReportsBloc() : super(const ReportsLoadingState()) {
    on<AttachmentReportsFailureEvent>(handleAttachmentReportsFailureEvent);
    on<ReportFileLoadedEvent>(handleReportFileLoadedEvent);
    on<ReportPostedEvent>(handleReportPostedEvent);
    on<NewReplyReportsFailureEvent>(handleNewReplyReportsFailureEvent);
    on<PreviewReportEvent>(handlePreviewReportEvent);
    on<ReportSendSuccessEvent>(handleReportSendSuccessEvent);
    on<ReportsBookFirstEvent>(handleReportsBookFirstEvent);
    on<ReportsFailureEvent>(handleReportsFailureEvent);
    on<ReportsGetReportFailureEvent>(handleReportsGetReportFailureEvent);
    on<ReportsLoadedEvent>(handleReportsLoadedEvent);
    on<ReportsLoadingEvent>(handleReportsLoadingEvent);
    on<SeeReportDetailsEvent>(handleSeeReportDetailsEvent);
    on<SendReportEvent>(handleSendReportEvent);
  }

  void handleAttachmentReportsFailureEvent(
    AttachmentReportsFailureEvent event,
    Emitter<ReportsState> emit,
  ) {
    emit(AttachmentReportsFailureState(
      attachment: event.attachment,
      report: event.report,
      content: event.content,
      failure: event.failure,
    ));
  }

  void handleReportFileLoadedEvent(
    ReportFileLoadedEvent event,
    Emitter<ReportsState> emit,
  ) {
    emit(ReportFileLoadedState(
      attachment: event.attachment,
      report: event.report,
      content: event.content,
    ));
  }

  void handleReportPostedEvent(
    ReportPostedEvent event,
    Emitter<ReportsState> emit,
  ) {
    emit(ReportPostedState(report: event.report));
  }

  void handleNewReplyReportsFailureEvent(
    NewReplyReportsFailureEvent event,
    Emitter<ReportsState> emit,
  ) {
    emit(NewReplyReportsFailureState(
      CurrentReport: event.CurrentReport,
      content: event.content,
      attachment: event.attachment,
      failure: event.failure,
    ));
  }

  void handlePreviewReportEvent(
    PreviewReportEvent event,
    Emitter<ReportsState> emit,
  ) {
    emit(PreviewReportState(
      report: event.report,
      content: event.content,
      attachment: event.attachment,
    ));
  }

  void handleReportSendSuccessEvent(
    ReportSendSuccessEvent event,
    Emitter<ReportsState> emit,
  ) {
    emit(ReportSendSuccessState(
      report: event.report,
      content: event.content,
    ));
  }

  void handleReportsBookFirstEvent(
    ReportsBookFirstEvent event,
    Emitter<ReportsState> emit,
  ) {
    emit(const ReportsBookFirstState());
  }

  void handleReportsFailureEvent(
    ReportsFailureEvent event,
    Emitter<ReportsState> emit,
  ) {
    emit(const ReportsFailureState());
  }

  void handleReportsGetReportFailureEvent(
    ReportsGetReportFailureEvent event,
    Emitter<ReportsState> emit,
  ) {
    emit(ReportsGetReportFailureState(
      allReports: event.allReports,
      failure: event.failure,
    ));
  }

  void handleReportsLoadedEvent(
    ReportsLoadedEvent event,
    Emitter<ReportsState> emit,
  ) {
    emit(ReportsLoadedState(allReports: event.allReports));
  }

  void handleReportsLoadingEvent(
    ReportsLoadingEvent event,
    Emitter<ReportsState> emit,
  ) {
    emit(ReportsLoadingState(report: event.report));
  }

  void handleSeeReportDetailsEvent(
    SeeReportDetailsEvent event,
    Emitter<ReportsState> emit,
  ) {
    emit(SeeReportDetailsState(report: event.report));
  }

  void handleSendReportEvent(
    SendReportEvent event,
    Emitter<ReportsState> emit,
  ) {
    emit(SendReportState(
      report: event.report,
      content: event.content,
      flushbarMessage: event.flushbarMessage,
    ));
  }
}
