import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:morar/feature/reports_book/domain/entity/report.dart';
import 'package:morar/feature/reports_book/domain/entity/report_contents.dart';

abstract class ReportsEvent extends Equatable {
  final Report? report;

  const ReportsEvent({this.report});

  @override
  List<Object?> get props => [report];
}

class ReportsEmptyEvent extends ReportsEvent {
  const ReportsEmptyEvent();
}

class ReportsLoadingEvent extends ReportsEvent {
  const ReportsLoadingEvent({super.report});
}

class ReportsBookFirstEvent extends ReportsEvent {
  const ReportsBookFirstEvent();
}

class SendReportEvent extends ReportsEvent {
  final String? flushbarMessage;
  final ReportContents content;

  const SendReportEvent({
    required super.report,
    required this.content,
    this.flushbarMessage,
  });

  @override
  List<Object?> get props => [...super.props, flushbarMessage, content];
}

class PreviewReportEvent extends ReportsEvent {
  final ReportContents content;
  final File? attachment;

  const PreviewReportEvent({
    required super.report,
    required this.content,
    this.attachment,
  });

  @override
  List<Object?> get props => [...super.props, content, attachment];
}

class SeeReportDetailsEvent extends ReportsEvent {
  const SeeReportDetailsEvent({required super.report});
}

class ReportSendSuccessEvent extends ReportsEvent {
  final ReportContents content;

  const ReportSendSuccessEvent({
    required super.report,
    required this.content,
  });

  @override
  List<Object?> get props => [...super.props, content];
}

class ReportsLoadedEvent extends ReportsEvent {
  final List<Report> allReports;

  const ReportsLoadedEvent({required this.allReports});

  @override
  List<Object?> get props => [...super.props, allReports];
}

class ReportsFailureEvent extends ReportsEvent {
  const ReportsFailureEvent({super.report});
}

class ReportsGetReportFailureEvent extends ReportsFailureEvent {
  final List<Report> allReports;
  final Failure? failure;

  /// [report] é a ocorrência cuja busca falhou, para o "tentar novamente".
  const ReportsGetReportFailureEvent({
    super.report,
    required this.allReports,
    required this.failure,
  });

  @override
  List<Object?> get props => [...super.props, allReports, failure];
}

class NewReplyReportsFailureEvent extends ReportsFailureEvent {
  final Report CurrentReport;
  final ReportContents content;
  final File? attachment;
  final Failure? failure;

  const NewReplyReportsFailureEvent({
    required this.CurrentReport,
    required this.content,
    this.attachment,
    required this.failure,
  });

  @override
  List<Object?> get props => [CurrentReport, content, attachment, failure];
}

class NewReportsFailureEvent extends ReportsFailureEvent {
  final ReportContents content;
  final File? attachment;
  final Failure? failure;

  const NewReportsFailureEvent({
    required super.report,
    required this.content,
    this.attachment,
    required this.failure,
  });

  @override
  List<Object?> get props => [...super.props, content, attachment, failure];
}

class AttachmentReportsFailureEvent extends ReportsFailureEvent {
  final ReportContents content;
  final File? attachment;
  final Failure? failure;

  const AttachmentReportsFailureEvent({
    required super.report,
    required this.content,
    this.attachment,
    required this.failure,
  });

  @override
  List<Object?> get props => [...super.props, content, attachment, failure];
}

class ReportPostedEvent extends ReportsEvent {
  const ReportPostedEvent({required super.report});
}

class ReportFileLoadedEvent extends ReportsEvent {
  final File? attachment;
  final ReportContents? content;

  const ReportFileLoadedEvent({
    this.attachment,
    super.report,
    this.content,
  });

  @override
  List<Object?> get props => [...super.props, attachment, content];
}
