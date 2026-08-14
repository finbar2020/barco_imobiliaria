import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:morar/feature/reports_book/domain/entity/report.dart';
import 'package:morar/feature/reports_book/domain/entity/report_contents.dart';

abstract class ReportsState extends Equatable {
  final Report? report;

  const ReportsState({this.report});

  @override
  List<Object?> get props => [report];
}

class ReportsInitialState extends ReportsState {
  const ReportsInitialState();
}

class ReportsLoadingState extends ReportsState {
  const ReportsLoadingState({super.report});
}

class ReportsBookFirstState extends ReportsState {
  const ReportsBookFirstState();
}

class SendReportState extends ReportsState {
  final String? flushbarMessage;
  final ReportContents content;

  const SendReportState({
    required super.report,
    required this.content,
    this.flushbarMessage,
  });

  @override
  List<Object?> get props => [...super.props, flushbarMessage, content];
}

class PreviewReportState extends ReportsState {
  final ReportContents content;
  final File? attachment;

  const PreviewReportState({
    required super.report,
    required this.content,
    this.attachment,
  });

  @override
  List<Object?> get props => [...super.props, content, attachment];
}

class SeeReportDetailsState extends ReportsState {
  const SeeReportDetailsState({required super.report});
}

class ReportSendSuccessState extends ReportsState {
  final ReportContents content;

  const ReportSendSuccessState({
    required super.report,
    required this.content,
  });

  @override
  List<Object?> get props => [...super.props, content];
}

class ReportsLoadedState extends ReportsState {
  final List<Report> allReports;

  const ReportsLoadedState({required this.allReports});

  @override
  List<Object?> get props => [...super.props, allReports];
}

class ReportsFailureState extends ReportsState {
  const ReportsFailureState({super.report});
}

class ReportsGetReportFailureState extends ReportsFailureState {
  final List<Report> allReports;
  final Failure? failure;

  const ReportsGetReportFailureState({
    required this.allReports,
    required this.failure,
  });

  @override
  List<Object?> get props => [allReports, failure];
}

class NewReplyReportsFailureState extends ReportsFailureState {
  final Report CurrentReport;
  final ReportContents content;
  final File? attachment;
  final Failure? failure;

  const NewReplyReportsFailureState({
    required this.CurrentReport,
    required this.content,
    this.attachment,
    required this.failure,
  });

  @override
  List<Object?> get props => [CurrentReport, content, attachment, failure];
}

class NewReportsFailureState extends ReportsFailureState {
  final ReportContents content;
  final File? attachment;
  final Failure? failure;

  const NewReportsFailureState({
    required super.report,
    required this.content,
    this.attachment,
    required this.failure,
  });

  @override
  List<Object?> get props => [...super.props, content, attachment, failure];
}

class AttachmentReportsFailureState extends ReportsFailureState {
  final ReportContents content;
  final File? attachment;
  final Failure? failure;

  const AttachmentReportsFailureState({
    required super.report,
    required this.content,
    this.attachment,
    required this.failure,
  });

  @override
  List<Object?> get props => [...super.props, content, attachment, failure];
}

class ReportPostedState extends ReportsState {
  const ReportPostedState({required super.report});
}

class ReportFileLoadedState extends ReportsState {
  final File? attachment;
  final ReportContents? content;

  const ReportFileLoadedState({
    this.attachment,
    super.report,
    this.content,
  });

  @override
  List<Object?> get props => [...super.props, attachment, content];
}
