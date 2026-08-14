import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/reports_book/presentation/bloc/reports_event.dart';
import 'package:lello/feature/reports_book/presentation/bloc/reports_state.dart';

class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  ReportsBloc() : super(ReportsLoadingState()) {
    //Get Reports
    on<ReportsLoadingEvent>(handleReportsLoadingEvent);
    on<ReportsEmptyEvent>(handleReportsEmptyEvent);
    on<ReportsFailureEvent>(handleReportsFailureEvent);
    on<ReportsLoadedEvent>(handleReportsLoadedEvent);
    //NextPage
    on<ReportsPagingEvent>(handleReportsPagingEvent);
    //GetReports
    on<ReportLoadingEvent>(handleReportLoadingEvent);
    on<SeeReportDetailsEvent>(handleSeeReportDetailsEvent);
    //ReportPostedReport
    on<ReportPostedEvent>(handleReportPostedEvent);
    on<ReportPostedFailedEvent>(handleReportPostedFailedEvent);
    //CloseReport
    on<ReportClosedEvent>(handleReportClosedEvent);
    //SendReportEvent
    on<SendReportEvent>(handleSendReportEvent);
    //PreviewReply
    on<PreviewReplyEvent>(handlePreviewReplyEvent);
    on<PreviewReportEvent>(handlePreviewReportEvent);
  }

  //Get Reports
  void handleReportsLoadingEvent(ReportsLoadingEvent event, Emitter emit) {
    emit(
      ReportsLoadingState(),
    );
  }

  void handleReportsEmptyEvent(ReportsEmptyEvent event, Emitter emit) {
    emit(
      ReportsEmptyState(),
    );
  }

  void handleReportsFailureEvent(ReportsFailureEvent event, Emitter emit) {
    emit(
      ReportsFailureState(failure: event.failure),
    );
  }

  void handleReportsLoadedEvent(ReportsLoadedEvent event, Emitter emit) {
    emit(
      ReportsLoadedState(
          units: event.units,
          donePaging: event.donePaging,
          reports: event.reports),
    );
  }

  //Get next page
  void handleReportsPagingEvent(ReportsPagingEvent event, Emitter emit) {
    emit(
      ReportsPagingState(),
    );
  }

  //Get report
  void handleReportLoadingEvent(ReportLoadingEvent event, Emitter emit) {
    emit(
      ReportLoadingState(),
    );
  }

  void handleSeeReportDetailsEvent(SeeReportDetailsEvent event, Emitter emit) {
    emit(
      SeeReportDetailsState(report: event.report),
    );
  }

  //ReportPostedReport
  void handleReportPostedEvent(ReportPostedEvent event, Emitter emit) {
    emit(
      ReportPostedState(),
    );
  }

  void handleReportPostedFailedEvent(
      ReportPostedFailedEvent event, Emitter emit) {
    emit(
      ReportPostedFailedState(failure: event.failure),
    );
  }

  //CloseReport
  void handleReportClosedEvent(ReportClosedEvent event, Emitter emit) {
    emit(
      ReportClosedState(),
    );
  }

  //SendReportEvent
  void handleSendReportEvent(SendReportEvent event, Emitter emit) {
    emit(
      SendReportState(content: event.content, report: event.report),
    );
  }

  //PreviewReply
  void handlePreviewReplyEvent(PreviewReplyEvent event, Emitter emit) {
    emit(
      PreviewReplyState(content: event.content, report: event.report),
    );
  }

  void handlePreviewReportEvent(PreviewReportEvent event, Emitter emit) {
    emit(
      PreviewReportState(
          report: event.report,
          content: event.content,
          attachment: event.attachment),
    );
  }
}
