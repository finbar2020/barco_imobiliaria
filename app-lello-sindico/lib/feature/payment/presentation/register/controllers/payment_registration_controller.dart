import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:essentials/analytics/analytics_log_events.dart';
import 'package:essentials/analytics/analytics_timer.dart';
import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:essentials/modal/image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/modal/semaphore.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/payment/domain/entity/payment_screens.dart';
import 'package:lello/feature/payment/domain/entity/process_files_response.dart';
import 'package:lello/feature/payment/domain/entity/send_documents_status.dart';
import 'package:lello/feature/payment/domain/use_case/aws_get_url/aws_get_url_impl.dart';
import 'package:lello/feature/payment/domain/use_case/send_documents/send_documents.dart';
import 'package:lello/feature/payment/domain/use_case/upload_documents_aws/upload_documents.dart';
import 'package:lello/feature/payment/presentation/register/page/payment_illegible_document_page.dart';
import 'package:lello/feature/payment/presentation/register/page/payment_review_document_page.dart';
import 'package:lello/feature/payment/presentation/register/widget/payment_different_cnpj_error_bottomsheet.dart';
import 'package:lello/feature/payment/presentation/register/widget/payment_max_files_error_dialog.dart';
import 'package:lello/feature/payment/presentation/register/widget/payment_two_different_cnpj_error_bottomsheet.dart';
import 'package:lello/feature/payment/presentation/register_form/page/register_form_page.dart';
import 'package:lello/feature/payment/presentation/register_form/page/steps/04_send_payment/widgets/send_payment_generic_error.dart';
import 'package:lello/feature/payment/presentation/register_form/page/steps/04_send_payment/widgets/send_payment_timeout_error.dart';
import 'package:lello/feature/payment/presentation/send_financial_department/page/payment_send_financial_department_page.dart';
import 'package:shared_features/shared_features.dart';

import '../../../../account/domain/entity/account.dart';
import '../../../../session/presentation/bloc/session_bloc.dart';
import '../bloc/payment_registration_bloc.dart';
import '../bloc/payment_registration_event.dart';

class PaymentRegistrationController {
  final AwsGetUrl getUrlUseCase;
  final UploadDocuments uploadDocumentsUseCase;
  final SendDocuments sendDocumentsUseCase;
  final GetToken getToken;

  final SessionBloc sessionBloc;
  final PaymentSendDocumentBloc bloc;

  PageController pageController = PageController(initialPage: 0);

  List<Account> accounts = [];
  List<File> files = [];
  AppOriginEnum appOriginEnum = AppOriginEnum.manager;

  ProcessFilesResponseEntity? tempProcessData;
  late AnalyticsTimer sendPaymentTimer;

  PaymentRegistrationController({
    required this.getUrlUseCase,
    required this.uploadDocumentsUseCase,
    required this.sendDocumentsUseCase,
    required this.sessionBloc,
    required this.bloc,
    required this.getToken,
  });

  void navigateToPaymentMainAndClearStack(
      BuildContext context, PaymentScreens tela) {
    sendPaymentAnalyticsTimerStop();
    backArrowAnalyticsLog(tela);
    Navigator.of(context).pushNamedAndRemoveUntil(
        ApplicationRoute.payment, ModalRoute.withName(ApplicationRoute.home));
  }

  //TODO: Tentar implementar Pool no lugar de Semaphore (algoritmo já feito mas não testado ainda)
  Future<List<Try<String>>> uploadMultipleFiles(
    String condoId,
    List<File> files,
  ) async {
    final results = <Try<String>>[];
    const int maxConcurrentUploads = 3;
    final semaphore = Semaphore(maxConcurrentUploads);

    final tasks = files.map((file) async {
      await semaphore.acquire();
      try {
        final urlResult =
            await getUrlUseCase.call(AwsGetUrlParams(condoId: condoId));
        final uploadUrl = urlResult.fold(
          (failure) {
            results.add(Rejection(failure));
            return null;
          },
          (url) => url.url,
        );

        if (uploadUrl != null) {
          final uploadResult = await uploadDocumentsUseCase.call(
            UploadDocumentsParams(url: uploadUrl, file: file),
          );
          results.add(uploadResult);
        }
      } catch (e) {
        results.add(Rejection(UnknownFailure(e)));
      } finally {
        semaphore.release();
      }
    }).toList();

    await Future.wait(tasks);
    return results;
  }

