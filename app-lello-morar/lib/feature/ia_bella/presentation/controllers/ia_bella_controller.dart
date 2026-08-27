import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/feature/ia_bella/data/model/ia_bella_data_model.dart';
import 'package:morar/feature/ia_bella/data/model/ia_bella_final_evaluation_model.dart';
import 'package:morar/feature/ia_bella/data/model/ia_bella_rate_response_model.dart';
import 'package:morar/feature/ia_bella/data/model/ia_bella_send_message_model.dart';
import 'package:morar/feature/ia_bella/domain/entity/bella_message_entity.dart';
import 'package:morar/feature/ia_bella/domain/entity/ia_bella_data_entity.dart';
import 'package:morar/feature/ia_bella/domain/entity/ia_bella_send_message_entity.dart';
import 'package:morar/feature/ia_bella/domain/use_case/download_pdf/ia_bella_pdf_user_case.dart';
import 'package:morar/feature/ia_bella/domain/use_case/final_evaluation/ia_bella_final_evaluation_use_case.dart';
import 'package:morar/feature/ia_bella/domain/use_case/rate_response/ia_bella_rate_response_use_case.dart';
import 'package:morar/feature/ia_bella/domain/use_case/send_message/ia_bella_send_message_use_case.dart';
import 'package:morar/feature/ia_bella/domain/use_case/start_session/ia_bella_start_session_use_case.dart';
import 'package:morar/feature/ia_bella/presentation/bloc/ia_bella_bloc.dart';
import 'package:morar/feature/ia_bella/presentation/bloc/ia_bella_event.dart';
import 'package:morar/feature/ia_bella/presentation/widgets/bella_feedback_success_dialog.dart';
import 'package:morar/feature/ia_bella/presentation/widgets/bella_not_resolved_dialog.dart';
import 'package:morar/feature/ia_bella/presentation/widgets/message_timeout_dialog.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';

class IaBellaController {
  final IaBellaSendMessageUseCase sendMessageUseCase;
  final IaBellaStartSessionUseCase startSessionUseCase;
  final IaBellaPdfUseCase downloadPdfUseCase;
  final IaBellaRateResponseUseCase rateResponseUseCase;
  final IaBellaFinalEvaluationUseCase finalEvaluationUseCase;
  final SessionBloc sessionBloc;
  final IaBellaBloc bloc;
  List<BellaMessageEntity> messages = [];
  final Map<String, bool> _loadingStates = {};
  bool isLoading(String responseId) => _loadingStates[responseId] ?? false;
  IaBellaDataEntity? startSessionDataEntity;
  bool isSessionStarted = false;
  int selectedFeedbackRating = 0;
  bool? selectedRequestResolved;
  TextEditingController messageController = TextEditingController();
  TextEditingController negativeFeedbackController = TextEditingController();
  TextEditingController finalEvaluationController = TextEditingController();
  IaBellaController(
      {required this.sendMessageUseCase,
      required this.startSessionUseCase,
      required this.finalEvaluationUseCase,
      required this.downloadPdfUseCase,
      required this.rateResponseUseCase,
      required this.sessionBloc,
      required this.bloc});

  String get condoId => sessionBloc.state.session?.condominium?.id ?? '';

  bool checkSendMessage = false;

  void setSelectedFeedbackRating(int rating) {
    selectedFeedbackRating = rating;
  }

  void clearFinalEvaluationFields() {
    finalEvaluationController.clear();
    selectedFeedbackRating = 0;
    selectedRequestResolved = null;
  }

  void resetChat() {
    messages.clear();
    isSessionStarted = false;
    startSessionDataEntity = null;
    checkSendMessage = false;
    clearFinalEvaluationFields();
  }

