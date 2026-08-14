import 'dart:io';

import 'package:essentials/analytics/events/analytics_events_owner.dart';
import 'package:essentials/essentials.dart';
import 'package:morar/core/analytics/analytics_log_events.dart';
import 'package:morar/feature/reports_book/data/model/content_send_model.dart';
import 'package:morar/feature/reports_book/data/model/report_create_model.dart';
import 'package:morar/feature/reports_book/domain/entity/report.dart';
import 'package:morar/feature/reports_book/domain/entity/report_contents.dart';
import 'package:morar/feature/reports_book/domain/entity/report_type_user.dart';
import 'package:morar/feature/reports_book/domain/use_case/get_all_reports.dart';
import 'package:morar/feature/reports_book/domain/use_case/get_report.dart';
import 'package:morar/feature/reports_book/domain/use_case/post_new_report.dart';
import 'package:morar/feature/reports_book/domain/use_case/put_report_attachment.dart';
import 'package:morar/feature/reports_book/domain/use_case/put_report_content.dart';
import 'package:morar/feature/reports_book/presentation/bloc/reports_bloc.dart';
import 'package:morar/feature/reports_book/presentation/bloc/reports_event.dart';
import 'package:morar/feature/reports_book/presentation/bloc/reports_state.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';

class ReportsController {
  final SessionBloc sessionBloc;
  final ReportsBloc reportsBloc;
  final GetAllReportsUseCase getAllReportsUseCase;
  final GetReportUseCase getReportUseCase;
  final PostNewReportUseCase postNewReportUseCase;
  final PutReportContentUseCase putReportContentUseCase;
  final PutReportAttachmentUseCase putReportAttachmentUseCase;
  ReportsController(
      {required this.sessionBloc,
      required this.reportsBloc,
      required this.getAllReportsUseCase,
      required this.getReportUseCase,
      required this.postNewReportUseCase,
      required this.putReportContentUseCase,
      required this.putReportAttachmentUseCase});

  Future<void> getAllReports() async {
    reportsBloc.add(ReportsLoadingEvent());

    print(sessionBloc.state.session!.unity!.id!);
    final response = await getAllReportsUseCase.call(
      GetAllReportsParams(
        unitId: sessionBloc.state.session!.unity!.id!,
      ),
    );
    response.fold(
      (error) => reportsBloc.add(
        ReportsFailureEvent(),
      ),
      (data) {
        OwnerAnalyticsLogEvents.logEvent(
          event: AnalyticsEventsOwner.ocorrenciasMinhasOcorrencias(),
          userId: sessionBloc.state.session?.me?.id ?? "",
          unitValue: sessionBloc.state.session!.unity?.title.toString() ?? "",
          referenceValue:
              sessionBloc.state.session!.condominium?.reference?.toString() ??
                  "",
        );
        return reportsBloc.add(
          ReportsLoadedEvent(allReports: data),
        );
      },
    );
  }

  Future<void> getReport({required Report report}) async {
    var curentState = reportsBloc.state;
    List<Report> allReports;
    if (curentState is ReportsLoadedState) {
      allReports = curentState.allReports;
      reportsBloc.add(
        ReportsLoadingEvent(report: report),
      );

      final response = await getReportUseCase.call(
        GetReportParams(
          unitId: sessionBloc.state.session!.unity!.id!,
          reportId: report.idReport!,
        ),
      );
      response.fold(
        (error) => reportsBloc.add(
          ReportsGetReportFailureEvent(allReports: allReports, failure: error),
        ),
        (data) {
          data.newMessage = report.newMessage;
          return reportsBloc.add(
            SeeReportDetailsEvent(report: data),
          );
        },
      );
    }
  }

  Future<void> createNewReport(
      {Report? report, ReportContents? content, File? attachment}) async {
    if (report == null) {
      report = Report(
        dateReport: DateTime.now(),
        reportContents: [],
      );
    }
    if (content == null) {
      content = ReportContents(
        dateContent: DateTime.now(),
        typeUser: TypeUser.morador.index,
      );
    }
    return reportsBloc.add(
      SendReportEvent(report: report, content: content),
    );
  }

  Future<void> seeReportDetails(Report report) async {
    return reportsBloc.add(
      SeeReportDetailsEvent(report: report),
    );
  }

  Future<void> previewReport(
      {required Report report,
      required ReportContents content,
      File? attachment}) async {
    return reportsBloc.add(
      PreviewReportEvent(
          report: report, content: content, attachment: attachment),
    );
  }

  Future<void> showFirstEvent() async {
    return reportsBloc.add(
      ReportsBookFirstEvent(),
    );
  }