  Future<void> sendDocuments(BuildContext context) async {
    final condoId = condominiumId;
    final files = this.files;

    if (files.isEmpty) {
      return;
    }

    final results = await uploadMultipleFiles(condoId, files);

    final successUrls = results
        .whereType<Success<String>>()
        .map((result) => result.get())
        .toList();

    final rejectionErrors = results.whereType<Rejection>().toList();

    if (successUrls.isNotEmpty) {
      final result = await sendDocumentsUseCase.call(
        SendDocumentsParams(condoId: condoId, fileUrls: successUrls),
      );
      result.fold(
        (failure) {
          _handleProcessApiErrorResponse(
            context,
            "DESCONHECIDO",
            "Problema desconhecido ao enviar documentos",
          );
        },
        (sendFilesResponse) {
          tempProcessData = sendFilesResponse;
          if (sendFilesResponse.success) {
            _handleProcessApiSuccess(context);
          } else {
            final SendDocumentsStatus responseStatusEnum =
                parseSendDocumentsStatus(sendFilesResponse.status);
            switch (responseStatusEnum) {
              case SendDocumentsStatus.validacaoReferenciaCnpjCondoDiferente:
                _showCnpjErrorBottomSheet(context);
                break;
              case SendDocumentsStatus.validacaoCnpjFornecedor:
                _showTwoDifferentCnpjErrorBottomSheet(context);
                break;
              case SendDocumentsStatus.semRetornoExtracao ||
                    SendDocumentsStatus.erroExtracaoCnpjFornecedorCondominio ||
                    SendDocumentsStatus.erroExtracaoCnpjCondominio ||
                    SendDocumentsStatus.documentoIlegivel:
                _handleIllegibleDocumentError(context);
                break;
              case SendDocumentsStatus.timeout:
                _handleProcessApiErrorTimeOutResponse(
                    context, sendFilesResponse.status, "Timeout");
                break;
              default:
                _handleProcessApiErrorResponse(
                  context,
                  sendFilesResponse.status,
                  sendFilesResponse.message ?? "Erro desconhecido",
                );
            }
          }
        },
      );
    }

    if (rejectionErrors.isNotEmpty) {
      _handleProcessApiErrorResponse(
        context,
        "Upload Error",
        "Erro desconhecido: ${rejectionErrors.first.toString()}",
      );
    }
  }

