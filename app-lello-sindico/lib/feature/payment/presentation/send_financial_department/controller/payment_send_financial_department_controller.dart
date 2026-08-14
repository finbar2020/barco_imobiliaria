import 'package:essentials/analytics/analytics_log_events.dart';
import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/enum/enum_serializer.dart';
import 'package:lello/feature/payment/domain/entity/payment_data.dart';
import 'package:lello/feature/payment/domain/entity/payment_screens.dart';
import 'package:lello/feature/payment/domain/use_case/send_payment/send_payment.dart';
import 'package:lello/feature/payment/presentation/send_financial_department/bloc/payment_send_financial_department_bloc.dart';
import 'package:lello/feature/payment/presentation/send_financial_department/bloc/payment_send_financial_department_event.dart';
import 'package:shared_features/shared_features.dart';

import '../../../../session/presentation/bloc/session_bloc.dart';

class PaymentSendFinancialDepartmentController {
  final SessionBloc sessionBloc;
  final PaymentSendFinancialDepartmentListBloc bloc;
  final SendPayment _sendPayment;
  final appOriginEnum = AppOriginEnum.manager;
  final GetToken getToken;

  PaymentSendFinancialDepartmentController(
    this._sendPayment, {
    required this.sessionBloc,
    required this.bloc,
    required this.getToken,
  });

  void dispose() {}

  String get condominiumId =>
      sessionBloc.state.session!.selectedCondominium!.id;

  String get condominiumNameAndReference =>
      "${sessionBloc.state.session!.selectedCondominium!.reference} - ${sessionBloc.state.session!.selectedCondominium!.name}";

  String get getCondoReference =>
      sessionBloc.state.session!.selectedCondominium!.reference;

  Future<AccessToken?> get _getAccessToken async {
    final token = await getToken.call(GetTokenParams(role: null));
    return token.getOrElse(() => null);
  }

  Future<String> get _getUserType async {
    final token = await _getAccessToken;
    return token?.selectedRole ?? "";
  }

  void send(PaymentDataEntity paymentData) async {
    bloc.add(PaymentSendFinancialDepartmentLoadingEvent());
    sendToFinancialAnalyticsLog();
    paymentData.isSendFinancial = true;
    var result = await _sendPayment(SendPaymentParams(
      condoId: condominiumId,
      data: paymentData,
    ));

    result.fold(
      (ff) => bloc.add(PaymentSendFinancialDepartmentFailureEvent()),
      (ss) => bloc.add(PaymentSendFinancialDepartmentSuccessEvent()),
    );
  }

  bool isDataOk(PaymentDataEntity paymentData) {
    return paymentData.dueDate != null && paymentData.isUtilityAccount != null;
  }

  void sendToFinancialAnalyticsLog() async {
    AnalyticsLogEvents.logEvent(
        event: AnalyticsEventsManager.enviarParaFinanceiroBotao(),
        userId: sessionBloc.state.session?.me?.id ?? "",
        userType: await _getUserType,
        referenceValue: getCondoReference,
        appOrigin: appOriginEnum,
        otherParameters: {
          "tela": enumToString(PaymentScreens.paymentSendToFinancialPage)!,
        });
  }

  void cancelSendToFinancialAnalyticsLog() async {
    AnalyticsLogEvents.logEvent(
        event: AnalyticsEventsManager.financeiroCancelarBotao(),
        userId: sessionBloc.state.session?.me?.id ?? "",
        userType: await _getUserType,
        referenceValue: getCondoReference,
        appOrigin: appOriginEnum,
        otherParameters: {
          "tela": enumToString(PaymentScreens.paymentSendToFinancialPage)!,
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

  void sendPaymentSuccessAnalyticsLog(PaymentScreens tela) async {
    AnalyticsLogEvents.logEvent(
        event: AnalyticsEventsManager.enviarPagamentoSucesso(),
        userId: sessionBloc.state.session?.me?.id ?? "",
        userType: await _getUserType,
        referenceValue: getCondoReference,
        appOrigin: appOriginEnum,
        otherParameters: {
          "tela": enumToString(tela)!,
        });
  }

  void sendPaymentErrorAnalyticsLog(PaymentScreens tela) async {
    AnalyticsLogEvents.logEvent(
        event: AnalyticsEventsManager.enviarPagamentoErro(),
        userId: sessionBloc.state.session?.me?.id ?? "",
        userType: await _getUserType,
        referenceValue: getCondoReference,
        appOrigin: appOriginEnum,
        otherParameters: {
          "tela": enumToString(tela)!,
        });
  }
}