  Future<void> _openWhatsApp() async {
    final phone = FlavorConfig.config.supportMoradorWhatsAppNumber;
    final url = Uri.parse(
        "https://api.whatsapp.com/send?phone=$phone&text=Oi,%20pode%20me%20ajudar");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw "Não foi possível abrir o link do WhatsApp.";
    }
  }

  void onFinalEvaluationSuccess(
    BuildContext context,
    bool success,
    bool requestResolved,
    VoidCallback onRetry,
  ) {
    if (success) {
      Navigator.pop(context);
      if (requestResolved) {
        Future.delayed(Duration(milliseconds: 100), () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return BellaFeedbackSuccessDialog(
                onClose: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              );
            },
          );
        });
      } else {
        Future.delayed(Duration(milliseconds: 100), () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return BellaNotResolvedDialog(
                onRetry: () {
                  Navigator.pop(context);
                  onRetry();
                },
                onClose: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              );
            },
          );
        });
      }
    }
  }

  Future<bool> rateResponse(
      String responseId, String? justification, bool? isPositive) async {
    _loadingStates[responseId] = true;
    String evaluationType = "";
    if (isPositive != null) {
      evaluationType = isPositive ? "POSITIVE" : "NEGATIVE";
    }
    bloc.add(IaBellaRateMessageEvent(responseId));

    IaBellaRateResponseModel userRate = IaBellaRateResponseModel(
      responseId: responseId,
      evaluationType: isPositive != null ? evaluationType : null,
      justification: justification,
    );

    final result = await rateResponseUseCase(
        IaBellaRateResponseParam(condominiumId: condoId, userRate: userRate));

    bool success = false;

    result.fold((error) {
      bloc.add(IaBellaErrorEvent(error.toString()));
    }, (response) {
      bloc.add(IaBellaRateMessageSuccessEvent(response.responseId!));
      success = true;
      negativeFeedbackController.clear();
    });

    _loadingStates.remove(responseId);
    return success;
  }

  Future<void> renderPdf(
      BuildContext context, String documentId, String serviceType) async {
    bloc.add(IaBellaRenderPdfEvent(documentId));

    final result = await downloadPdfUseCase(IaBellaPdfParam(
      condominiumId: condoId,
      documentId: documentId,
      serviceType: serviceType,
    ));

    result.fold((error) {
      bloc.add(IaBellaErrorEvent(error.toString()));
    }, (response) async {
      if (response.content == null) {
        bloc.add(IaBellaErrorEvent("Erro: O conteúdo do PDF é nulo!"));
        return;
      }

      Uint8List bytes = base64Decode(response.content!);

      if (bytes.isEmpty) {
        bloc.add(IaBellaErrorEvent("Erro: O conteúdo do PDF está vazio!"));
        return;
      }

      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/document.pdf';
      File file = File(filePath);
      await file.writeAsBytes(bytes);

      bloc.add(IaBellaRenderPdfSuccessEvent(documentId));

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFScreen(pdfFile: file, title: "PDF"),
        ),
      );
    });
  }

  Future<void> downloadPdf(String documentId, String serviceType) async {
    bloc.add(IaBellaDownloadPdfEvent(documentId));

    final result = await downloadPdfUseCase(IaBellaPdfParam(
      condominiumId: condoId,
      documentId: documentId,
      serviceType: serviceType,
    ));

    result.fold((error) {
      debugPrint("Erro ao baixar PDF: ${error.toString()}");
      bloc.add(IaBellaErrorEvent(error.toString()));
    }, (response) async {
      debugPrint("Recebendo resposta do PDF");

      if (response.content == null) {
        debugPrint("Erro: O conteúdo do PDF é nulo!");
        bloc.add(IaBellaErrorEvent("Erro: O conteúdo do PDF é nulo!"));
        return;
      }

      Uint8List? bytes;
      bytes = base64Decode(response.content!);

      if (bytes.isEmpty) {
        debugPrint("Erro: O conteúdo do PDF está vazio!");
        bloc.add(IaBellaErrorEvent("Erro: O conteúdo do PDF está vazio!"));
        return;
      }

      String fileName = response.fileName ?? "documento.pdf";
      try {
        String? pickerPath = await FilePicker.platform.saveFile(
          dialogTitle: 'Salvar PDF como...',
          bytes: bytes,
          fileName: fileName.replaceAll('"', ''),
          type: FileType.custom,
          allowedExtensions: ['pdf'],
        );

        if (pickerPath == null) {
          debugPrint("Erro: Caminho de salvamento não selecionado!");
          bloc.add(IaBellaErrorEvent(
              "Erro: Caminho de salvamento não selecionado!"));
          return;
        }
        final file = File('$pickerPath/$fileName');

        await file.writeAsBytes(bytes);
        debugPrint("PDF salvo em: ${file.path}");

        bloc.add(IaBellaDownloadPdfSuccessEvent(documentId));
      } catch (e) {
        debugPrint("Erro ao salvar/abrir o PDF: $e");
        bloc.add(IaBellaErrorEvent("Erro ao salvar/abrir o PDF: $e"));
      }
    });
  }

  Future<void> startSession() async {
    bloc.add(IaBellaStartSessionEvent());
    final result = await startSessionUseCase(
        IaBellaStartSessionParam(condominiumId: condoId));
    result.fold((error) {
      bloc.add(IaBellaStartSessionErrorEvent());
    }, (response) {
      if (response.uuidSession != null) {
        bloc.add(IaBellaSessionStartedEvent(response.uuidSession.toString()));
        startSessionDataEntity = response;
        messages.add(BellaMessageEntity(
          text: response.welcomeMessage ?? "Erro desconhecido",
        ));
        isSessionStarted = true;
      } else {
        messages.add(BellaMessageEntity(
          text: "Erro desconhecido",
        ));
        bloc.add(IaBellaErrorEvent("Erro desconhecido"));
      }
    });
  }

  Future<bool> finalEvaluation(
      int evaluation, String comment, bool requestResolved) async {
    bloc.add(IaBellaFinalEvaluationEvent());

    final result = await finalEvaluationUseCase(
      IaBellaFinalEvaluationUseCaseParam(
        condominiumId: condoId,
        messageEvaluation: IaBellaFinalEvaluationModel(
          uuidSession: startSessionDataEntity!.uuidSession,
          evaluation: evaluation,
          comment: comment,
          requestResolved: requestResolved,
        ),
      ),
    );

    return result.fold((error) {
      bloc.add(IaBellaErrorEvent(error.toString()));
      return false;
    }, (response) {
      bloc.add(IaBellaFinalEvaluationSuccessEvent());
      return true;
    });
  }

  Future<void> sendMessage(
      BuildContext context, BellaMessageEntity userMessage) async {
    if (userMessage.text.isEmpty) return;
    checkSendMessage = true;
    _addSendingMessageEvent(userMessage.text);
    final displayMessage = userMessage.displayText != null
        ? BellaMessageEntity(
            text: userMessage.displayText!,
            isUser: userMessage.isUser,
            responseId: userMessage.responseId,
            documents: userMessage.documents,
          )
        : userMessage;
    _addUserMessage(displayMessage);
    _clearMessageController();

    final tempMessage = _createTempMessage();
    _addTempMessage(tempMessage);

    final messageEntity = _createMessageEntity(userMessage.text);
    final Try<IaBellaDataEntity> result;
    try {
      result = await _sendMessageToUseCase(messageEntity)
          .timeout(Duration(seconds: 60));
    } on TimeoutException {
      // O dialogo de timeout ja orienta o usuario; completa sem erro
      // assincrono solto (nenhum chamador trata o Future).
      _handleMessageTimeout(context);
      return;
    }
    result.fold(
      (error) => _handleError(error, tempMessage),
      (response) => _handleResponse(response, tempMessage),
    );
  }

  void _addUserMessage(BellaMessageEntity userMessage) {
    messages.add(userMessage);
  }

  void _clearMessageController() {
    messageController.clear();
  }

  void _addSendingMessageEvent(String message) {
    bloc.add(IaBellaSendMessageEvent(message));
  }

  BellaMessageEntity _createTempMessage() {
    return BellaMessageEntity(text: "...");
  }

  void _addTempMessage(BellaMessageEntity tempMessage) {
    messages.add(tempMessage);
  }

  IaBellaSendMessageEntity _createMessageEntity(String message) {
    return IaBellaSendMessageEntity(
      message: message,
      sessionId: startSessionDataEntity!.uuidSession,
    );
  }

  Future<Try<IaBellaDataEntity>> _sendMessageToUseCase(
      IaBellaSendMessageEntity messageEntity) {
    return sendMessageUseCase(IaBellaSendMessageParam(
      userInput: IaBellaSendMessageModel.fromEntity(messageEntity)!,
      condominiumId: condoId,
    ));
  }

  void _handleError(Failure error, BellaMessageEntity tempMessage) {
    final index = messages.indexOf(tempMessage);
    if (index != -1) {
      messages[index] = BellaMessageEntity(
          text:
              "Ops, parece que estou com problemas de instabilidade. Poderia tentar novamente?");
    }
    bloc.add(IaBellaErrorEvent(error.toString()));
  }

  void _handleMessageTimeout(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => MessageTimeoutDialog(
              onReturnToMainPage: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ));
  }

  void _handleResponse(
      IaBellaDataEntity? response, BellaMessageEntity tempMessage) {
    final index = messages.indexOf(tempMessage);
    if (response != null) {
      if (index != -1) {
        messages[index] = BellaMessageEntity(
            text: response.response!, responseId: response.responseId);
        if (response.documents.isNotEmpty) {
          messages[index].documents = response.documents;
        }
      }
      bloc.add(IaBellaReceiveMessageEvent(response.response!));
    } else {
      if (index != -1) {
        messages[index] = BellaMessageEntity(
          text: "Erro desconhecido",
        );
      }
      bloc.add(IaBellaErrorEvent("Erro desconhecido"));
    }
  }

  bool isSessionStartedToday() {
    if (startSessionDataEntity == null) return false;
    final startDate = DateTime.now();
    final now = DateTime.now();
    return startDate.day == now.day &&
        startDate.month == now.month &&
        startDate.year == now.year;
  }

  String getSessionStartDate() {
    if (startSessionDataEntity == null) return '';

    final startDate = DateTime.now();
    String formattedDate =
        DateFormat("d 'de' MMMM 'de' y", 'pt_BR').format(startDate);

    return formattedDate;
  }
}
