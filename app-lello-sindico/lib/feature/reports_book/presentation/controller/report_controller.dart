import 'dart:io';

import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:essentials/essentials.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lello/core/analytics/analytics_log_events.dart';
import 'package:lello/feature/reports_book/data/model/content_send_model.dart';
import 'package:lello/feature/reports_book/data/model/report_filter_model.dart';
import 'package:lello/feature/reports_book/domain/entity/report.dart';
import 'package:lello/feature/reports_book/domain/entity/report_contents.dart';
import 'package:lello/feature/reports_book/domain/entity/report_filter.dart';
import 'package:lello/feature/reports_book/domain/entity/report_type_user.dart';
import 'package:lello/feature/reports_book/domain/use_case/close_report.dart';
import 'package:lello/feature/reports_book/domain/use_case/get_report.dart';
import 'package:lello/feature/reports_book/domain/use_case/get_reports.dart';
import 'package:lello/feature/reports_book/domain/use_case/put_report_attachment.dart';
import 'package:lello/feature/reports_book/domain/use_case/put_report_content.dart';
import 'package:lello/feature/reports_book/presentation/bloc/reports_bloc.dart';
import 'package:lello/feature/reports_book/presentation/bloc/reports_event.dart';
import 'package:lello/feature/reports_book/presentation/bloc/reports_state.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/unit/domain/entity/unit_simple.dart';
import 'package:lello/feature/unit/domain/use_case/list_units/list_simple_units_usecase.dart';

import '../../domain/entity/report_filters_types_enum.dart';

class ReportController {
  final ReportsBloc reportsBloc;
  final SessionBloc sessionBloc;
  final ListUnitSimpleUsecase listUnitSimpleUsecase;
  final GetReportsUseCase getReportsUseCase;
  final GetReportUseCase getReportUseCase;
  final PutReportAttachmentUseCase putReportAttachmentUseCase;
  final PutReportContentUseCase putReportContentUseCase;
  final CloseReportUseCase closeReportUseCase;
  DateTime? dateUtil;
  List<String> units = [];
  List<UnitSimple> allUnits = [];
  List<Report> reports = [];
  ReportContents? reportContents;
  Report? newReports;
  File? attachmentFile;
  String? attachmentType;
  String? content;
  int currentPage = 0;
  ReportController({
    required this.reportsBloc,
    required this.sessionBloc,
    required this.listUnitSimpleUsecase,
    required this.getReportsUseCase,
    required this.getReportUseCase,
    required this.putReportAttachmentUseCase,
    required this.putReportContentUseCase,
    required this.closeReportUseCase,
  });

  Future<void> getUnitsForFilter() async {
    final condominiumId = sessionBloc.state.session!.selectedCondominium!.id;
    final result = await listUnitSimpleUsecase(
      ListUnitSimpleParam(condominiumId: condominiumId),
    );
    result.fold((failure) => failure, (unitsFilter) {
      allUnits = unitsFilter;
      units = unitsFilter.map((unit) => unit.title).toList();
    });
  }

  Future<void> getReports({required ReportFilter filter}) async {
    // final filter = filter;
    // var data = state.data;
    ReportFilterModel reportFilterModel;
    reportFilterModel = ReportFilterModel.fromEntity(filter)!;

    reportsBloc.add(ReportsLoadingEvent());
    getUnitsForFilter();

    //Allows searching a list of Reports of the same date without passing time parameters
    if (reportFilterModel.dateTo != null) {
      dateUtil = reportFilterModel.dateTo!.add(
        const Duration(days: 1),
      );
      reportFilterModel.dateTo = dateUtil;
    }

    final response = await getReportsUseCase.call(
      GetReportsParams(reportFilterModel: reportFilterModel, page: 1),
    );

    response.fold(
      (error) => reportsBloc.add(ReportsFailureEvent(failure: error)),
      (res) {
        currentPage = res.meta!.currentPage! + 1;
        if (filter.showOnlyNewReports == true) {
          res.report!.removeWhere((element) => element.newMessage == false);
        }
        if (filter.showOnlyReplies == true) {
          res.report!.removeWhere((element) =>
              element.newMessage == false && element.reportContents!.isEmpty);
        }

        reports = res.report ?? [];
        return reportsBloc.add(ReportsLoadedEvent(
            reports: res.report ?? [],
            units: units,
            donePaging: res.report!.isEmpty));
      },
    );
  }

  Future<void> getNextPage({required ReportFilter filter}) async {
    reportsBloc.add(ReportsPagingEvent());
    ReportFilterModel reportFilterModel;
    reportFilterModel = ReportFilterModel.fromEntity(filter)!;

    //Allows searching a list of Reports of the same date without passing time parameters
    if (reportFilterModel.dateTo != null) {
      dateUtil = reportFilterModel.dateTo!.add(
        const Duration(days: 1),
      );
      reportFilterModel.dateTo = dateUtil;
    }
    final response = await getReportsUseCase.call(
      GetReportsParams(reportFilterModel: reportFilterModel, page: currentPage),
    );

    response.fold(
      (error) {
        reportsBloc.add(ReportsFailureEvent(failure: error));
      },
      (res) {
        if (res.report!.isEmpty) {
          return reportsBloc.add(ReportsLoadedEvent(
              reports: reports, units: units, donePaging: false));
        } else {
          currentPage = res.meta!.currentPage! + 1;
          if (filter.showOnlyNewReports == true) {
            res.report!.removeWhere((element) => element.newMessage == false);
          }
          if (filter.showOnlyReplies == true) {
            res.report!.removeWhere((element) =>
                element.newMessage == false && element.reportContents!.isEmpty);
          }
          reports = reports + res.report!;
          return reportsBloc.add(ReportsLoadedEvent(
              reports: reports, units: units, donePaging: false));
        }
      },
    );
  }

