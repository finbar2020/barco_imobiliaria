import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/feature/reports_book/presentation/bloc/reports_event.dart';
import 'package:morar/feature/reports_book/presentation/bloc/reports_state.dart';

import 'reports_book_page_helpers.dart';

/// Igualdade (Equatable) de todos os eventos e estados do `ReportsBloc`:
/// é o que decide se o bloc emite ou descarta um estado repetido.
void main() {
  final report = buildReport();
  final other = buildReport(id: 'r2');
  final content = buildContent();
  final file = tempAttachment();
  final failure = UnknownFailure('x');

  test('eventos comparam pelas suas propriedades', () {
    expect(const ReportsEmptyEvent(), const ReportsEmptyEvent());
    expect(ReportsLoadingEvent(report: report), ReportsLoadingEvent(report: report));
    expect(ReportsLoadingEvent(report: report), isNot(ReportsLoadingEvent(report: other)));
    expect(const ReportsBookFirstEvent(), const ReportsBookFirstEvent());
    expect(SendReportEvent(report: report, content: content, flushbarMessage: 'm'),
        SendReportEvent(report: report, content: content, flushbarMessage: 'm'));
    expect(SendReportEvent(report: report, content: content),
        isNot(SendReportEvent(report: report, content: content, flushbarMessage: 'm')));
    expect(PreviewReportEvent(report: report, content: content, attachment: file),
        PreviewReportEvent(report: report, content: content, attachment: file));
    expect(PreviewReportEvent(report: report, content: content),
        isNot(PreviewReportEvent(report: report, content: content, attachment: file)));
    expect(SeeReportDetailsEvent(report: report), SeeReportDetailsEvent(report: report));
    expect(ReportSendSuccessEvent(report: report, content: content),
        ReportSendSuccessEvent(report: report, content: content));
    expect(ReportsLoadedEvent(allReports: [report]), ReportsLoadedEvent(allReports: [report]));
    expect(ReportsLoadedEvent(allReports: [report]),
        isNot(ReportsLoadedEvent(allReports: [other])));
    expect(const ReportsFailureEvent(), const ReportsFailureEvent());
    expect(ReportsGetReportFailureEvent(allReports: [report], failure: failure),
        ReportsGetReportFailureEvent(allReports: [report], failure: failure));
    expect(ReportsGetReportFailureEvent(report: report, allReports: [report], failure: failure),
        isNot(ReportsGetReportFailureEvent(allReports: [report], failure: failure)));
    expect(NewReplyReportsFailureEvent(CurrentReport: report, content: content, failure: failure),
        NewReplyReportsFailureEvent(CurrentReport: report, content: content, failure: failure));
    expect(NewReportsFailureEvent(report: report, content: content, attachment: file, failure: failure),
        NewReportsFailureEvent(report: report, content: content, attachment: file, failure: failure));
    expect(AttachmentReportsFailureEvent(report: report, content: content, failure: failure),
        AttachmentReportsFailureEvent(report: report, content: content, failure: failure));
    expect(AttachmentReportsFailureEvent(report: report, content: content, failure: failure),
        isNot(AttachmentReportsFailureEvent(report: other, content: content, failure: failure)));
    expect(ReportPostedEvent(report: report), ReportPostedEvent(report: report));
    expect(ReportFileLoadedEvent(report: report, content: content, attachment: file),
        ReportFileLoadedEvent(report: report, content: content, attachment: file));
    expect(ReportFileLoadedEvent(report: report),
        isNot(ReportFileLoadedEvent(report: report, attachment: file)));
  });

  test('estados comparam pelas suas propriedades', () {
    expect(const ReportsInitialState(), const ReportsInitialState());
    expect(ReportsLoadingState(report: report), ReportsLoadingState(report: report));
    expect(const ReportsLoadingState(), isNot(ReportsLoadingState(report: report)));
    expect(const ReportsBookFirstState(), const ReportsBookFirstState());
    expect(SendReportState(report: report, content: content, flushbarMessage: 'm'),
        SendReportState(report: report, content: content, flushbarMessage: 'm'));
    expect(SendReportState(report: report, content: content),
        isNot(SendReportState(report: other, content: content)));
    expect(PreviewReportState(report: report, content: content, attachment: file),
        PreviewReportState(report: report, content: content, attachment: file));
    expect(PreviewReportState(report: report, content: content),
        isNot(PreviewReportState(report: report, content: content, attachment: file)));
    expect(SeeReportDetailsState(report: report), SeeReportDetailsState(report: report));
    expect(ReportSendSuccessState(report: report, content: content),
        ReportSendSuccessState(report: report, content: content));
    expect(ReportSendSuccessState(report: report, content: content),
        isNot(ReportSendSuccessState(report: other, content: content)));
    expect(ReportsLoadedState(allReports: [report]), ReportsLoadedState(allReports: [report]));
    expect(const ReportsFailureState(), const ReportsFailureState());
    expect(ReportsGetReportFailureState(allReports: [report], failure: failure),
        ReportsGetReportFailureState(allReports: [report], failure: failure));
    expect(ReportsGetReportFailureState(allReports: [report], failure: failure),
        isNot(ReportsGetReportFailureState(allReports: [other], failure: failure)));
    expect(ReportsGetReportFailureState(report: report, allReports: [report], failure: failure),
        isNot(ReportsGetReportFailureState(allReports: [report], failure: failure)));
    expect(ReportsGetReportFailureState(report: report, allReports: [report], failure: failure).report, report);
    expect(NewReplyReportsFailureState(CurrentReport: report, content: content, failure: failure).report, report);
    // `ReportContents` compara por referência: a cópia gera um estado diferente.
    expect(SendReportState(report: report, content: content),
        isNot(SendReportState(report: report, content: content.copy())));
    expect(content.copy().id, content.id);
    expect(NewReplyReportsFailureState(CurrentReport: report, content: content, failure: failure),
        NewReplyReportsFailureState(CurrentReport: report, content: content, failure: failure));
    expect(NewReplyReportsFailureState(CurrentReport: report, content: content, failure: failure),
        isNot(NewReplyReportsFailureState(CurrentReport: other, content: content, failure: failure)));
    expect(NewReportsFailureState(report: report, content: content, attachment: file, failure: failure),
        NewReportsFailureState(report: report, content: content, attachment: file, failure: failure));
    expect(AttachmentReportsFailureState(report: report, content: content, failure: failure),
        AttachmentReportsFailureState(report: report, content: content, failure: failure));
    expect(AttachmentReportsFailureState(report: report, content: content, failure: failure),
        isNot(AttachmentReportsFailureState(report: report, content: content, attachment: file, failure: failure)));
    expect(ReportPostedState(report: report), ReportPostedState(report: report));
    expect(ReportFileLoadedState(report: report, content: content, attachment: file),
        ReportFileLoadedState(report: report, content: content, attachment: file));
    expect(ReportFileLoadedState(report: report),
        isNot(ReportFileLoadedState(report: report, content: content)));
  });
}