  void _handleIllegibleDocumentError(BuildContext context) {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => const PaymentIllegibleDocumentPage(),
    );
    Navigator.of(context).pushReplacement(route);
  }

  void _handleProcessApiErrorTimeOutResponse(
      BuildContext context, String status, String errorMessage) {
    var theme = Theme.of(context);
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: PrimaryAppBar(
          title: getString(context, "register_payment_title"),
          theme: theme,
          iconColor: theme.primaryColor,
        ),
        body: SendPaymentTimeoutError(
          tryAgain: () {
            Navigator.of(context)
                .pushReplacementNamed(ApplicationRoute.paymentProcessingFiles);
          },
          backToPayment: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
    Navigator.of(context).pushReplacement(route);
  }

  void _handleProcessApiErrorResponse(
      BuildContext context, String status, String errorMessage) {
    var theme = Theme.of(context);
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: PrimaryAppBar(
          title: getString(context, "register_payment_title"),
          theme: theme,
          iconColor: theme.primaryColor,
        ),
        body: SendPaymentGenericError(
          onClose: () {
            Navigator.of(context).pop();
          },
          status: status,
          errorMessage: errorMessage,
        ),
      ),
    );
    Navigator.of(context).pushReplacement(route);
  }

  void _handleProcessApiSuccess(BuildContext context) {
    sendToPaymentForm(context, autofill: true);
  }

  void _showTwoDifferentCnpjErrorBottomSheet(BuildContext context) {
    twoDifferentCnpjErrorAnalyticsLog();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      builder: (context) {
        return PaymentTwoDifferentCnpjErrorBottomSheet(
          onSendToFinance: () {
            twoDifferentCnpjSendToFinancialAnalyticsLog();
            sendToFinance(context);
          },
          onReturnToPayment: () {
            twoDifferentCnpjBackToPaymentAnalyticsLog();
            MaterialPageRoute route = MaterialPageRoute(
              builder: (context) => const PaymentReviewDocumentPage(),
            );
            Navigator.of(context).pushReplacement(route);
          },
        );
      },
    );
  }

  void _showCnpjErrorBottomSheet(BuildContext context) {
    differentCondoErrorAnalyticsLog();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      builder: (context) {
        return PaymentCnpjErrorBottomSheet(
          onSendToFinance: () {
            differentCondoSendToFinancialAnalyticsLog();
            sendToFinance(context);
          },
          onReturnToPayment: () {
            differentCondoBackToPaymentAnalyticsLog();
            MaterialPageRoute route = MaterialPageRoute(
              builder: (context) => const PaymentReviewDocumentPage(),
            );
            Navigator.of(context).pushReplacement(route);
          },
        );
      },
    );
  }

  Future<List<File>> pickFiles(BuildContext context) async {
    return await AttachFilesBottomSheet.show(
      appContainer: ApplicationContainer.instance(),
      context: context,
      aspectRatioPresets: [CropAspectRatioPreset.original],
      maxFileSizePermitted: 10 * 1024 * 1024,
      allowMultiple: true,
    );
  }

  Future<List<File>> validateFiles(
      BuildContext context, List<File> filesList) async {
    List<File> recentlyAddedFiles = [];
    int currentFileCount = files.length;
    for (var file in filesList) {
      if (currentFileCount + recentlyAddedFiles.length >= 99) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return PaymentMaxFilesErrorDialog(
                onTryAgain: () => Navigator.pop(context),
              );
            });
        break;
      } else {
        recentlyAddedFiles.add(File(file.path));
      }
    }

    return recentlyAddedFiles;
  }

  Future<void> renderPdf(BuildContext context, File pdfFile) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFScreen(pdfFile: pdfFile, title: "PDF"),
      ),
    );
  }

  Future<void> renderImage(BuildContext context, File imgFile) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IMGScreen(imageFile: imgFile, title: "Imagem"),
      ),
    );
  }

  String getSvgStringWithPrimaryColor(BuildContext context, String svgContent) {
    final hexColor =
        '#${(Theme.of(context).primaryColor.value & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';
    return svgContent.replaceAll('fill="currentColor"', 'fill="$hexColor"');
  }

  void dispose() {
    // files = [];
    bloc.add(PaymentSendDocumentEmptyEvent());
  }

  String get condominiumId =>
      sessionBloc.state.session!.selectedCondominium!.id;

  void sendToFinance(BuildContext context) {
    if (tempProcessData == null) return;
    Navigator.of(context).pushNamedAndRemoveUntil(
        ApplicationRoute.paymentSendFinancialDepartment,
        ModalRoute.withName(ApplicationRoute.payment),
        arguments: PaymentSendFinancialDepartmentPageArgs(tempProcessData!));
  }

  void sendToPaymentForm(BuildContext context, {required bool autofill}) {
    if (tempProcessData == null) return;

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => RegisterFormPage(
            data: tempProcessData!,
            autofill: autofill,
          ),
        ),
        ModalRoute.withName(ApplicationRoute.payment));
  }

  String get getCondoReference =>
      sessionBloc.state.session?.selectedCondominium?.reference ?? "";

  Future<AccessToken?> get _getAccessToken async {
    final token = await getToken.call(GetTokenParams(role: null));
    return token.getOrElse(() => null);
  }

  Future<String> get _getUserType async {
    final token = await _getAccessToken;
    return token?.selectedRole ?? "";
  }

  Future<String> get getAccessToken async {
    final token = await _getAccessToken;
    return token?.accessToken ?? "";
  }

  void sendPaymentAnalyticsTimerStart() async {
    log("AccessToken: ${await getAccessToken}");
    sendPaymentTimer = AnalyticsTimer(
      userType: await _getUserType,
      userId: sessionBloc.state.session?.me?.id ?? "",
      event: AnalyticsEventsManager.pagamentosTemporizador(),
      referenceValue: getCondoReference,
      appOrigin: appOriginEnum,
    );
  }

  void sendPaymentAnalyticsTimerStop() {
    sendPaymentTimer.stopTimer();
  }

  void newsDialogContinueButtonAnalyticsLog() async {
    AnalyticsLogEvents.logEvent(
        event: AnalyticsEventsManager.popUpPagamentoContinuar(),
        userId: sessionBloc.state.session?.me?.id ?? "",
        userType: await _getUserType,
        referenceValue: getCondoReference,
        appOrigin: appOriginEnum,
        otherParameters: {
          "tela": enumToString(PaymentScreens.paymentSendDocumentPage)!,
        });
  }

  void newsDialogCancelButtonAnalyticsLog() async {
    AnalyticsLogEvents.logEvent(
        event: AnalyticsEventsManager.popUpPagamentoVoltar(),
        userId: sessionBloc.state.session?.me?.id ?? "",
        userType: await _getUserType,
        referenceValue: getCondoReference,
        appOrigin: appOriginEnum,
        otherParameters: {
          "tela": enumToString(PaymentScreens.paymentSendDocumentPage)!,
        });
  }

  void addDocumentsButtonAnalyticsLog() async {
    AnalyticsLogEvents.logEvent(
        event: AnalyticsEventsManager.pagamentoBotaoAdicionarDocumento(),
        userId: sessionBloc.state.session?.me?.id ?? "",
        userType: await _getUserType,
        referenceValue: getCondoReference,
        appOrigin: appOriginEnum,
        otherParameters: {
          "tela": enumToString(PaymentScreens.paymentSendDocumentPage)!,
        });
  }

  void backArrowAnalyticsLog(PaymentScreens tela) async {
    AnalyticsLogEvents.logEvent(
        event: AnalyticsEventsManager.pagamentoCancelarFluxo(),
        userId: sessionBloc.state.session?.me?.id ?? "",
        userType: await _getUserType,
        referenceValue: getCondoReference,
        appOrigin: appOriginEnum,
        otherParameters: {
          "tela": enumToString(tela)!,
        });
  }

  void reviewDocumentsAddButtonAnalyticsLog() async {
    AnalyticsLogEvents.logEvent(
        event: AnalyticsEventsManager.listarDocumentoBotaoAdicionar(),
        userId: sessionBloc.state.session?.me?.id ?? "",
        userType: await _getUserType,
        referenceValue: getCondoReference,
        appOrigin: appOriginEnum,
        otherParameters: {
          "tela": enumToString(PaymentScreens.paymentReviewDocumentPage)!,
        });
  }

  void reviewDocumentsBackButtonAnalyticsLog() async {
    AnalyticsLogEvents.logEvent(
        event: AnalyticsEventsManager.listarDocumentoBotaoVoltar(),
        userId: sessionBloc.state.session?.me?.id ?? "",
        userType: await _getUserType,
        referenceValue: getCondoReference,
        appOrigin: appOriginEnum,
        otherParameters: {
          "tela": enumToString(PaymentScreens.paymentReviewDocumentPage)!,
        });
  }

  void reviewDocumentsContinueButtonAnalyticsLog() async {
    AnalyticsLogEvents.logEvent(
        event: AnalyticsEventsManager.listarDocumentoBotaoContinuar(),
        userId: sessionBloc.state.session?.me?.id ?? "",
        userType: await _getUserType,
        referenceValue: getCondoReference,
        appOrigin: appOriginEnum,
        otherParameters: {
          "tela": enumToString(PaymentScreens.paymentReviewDocumentPage)!,
        });
  }

  void illegibleDocumentManualButtonAnalyticsLog() async {
    AnalyticsLogEvents.logEvent(
        event: AnalyticsEventsManager.documentoIlegivelBotaoManual(),
        userId: sessionBloc.state.session?.me?.id ?? "",
        userType: await _getUserType,
        referenceValue: getCondoReference,
        appOrigin: appOriginEnum,
        otherParameters: {
          "tela": enumToString(PaymentScreens.paymentIllegibleDocumentPage)!,
        });
  }

  void illegibleDocumentSendToFinanceButtonAnalyticsLog() async {
    AnalyticsLogEvents.logEvent(
        event: AnalyticsEventsManager.documentoIlegivelBotaoSetorFinanceiro(),
        userId: sessionBloc.state.session?.me?.id ?? "",
        userType: await _getUserType,
        referenceValue: getCondoReference,
        appOrigin: appOriginEnum,
        otherParameters: {
          "tela": enumToString(PaymentScreens.paymentIllegibleDocumentPage)!,
        });
  }

  void differentCondoErrorAnalyticsLog() async {
    AnalyticsLogEvents.logEvent(
        event: AnalyticsEventsManager.documentoCondominioErro(),
        userId: sessionBloc.state.session?.me?.id ?? "",
        userType: await _getUserType,
        referenceValue: getCondoReference,
        appOrigin: appOriginEnum,
        otherParameters: {
          "tela": enumToString(PaymentScreens.paymentReviewDocumentPage)!,
        });
  }

  void differentCondoSendToFinancialAnalyticsLog() async {
    AnalyticsLogEvents.logEvent(
        event: AnalyticsEventsManager.documentoCondominioErroSetorFinanceiro(),
        userId: sessionBloc.state.session?.me?.id ?? "",
        userType: await _getUserType,
        referenceValue: getCondoReference,
        appOrigin: appOriginEnum,
        otherParameters: {
          "tela":
              enumToString(PaymentScreens.paymentDifferentCondominiumError)!,
        });
  }

  void differentCondoBackToPaymentAnalyticsLog() async {
    AnalyticsLogEvents.logEvent(
        event: AnalyticsEventsManager.documentoCondominioErroVoltarPagamento(),
        userId: sessionBloc.state.session?.me?.id ?? "",
        userType: await _getUserType,
        referenceValue: getCondoReference,
        appOrigin: appOriginEnum,
        otherParameters: {
          "tela":
              enumToString(PaymentScreens.paymentDifferentCondominiumError)!,
        });
  }

  void twoDifferentCnpjErrorAnalyticsLog() async {
    AnalyticsLogEvents.logEvent(
        event: AnalyticsEventsManager.documentoCnpjDiferenteErro(),
        userId: sessionBloc.state.session?.me?.id ?? "",
        userType: await _getUserType,
        referenceValue: getCondoReference,
        appOrigin: appOriginEnum,
        otherParameters: {
          "tela": enumToString(PaymentScreens.paymentReviewDocumentPage)!,
        });
  }

  void twoDifferentCnpjSendToFinancialAnalyticsLog() async {
    AnalyticsLogEvents.logEvent(
        event:
            AnalyticsEventsManager.documentoCnpjDiferenteErroSetorFinanceiro(),
        userId: sessionBloc.state.session?.me?.id ?? "",
        userType: await _getUserType,
        referenceValue: getCondoReference,
        appOrigin: appOriginEnum,
        otherParameters: {
          "tela": enumToString(PaymentScreens.paymentDifferentCnpjError)!,
        });
  }

  void twoDifferentCnpjBackToPaymentAnalyticsLog() async {
    AnalyticsLogEvents.logEvent(
        event:
            AnalyticsEventsManager.documentoCnpjDiferenteErroVoltarPagamento(),
        userId: sessionBloc.state.session?.me?.id ?? "",
        userType: await _getUserType,
        referenceValue: getCondoReference,
        appOrigin: appOriginEnum,
        otherParameters: {
          "tela": enumToString(PaymentScreens.paymentDifferentCnpjError)!,
        });
  }

  void overdueCloseDateErrorAnalyticsLog() async {
    AnalyticsLogEvents.logEvent(
        event: AnalyticsEventsManager.documentoDataVencidaErro(),
        userId: sessionBloc.state.session?.me?.id ?? "",
        userType: await _getUserType,
        referenceValue: getCondoReference,
        appOrigin: appOriginEnum,
        otherParameters: {
          "tela": enumToString(PaymentScreens.paymentReviewDocumentPage)!,
        });
  }
}

enum FilesType { files, images }