  Future<void> replyReport(Report report, [ReportContents? replyReport]) async {
    if (replyReport == null)
      replyReport = ReportContents(
        dateContent: DateTime.now(),
        typeUser: TypeUser.morador.index,
      );

    return reportsBloc.add(
      SendReportEvent(
        report: report,
        content: replyReport,
      ),
    );
  }

  Future<void> sendReplyReport(Report report, ReportContents content) async {
    reportsBloc.add(ReportsLoadingEvent(report: report));
    ContentSendModel contentSend =
        ContentSendModel(idReport: report.idReport, content: content.content);

    final response = await putReportContentUseCase.call(
      PutReportContentParams(reportId: report.idReport!, content: contentSend),
    );

    response.fold(
      (error) => reportsBloc.add(
        NewReplyReportsFailureEvent(
            content: content,
            CurrentReport: report,
            attachment: content.attachmentFile,
            failure: error),
      ),
      (data) async {
        if (content.attachmentFile != null) {
          await putAttachment(data, content, content.attachmentFile!, false);
        } else if (data is ReportsFailureState) {
          return;
        } else {
          reportsBloc.add(ReportPostedEvent(report: data));
        }
      },
    );
  }

  Future<void> postNewReport(Report report, ReportContents content) async {
    reportsBloc.add(ReportsLoadingEvent(report: report));
    ReportCreateModel reportCreateModel = ReportCreateModel(
        content: content.content,
        dateReport: DateTime.now(),
        typeReport: report.typeReport,
        idUnit: sessionBloc.state.session!.unity!.id,
        public: content.public ?? true);

    final response = await postNewReportUseCase.call(
      PostNewReportParams(reportCreateModel: reportCreateModel),
    );

    response.fold(
      (error) => reportsBloc.add(
        NewReportsFailureEvent(
            report: report,
            content: content,
            attachment: content.attachmentFile,
            failure: error),
      ),
      (data) async {
        if (content.attachmentFile != null) {
          await putAttachment(data, content, content.attachmentFile!, false);
        } else {
          reportsBloc.add(ReportPostedEvent(report: data));
        }
        OwnerAnalyticsLogEvents.logEvent(
          event:
              AnalyticsEventsOwner.ocorrenciasRegistrarNovaOcorrenciaSucesso(),
          userId: sessionBloc.state.session?.me?.id ?? "",
          unitValue: sessionBloc.state.session!.unity?.title.toString() ?? "",
          referenceValue:
              sessionBloc.state.session!.condominium?.reference?.toString() ??
                  "",
        );
      },
    );
  }

  Future<void> beginPickImage(
      {required ImageSource source,
      required Report report,
      required ReportContents content}) async {
    ImagePicker imagePicker = ImagePicker();
    var image = await imagePicker.pickImage(
        source: source, maxHeight: 1000.00, maxWidth: 1000.00);
    if (image != null) {
      CroppedFile? croppedFile = await showImageCropper(image.path);

      if (croppedFile != null) {
        content.attachmentFile = File(croppedFile.path);
        content.attachmentType = "image";

        return reportsBloc.add(
          SendReportEvent(report: report, content: content),
        );
      }
    }
  }

  Future<void> beginTakeFile(
      {required Report newReport, required ReportContents content}) async {
    var file = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ["pdf"],
        allowMultiple: false);

    if (file != null && file.count > 0) {
      if (CheckFile.isFileExceedMaxSizePermitted(
        file: File(file.files.first.path!),
      )) {
        content.attachmentFile = null;
        content.attachmentType = null;

        return reportsBloc.add(
          SendReportEvent(
              report: newReport,
              content: content,
              flushbarMessage: "document_size_exceeds_limit"),
        );
      }
      if (await CheckFile.isFileEncrypted(file: File(file.files.first.path!))) {
        content.attachmentFile = null;
        content.attachmentType = null;

        return reportsBloc.add(
          SendReportEvent(
              report: newReport,
              content: content,
              flushbarMessage: "document_protected_or_encrypted"),
        );
      }
      content.attachmentFile = File(file.files.first.path!);
      content.attachmentType = "application/pdf";

      return reportsBloc.add(
        SendReportEvent(report: newReport, content: content),
      );
    }
  }

  Future<void> putAttachment(Report report, ReportContents content,
      File attachment, bool isLoading) async {
    if (isLoading) {
      reportsBloc.add(
        ReportsLoadingEvent(),
      );
    }
    final responseAtt = await putReportAttachmentUseCase.call(
      PutReportAttachmentParams(
        contentId: report.reportContents!.first.id!,
        file: attachment,
      ),
    );
    responseAtt.fold(
      (error) => reportsBloc.add(
        AttachmentReportsFailureEvent(
            report: report,
            content: content,
            attachment: attachment,
            failure: error),
      ),
      (data) => reportsBloc.add(
        ReportPostedEvent(report: report),
      ),
    );
  }
}
