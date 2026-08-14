import 'dart:io';

import 'package:essentials/essentials.dart';

import '../../domain/entity/report.dart';
import '../../domain/entity/report_contents.dart';

abstract class ReportsState {}

class ReportsEmptyState extends ReportsState {}

class ReportsBookFirstState extends ReportsState {}

class ReportsFailureState extends ReportsState {
  final Failure failure;
  ReportsFailureState({
    required this.failure,
  });
}

class ReportsLoadingState extends ReportsState {}

class ReportLoadingState extends ReportsState {}

class ReportsPagingState extends ReportsState {}

class ReportsLoadedState extends ReportsState {
  List<Report> reports;
  List<String> units;
  bool donePaging;
  ReportsLoadedState(
      {required this.reports, required this.units, required this.donePaging});
}

class SeeReportDetailsState extends ReportsState {
  Report report;
  SeeReportDetailsState({
    required this.report,
  });
}

class SendReportState extends ReportsState {
  Report? report;
  ReportContents? content;
  SendReportState({
    required this.report,
    required this.content,
  });
}

class PreviewReplyState extends ReportsState {
  Report report;
  ReportContents content;
  PreviewReplyState({
    required this.report,
    required this.content,
  });
}

class PreviewReportState extends ReportsState {
  Report report;
  ReportContents content;
  File? attachment;
  PreviewReportState({
    required this.report,
    required this.content,
    required this.attachment,
  });
}

class ReportPostedState extends ReportsState {}

class ReportPostedFailedState extends ReportsState {
  final Failure failure;
  ReportPostedFailedState({required this.failure});
}

class ReportClosedState extends ReportsState {}