  Future<void> getReport({required Report report}) async {
    reportsBloc.add(
      ReportLoadingEvent(),
    );

    final response = await getReportUseCase(GetReportParams(
      unitId: report.unit!.id!,
      reportId: report.idReport!,
    ));

    response.fold(
      (error) => reportsBloc.add(ReportsFailureEvent(failure: error)),
      (res) {
        reportsBloc.add(SeeReportDetailsEvent(report: res));
      },
    );
  }

  Future<void> sendReplyReport(
      {required Report report, required ReportContents content}) async {
    reportsBloc.add(
      ReportLoadingEvent(),
    );

    ContentSendModel contentSend =
        ContentSendModel(idReport: report.idReport, content: content.content);

    final response = await putReportContentUseCase(PutReportContentParams(
      reportId: report.idReport!,
      content: contentSend,
    ));

    response.fold(
      (error) => reportsBloc.add(ReportsFailureEvent(failure: error)),
      (res) async {
        res;
        if (content.attachmentFile != null) {
          final responseAtt = await putReportAttachmentUseCase(
              PutReportAttachmentParams(
                  contentId: res.reportContents!.first.id!,
                  file: content.attachmentFile!));
          responseAtt.fold(
            (error) => reportsBloc.add(
              ReportsFailureEvent(failure: error),
            ),
            (r) => reportsBloc.add(
              ReportPostedEvent(),
            ),
          );
        } else {
          String reference = sessionBloc
                  .state.session!.selectedCondominium?.reference
                  .toString() ??
              "";
          ManagerAnalyticsLogEvents.logEvent(
              event: AnalyticsEventsManager.ocorrenciasResponderFinalizado(),
              referenceValue: reference);
          reportsBloc.add(
            ReportPostedEvent(),
          );
        }
      },
    );
  }

  Future<void> closeReport({required Report report}) async {
    reportsBloc.add(
      ReportLoadingEvent(),
    );

    final response = await closeReportUseCase(CloseReportParams(
      reportId: report.idReport!,
    ));

    response.fold(
      (error) => reportsBloc.add(ReportsFailureEvent(failure: error)),
      (res) {
        reportsBloc.add(ReportClosedEvent());
      },
    );
  }

  Future<void> chooseImage(
      {required ImageSource imageSource, required BuildContext context}) async {
    ImagePicker imagePicker = ImagePicker();
    var image = await imagePicker.pickImage(
        source: imageSource, maxHeight: 1000.0, maxWidth: 1000.0);
    if (image != null) {
      CroppedFile? croppedFile = await showImageCropper(image.path);
      if (croppedFile == null) return;

      attachmentFile = File(croppedFile.path);
      attachmentType = "image";

      reportContents?.attachmentFile = attachmentFile;
      reportContents?.attachmentType = attachmentType;
      if (reportContents != null) {
        reportsBloc.add(
            SendReportEvent(content: reportContents!, report: newReports!));
      }
    }
  }

  Future<void> chooseFile() async {
    var file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf"],
      allowMultiple: false,
    );

    if (file != null) {
      attachmentFile = File(file.files.first.path!);
      attachmentType = "application/pdf";

      reportContents?.attachmentFile = attachmentFile;
      reportContents?.attachmentType = attachmentType;
      if (reportContents != null) {
        reportsBloc.add(
            SendReportEvent(content: reportContents!, report: newReports!));
      }
    }
  }

  void beginLoadNextPage({required ReportFilter filter}) {
    final current = reportsBloc.state;
    if (current is! ReportsLoadingState && current is! ReportsPagingState) {
      if (current is ReportsLoadedState && current.donePaging) return;
      getNextPage(filter: filter);
    }
  }

  void dispose() {
    ReportFilter();
    currentPage = 0;
    dateUtil = null;
    units = [];
    allUnits = [];
    reports = [];
    reportContents = ReportContents();
    newReports = Report();
    attachmentFile = null;
    attachmentType = null;
    content = null;
  }

  void seeReportDetails({required Report report}) {
    reportsBloc.add(SeeReportDetailsEvent(report: report));
  }

  void previewReply({required Report report, required ReportContents content}) {
    reportsBloc.add(PreviewReplyEvent(report: report, content: content));
  }

  void replyReport({required Report report, required ReportContents? content}) {
    ReportContents replyReport;

    if (content != null) {
      replyReport = content;
    } else {
      replyReport = ReportContents(
        dateContent: DateTime.now(),
        typeUser: TypeUser.sindico.index,
      );
    }

    reportsBloc.add(SendReportEvent(
      report: report,
      content: replyReport,
    ));
  }

  String getTypeReportText({required ReportFilterTypes type}) {
    switch (type) {
      case ReportFilterTypes.period:
        return "reports_filter_selected_period";
      case ReportFilterTypes.subject:
        return "reports_filter_selected_subject";
      case ReportFilterTypes.status:
        return "reports_filter_selected_status";
      case ReportFilterTypes.unit:
        return "reports_filter_selected_unit";
      case ReportFilterTypes.newReports:
        return "reports_filter_selected_new_reports";
      case ReportFilterTypes.newReplies:
        return "reports_filter_selected_new_replies";
      default:
        return "";
    }
  }

  String? getTypeReportSelected(
      {required ReportFilterTypes type, required ReportFilter filter}) {
    switch (type) {
      case ReportFilterTypes.period:
        return filter.getPeriodReport();
      case ReportFilterTypes.status:
        return filter.getStatusReport();
      case ReportFilterTypes.subject:
        return filter.getTypeReport();
      case ReportFilterTypes.unit:
        return filter.getUnidId();
      default:
        return null;
    }
  }
}
