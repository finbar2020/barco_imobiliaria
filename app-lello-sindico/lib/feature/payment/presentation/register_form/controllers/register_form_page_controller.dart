import 'dart:developer';

import 'package:essentials/analytics/analytics_log_events.dart';
import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/enum/enum_serializer.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/payment/domain/entity/payment_data.dart';
import 'package:lello/feature/payment/domain/entity/payment_screens.dart';
import 'package:lello/feature/payment/domain/entity/process_files_response.dart';
import 'package:lello/feature/payment/domain/entity/supplier_data_entity.dart';
import 'package:lello/feature/payment/domain/use_case/send_payment/send_payment.dart';
import 'package:lello/feature/payment/presentation/register/controllers/payment_registration_controller.dart';
import 'package:lello/feature/payment/presentation/register_form/bloc/register_form_page_bloc.dart';
import 'package:lello/feature/payment/presentation/register_form/bloc/register_form_page_event.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/shared_features.dart';

class RegisterFormPageController {
  PageController pageController = PageController(initialPage: 0);

  final SendPayment sendPaymentUseCase;

  final PaymentRegistrationController _paymentRegistrationController =
      ApplicationContainer.instance().resolve();

  final SessionBloc sessionBloc;

  final RegisterFormPageBloc bloc;

  late PaymentDataEntity paymentData;

  late ProcessFilesResponseEntity data;

  late bool autofill;

  late SupplierDataEntity? supplier;

  AppOriginEnum appOriginEnum = AppOriginEnum.manager;
  final GetToken getToken;

  RegisterFormPageController(
      this.bloc, this.sendPaymentUseCase, this.sessionBloc, this.getToken);

  String get condoId => sessionBloc.state.session!.selectedCondominium!.id;

  setPaymentData(ProcessFilesResponseEntity data) {
    paymentData = data.paymentData!;
    supplier = data.supplierData;
    bloc.add(RegisterFormBlocPageFieldChanged(0, paymentData));
  }

  setIsAutofill(bool autofill) {
    this.autofill = autofill;
    log("autofill: $autofill");
  }

  void previousPage(BuildContext context) {
    Navigator.pop(context);
    bloc.add(RegisterFormBlocPageStepChangedEvent(bloc.state.currentStep - 1));
  }

  void sendPaymentAnalyticsTimerStop() {
    _paymentRegistrationController.sendPaymentAnalyticsTimerStop();
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

  void nextStepAnalyticsLog(PaymentScreens tela) async {
    AnalyticsLogEvents.logEvent(
        event: AnalyticsEventsManager.formularioBotaoAvancar(),
        userId: sessionBloc.state.session?.me?.id ?? "",
        userType: await _getUserType,
        referenceValue: getCondoReference,
        appOrigin: appOriginEnum,
        otherParameters: {
          "autofill": autofill.toString(),
          "tela": enumToString(tela)!,
        });
  }

  void backStepAnalyticsLog(PaymentScreens tela) async {
    AnalyticsLogEvents.logEvent(
        event: AnalyticsEventsManager.formularioBotaoVoltar(),
        userId: sessionBloc.state.session?.me?.id ?? "",
        userType: await _getUserType,
        referenceValue: getCondoReference,
        appOrigin: appOriginEnum,
        otherParameters: {
          "autofill": autofill.toString(),
          "tela": enumToString(PaymentScreens.paymentFormFirstStep)!,
        });
  }

  void chooseLedgerAccountAnalyticsLog() async {
    AnalyticsLogEvents.logEvent(
        event: AnalyticsEventsManager.modalEscolherContaContabil(),
        userId: sessionBloc.state.session?.me?.id ?? "",
        userType: await _getUserType,
        referenceValue: getCondoReference,
        appOrigin: appOriginEnum,
        otherParameters: {
          "autofill": autofill.toString(),
          "tela": enumToString(
              PaymentScreens.paymentFirstPaymentAccountingAccountModal)!,
        });
  }

  void sendWithNoLedgerAccountAnalyticsLog() async {
    AnalyticsLogEvents.logEvent(
        event: AnalyticsEventsManager.modalSemContaContabil(),
        userId: sessionBloc.state.session?.me?.id ?? "",
        userType: await _getUserType,
        referenceValue: getCondoReference,
        appOrigin: appOriginEnum,
        otherParameters: {
          "autofill": autofill.toString(),
          "tela": enumToString(
              PaymentScreens.paymentFirstPaymentAccountingAccountModal)!,
        });
  }

  void sendWithDifferentClassificationAnalyticsLog() async {
    AnalyticsLogEvents.logEvent(
        event: AnalyticsEventsManager.modalUsarOutraClassificacao(),
        userId: sessionBloc.state.session?.me?.id ?? "",
        userType: await _getUserType,
        referenceValue: getCondoReference,
        appOrigin: appOriginEnum,
        otherParameters: {
          "autofill": autofill.toString(),
          "tela": enumToString(
              PaymentScreens.paymentAccountingAccountSuggestionModal)!,
        });
  }

  void modalSuggestionNoLedgerAccountAnalyticsLog() async {
    AnalyticsLogEvents.logEvent(
        event: AnalyticsEventsManager.modalSugestaoSemContaContabil(),
        userId: sessionBloc.state.session?.me?.id ?? "",
        userType: await _getUserType,
        referenceValue: getCondoReference,
        appOrigin: appOriginEnum,
        otherParameters: {
          "autofill": autofill.toString(),
          "tela": enumToString(
              PaymentScreens.paymentAccountingAccountSuggestionModal)!,
        });
  }

  void modalSuggestionSendPaymentAnalyticsLog() async {
    AnalyticsLogEvents.logEvent(
        event: AnalyticsEventsManager.modalSugestaoEnviarPagamento(),
        userId: sessionBloc.state.session?.me?.id ?? "",
        userType: await _getUserType,
        referenceValue: getCondoReference,
        appOrigin: appOriginEnum,
        otherParameters: {
          "autofill": autofill.toString(),
          "tela": enumToString(
              PaymentScreens.paymentAccountingAccountSuggestionModal)!,
        });
  }

  void lastStepSendPaymentAnalyticsLog() async {
    AnalyticsLogEvents.logEvent(
        event: AnalyticsEventsManager.etapaFinalEnviarPagamento(),
        userId: sessionBloc.state.session?.me?.id ?? "",
        userType: await _getUserType,
        referenceValue: getCondoReference,
        appOrigin: appOriginEnum,
        otherParameters: {
          "autofill": autofill.toString(),
          "tela": enumToString(PaymentScreens.paymentFormThirdStep)!,
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

  void sendPaymentSuccessAnalyticsLog(
      PaymentScreens tela, bool autofill) async {
    AnalyticsLogEvents.logEvent(
        event: AnalyticsEventsManager.enviarPagamentoSucesso(),
        userId: sessionBloc.state.session?.me?.id ?? "",
        userType: await _getUserType,
        referenceValue: getCondoReference,
        appOrigin: appOriginEnum,
        otherParameters: {
          "autofill": autofill.toString(),
          "tela": enumToString(tela)!,
        });
  }

  void sendPaymentErrorAnalyticsLog(
      PaymentScreens errorScreen, bool autofill) async {
    AnalyticsLogEvents.logEvent(
        event: AnalyticsEventsManager.enviarPagamentoErro(),
        userId: sessionBloc.state.session?.me?.id ?? "",
        userType: await _getUserType,
        referenceValue: getCondoReference,
        appOrigin: appOriginEnum,
        otherParameters: {
          "autofill": autofill.toString(),
          "tela": enumToString(errorScreen)!,
        });
  }
}
