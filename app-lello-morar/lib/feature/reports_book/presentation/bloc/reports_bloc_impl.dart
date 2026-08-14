

// class ReportsBlocImpl extends ReportsBloc {
//   final GetAllReportsUseCase getAllReportsUseCase;
//   final GetReportUseCase getReportUseCase;
//   final PostNewReportUseCase postNewReportUseCase;
//   final PutReportContentUseCase putReportContentUseCase;
//   final PutReportAttachmentUseCase putReportAttachmentUseCase;

//   final SessionBloc sessionBloc;
//   StreamSubscription? _subscription;

//   ReportsBlocImpl({
//     required this.getAllReportsUseCase,
//     required this.postNewReportUseCase,
//     required this.getReportUseCase,
//     required this.putReportContentUseCase,
//     required this.putReportAttachmentUseCase,
//     required this.sessionBloc,
//   }) : super(ReportsEmptyState()) {
//     if (this.sessionBloc.state is SessionLoadedState) {
//       _onSessionChanged(this.sessionBloc.state);
//     } else {
//       _subscription = this.sessionBloc.stream.listen(_onSessionChanged);
//     }
//   }

//   @override
//   Future<void> close() {
//     _subscription?.cancel();
//     return super.close();
//   }

  // @override
  // Stream<ReportsState> mapEventToState(ReportsEvent event) async* {
  //   // if (event is GetAllReportsEvent) yield* _mapGetAllReports(event);

  //   // if (event is CreateNewReportEvent) yield* _mapCreateNewReport(event);
  //   // if (event is PreviewReportEvent) yield* _mapPreviewReport(event);
  //   // if (event is GetReportEvent) yield* _mapGetReport(event);
  //   // if (event is PostNewReportEvent) yield* _mapPostNewReport(event);
  //   // if (event is SeeReportDetailsEvent) yield* _mapSeeReportDetails(event);
  //   // if (event is ReplyReportEvent) yield* _mapReplyReport(event);
  //   // if (event is SendReplyReportEvent) yield* _mapSendReplyReport(event);
  //   // if (event is ReportsBookFirstEvent) yield* _mapReportsBookFirst(event);

  //   // if (event is NewReportEventChooseImageEvent)
  //   //   yield* _mapChooseImageEvent(event);
  //   // if (event is NewReportEventChooseFile) yield* _mapChooseFileEvent(event);
  // }

  // Stream<ReportsState> _mapGetAllReports(GetAllReportsEvent event) async* {
  //   yield ReportsLoadingState();

  //   final response = await getAllReportsUseCase.call(GetAllReportsParams(
  //     unitId: sessionBloc.state.session!.unity!.id!,
  //   ));

  //   var result = response.fold(
  //     (error) => ReportsFailureState(),
  //     (data) {
  //       return ReportsLoadedState(
  //         allReports: data,
  //       );
  //     },
  //   );

  //   if (result is ReportsLoadedState) {
  //     OwnerAnalyticsLogEvents.logEvent(
  //       event: AnalyticsEventsOwner.ocorrenciasMinhasOcorrencias(),
  //       unitValue: sessionBloc.state.session!.unity?.title.toString() ?? "",
  //       referenceValue:
  //           sessionBloc.state.session!.condominium?.reference?.toString() ?? "",
  //     );
  //   }
  //   yield result;
  // }

  // Stream<ReportsState> _mapGetReport(GetReportEvent event) async* {
  //   var curentState = state;
  //   List<Report> allReports;

  //   if (curentState is ReportsLoadedState) {
  //     allReports = curentState.allReports;
  //     yield ReportsLoadingState(report: event.report);

  //     final response = await getReportUseCase.call(GetReportParams(
  //       unitId: sessionBloc.state.session!.unity!.id!,
  //       reportId: event.report.idReport!,
  //     ));

  //     var result = response.fold(
  //       (error) => ReportsGetReportFailureState(allReports: allReports),
  //       (data) {
  //         data.newMessage = event.report.newMessage;
  //         return SeeReportDetailsState(
  //           report: data,
  //         );
  //       },
  //     );

  //     yield result;
  //   }
  // }

  // Stream<ReportsState> _mapCreateNewReport(CreateNewReportEvent event) async* {
  //   if (event.report == null) {
  //     event.report = Report(
  //       dateReport: DateTime.now(),
  //       reportContents: [],
  //     );
  //   }
  //   if (event.content == null) {
  //     event.content = ReportContents(
  //       dateContent: DateTime.now(),
  //       typeUser: TypeUser.morador.index,
  //     );
  //   }
  //   yield SendReportState(report: event.report!, content: event.content!);
  // }

  // Stream<ReportsState> _mapPreviewReport(PreviewReportEvent event) async* {
  //   yield PreviewReportState(
  //       report: event.report,
  //       content: event.content,
  //       attachment: event.attachment);
  // }

  // Stream<ReportsState> _mapReportsBookFirst(
  //     ReportsBookFirstEvent event) async* {
  //   yield ReportsBookFirstState();
  // }

  // Stream<ReportsState> _mapSeeReportDetails(
  //     SeeReportDetailsEvent event) async* {
  //   yield SeeReportDetailsState(report: event.report);
  // }

  // Stream<ReportsState> _mapReplyReport(ReplyReportEvent event) async* {
  //   yield SendReportState(report: event.report, content: event.replyReport);
  // }

  // Stream<ReportsState> _mapSendReplyReport(SendReplyReportEvent event) async* {
  //   yield ReportsLoadingState(report: event.report);

  //   ContentSendModel contentSend = ContentSendModel(
  //       idReport: event.report.idReport, content: event.content.content);

  //   final response = await putReportContentUseCase.call(PutReportContentParams(
  //     reportId: event.report.idReport!,
  //     content: contentSend,
  //   ));

  //   var result = response.fold(
  //     (error) => NewReplyReportsFailureState(
  //         content: event.content,
  //         CurrentReport: event.report,
  //         attachment: event.attachment),
  //     (data) {
  //       return data;
  //     },
  //   );

  //   if (result is ReportsFailureState) {
  //     yield result;
  //     return;
  //   }

  //   if (result is Report) {
  //     if (event.attachment != null) {
  //       final responseAtt = await putReportAttachmentUseCase.call(
  //           PutReportAttachmentParams(
  //               contentId: result.reportContents!.first.id!,
  //               file: event.attachment!));
  //       responseAtt.fold(
  //           (l) => NewReplyReportsFailureState(
  //               content: event.content,
  //               CurrentReport: event.report,
  //               attachment: event.attachment),
  //           (r) => ReportPostedState(report: result));
  //     } else {
  //       yield ReportPostedState(
  //         report: result,
  //       );
  //     }
  //     yield ReportPostedState(
  //       report: result,
  //     );
  //   }
  // }

  // Stream<ReportsState> _mapPostNewReport(PostNewReportEvent event) async* {
  //   yield ReportsLoadingState();

  //   final response = await postNewReportUseCase
  //       .call(PostNewReportParams(reportCreateModel: event.reportCreateModel));
  //   var result = response.fold(
  //     (error) => NewReportsFailureState(
  //         content: event.content,
  //         report: event.report,
  //         attachment: event.attachment),
  //     (data) {
  //       return data;
  //     },
  //   );

  //   if (result is ReportsFailureState) {
  //     yield result;
  //     return;
  //   }

  //   if (result is Report) {
  //     if (event.attachment != null) {
  //       final responseAtt = await putReportAttachmentUseCase.call(
  //           PutReportAttachmentParams(
  //               contentId: result.reportContents!.first.id!,
  //               file: event.attachment!));
  //       //TODO: Verificar se vale criar um state exclusivo para erro de anexo pois ocorrencia foi criada, só anexo que não
  //       responseAtt.fold(
  //           (l) => NewReportsFailureState(
  //               content: event.content,
  //               report: event.report,
  //               attachment: event.attachment),
  //           (r) => ReportPostedState(report: result));
  //     }
  //     OwnerAnalyticsLogEvents.logEvent(
  //       event: AnalyticsEventsOwner.ocorrenciasRegistrarNovaOcorrenciaSucesso(),
  //       unitValue: sessionBloc.state.session!.unity?.title.toString() ?? "",
  //       referenceValue:
  //           sessionBloc.state.session!.condominium?.reference?.toString() ?? "",
  //     );
  //     yield ReportPostedState(report: result);
  //   }
  // }

  // Stream<ReportsState> _mapChooseImageEvent(
  //     NewReportEventChooseImageEvent event) async* {
  //   ImagePicker imagePicker = ImagePicker();
  //   var image = await imagePicker.pickImage(
  //       source: event.source, maxHeight: 1000.00, maxWidth: 1000.00);
  //   if (image != null) {
  //     CroppedFile? croppedFile = await showImageCropper(image.path);

  //     if (croppedFile != null) {
  //       event.content.attachmentFile = File(croppedFile.path);
  //       event.content.attachmentType = "image";
  //       yield SendReportState(
  //         report: event.newReport,
  //         content: event.content,
  //       );
  //     }
  //   }
  // }

  // Stream<ReportsState> _mapChooseFileEvent(
  //     NewReportEventChooseFile event) async* {
  //   var file = await FilePicker.platform.pickFiles(
  //       type: FileType.custom,
  //       allowedExtensions: ["pdf"],
  //       allowMultiple: false);

  //   if (file != null && file.count > 0) {
  //     if (CheckFile.isFileExceedMaxSizePermitted(
  //         file: File(file.files.first.path!))) {
  //       event.content.attachmentFile = null;
  //       event.content.attachmentType = null;
  //       yield SendReportState(
  //           report: event.newReport,
  //           content: event.content,
  //           flushbarMessage: "document_size_exceeds_limit");
  //       return;
  //     }
  //     if (await CheckFile.isFileEncrypted(file: File(file.files.first.path!))) {
  //       event.content.attachmentFile = null;
  //       event.content.attachmentType = null;
  //       yield SendReportState(
  //           report: event.newReport,
  //           content: event.content,
  //           flushbarMessage: "document_protected_or_encrypted");
  //       return;
  //     }
  //     event.content.attachmentFile = File(file.files.first.path!);
  //     event.content.attachmentType = "application/pdf";
  //     yield SendReportState(
  //       report: event.newReport,
  //       content: event.content,
  //     );
  //   }
  // }

  // void _onSessionChanged(SessionState sessionState) {
  //   if (sessionState is SessionLoadedState) {
  //     add(ReportsBookFirstEvent());
  //   }
  // }

  // @override
  // void showFirstEvent() {
  //   add(ReportsBookFirstEvent());
  // }

  // @override
  // void showMyReports([Report? value]) {
  //   add(GetAllReportsEvent());
  // }

  // @override
  // void createNewReport(
  //     {Report? report, ReportContents? content, File? attachment}) {
  //   add(CreateNewReportEvent(
  //       report: report, content: content, attachment: attachment));
  // }

  // @override
  // void previewReport(
  //     {required Report report,
  //     required ReportContents content,
  //     File? attachment}) {
  //   add(PreviewReportEvent(
  //       report: report, content: content, attachment: attachment));
  // }

  // @override
  // void getReport(Report report) {
  //   add(GetReportEvent(report: report));
  // }

  // @override
  // void seeReportDetails(Report report) {
  //   add(SeeReportDetailsEvent(report: report));
  // }

  // @override
  // void replyReport(Report report, [ReportContents? replyReport]) {
  //   if (replyReport == null)
  //     replyReport = ReportContents(
  //       dateContent: DateTime.now(),
  //       typeUser: TypeUser.morador.index,
  //     );
  //   add(ReplyReportEvent(
  //     report: report,
  //     replyReport: replyReport,
  //   ));
  // }

  // @override
  // void sendReplyReport(Report report, ReportContents content) {
  //   add(SendReplyReportEvent(
  //       report: report, content: content, attachment: content.attachmentFile));
  // }

  // @override
  // void postNewReport(Report report, ReportContents content) {
  //   ReportCreateModel reportCreateModel = ReportCreateModel(
  //     content: content.content,
  //     dateReport: DateTime.now(),
  //     typeReport: report.typeReport,
  //     idUnit: sessionBloc.state.session!.unity!.id,
  //     public: content.public ?? true,
  //   );
  //   File? attachment = content.attachmentFile;
  //   add(PostNewReportEvent(
  //       reportCreateModel: reportCreateModel,
  //       attachment: attachment,
  //       report: report,
  //       content: content));
  // }

  // @override
  // void beginPickImage(
  //   Report report,
  //   ReportContents content,
  // ) {
  //   add(NewReportEventChooseImageEvent(ImageSource.gallery, report, content));
  // }

  // @override
  // void beginTakePhoto(
  //   Report report,
  //   ReportContents content,
  // ) {
  //   add(
  //     NewReportEventChooseImageEvent(ImageSource.camera, report, content),
  //   );
  // }

  // @override
  // void beginTakeFile(Report newReport, ReportContents content) {
  //   add(NewReportEventChooseFile(newReport, content));
  // }

  // @override
  // bool checkRbac(String rbac) {
  //   return sessionBloc.checkRback(rbac);
  // }

  // @override
  // void getAllReports() {
  //   add(GetAllReportsEvent());
  // }
//}
