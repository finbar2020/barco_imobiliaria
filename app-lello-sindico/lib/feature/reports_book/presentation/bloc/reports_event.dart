import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lello/feature/reports_book/domain/entity/report.dart';
import 'package:lello/feature/reports_book/domain/entity/report_contents.dart';
import 'package:lello/feature/reports_book/domain/entity/report_filter.dart';

abstract class ReportsEvent {}

class GetReportsEvent extends ReportsEvent {
  ReportFilter filter;
  GetReportsEvent({required this.filter});
}

class GetReportsNextPageEvent extends ReportsEvent {}

class ReportsEmptyEvent extends ReportsEvent {}

class GetReportEvent extends ReportsEvent {
  Report report;
  GetReportEvent({required this.report});
}

class SeeReportDetailsEvent extends ReportsEvent {
  Report report;
  SeeReportDetailsEvent({required this.report});
}

class ReplyReportEvent extends ReportsEvent {
  Report report;
  ReportContents content;
  ReplyReportEvent({
    required this.report,
    required this.content,
  });
}

class PreviewReplyEvent extends ReportsEvent {
  Report report;
  ReportContents content;
  PreviewReplyEvent({
    required this.report,
    required this.content,
  });
}

class PreviewReportEvent extends ReportsEvent {
  Report report;
  ReportContents content;
  File? attachment;
  PreviewReportEvent({
    required this.report,
    required this.content,
    required this.attachment,
  });
}

class SendReplyReportEvent extends ReportsEvent {
  Report report;
  ReportContents content;
  File? attachment;
  SendReplyReportEvent(
      {required this.report, required this.content, this.attachment});
}

class CloseReportEvent extends ReportsEvent {
  Report report;
  CloseReportEvent({required this.report});
}

class NewReportEventChooseImageEvent extends ReportsEvent {
  final ImageSource source;
  Report newReport;
  ReportContents content;
  NewReportEventChooseImageEvent(this.source, this.newReport, this.content);
}

class NewReportEventChooseFile extends ReportsEvent {
  Report newReport;
  ReportContents content;
  NewReportEventChooseFile(this.newReport, this.content);
}

class ReportsFailureEvent extends ReportsEvent {
  final Failure failure;
  ReportsFailureEvent({
    required this.failure,
  });
}

class ReportsLoadingEvent extends ReportsEvent {}

class ReportLoadingEvent extends ReportsEvent {}

class ReportsPagingEvent extends ReportsEvent {}

class ReportsLoadedEvent extends ReportsEvent {
  List<Report> reports;
  List<String> units;
  bool donePaging;
  ReportsLoadedEvent(
      {required this.reports, required this.units, required this.donePaging});
}

class SendReportEvent extends ReportsEvent {
  Report? report;
  ReportContents? content;
  SendReportEvent({
    required this.report,
    required this.content,
  });
}

class ReportPostedEvent extends ReportsEvent {}

class ReportPostedFailedEvent extends ReportsEvent {
  final Failure failure;
  ReportPostedFailedEvent({
    required this.failure,
  });
}

class ReportClosedEvent extends ReportsEvent {}
