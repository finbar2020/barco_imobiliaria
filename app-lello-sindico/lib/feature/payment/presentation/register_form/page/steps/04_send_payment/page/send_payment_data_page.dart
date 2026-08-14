import 'package:essentials/essentials.dart';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/payment/domain/entity/payment_data.dart';
import 'package:lello/feature/payment/domain/entity/payment_screens.dart';
import 'package:lello/feature/payment/domain/entity/send_documents_status.dart';
import 'package:lello/feature/payment/presentation/register_form/bloc/register_form_page_event.dart';
import 'package:lello/feature/payment/presentation/register_form/controllers/register_form_page_controller.dart';
import 'package:lello/feature/payment/presentation/register_form/page/steps/04_send_payment/bloc/send_payment_state.dart';
import 'package:lello/feature/payment/presentation/register_form/page/steps/04_send_payment/controllers/send_payment_controller.dart';
import 'package:lello/feature/payment/presentation/register_form/page/steps/04_send_payment/widgets/send_payment_close_due_date_error.dart';
import 'package:lello/feature/payment/presentation/register_form/page/steps/04_send_payment/widgets/send_payment_existent_document_error.dart';
import 'package:lello/feature/payment/presentation/register_form/page/steps/04_send_payment/widgets/send_payment_generic_error.dart';
import 'package:lello/feature/payment/presentation/register_form/page/steps/04_send_payment/widgets/send_payment_success.dart';
import 'package:lello/feature/payment/presentation/register_form/page/steps/04_send_payment/widgets/send_payment_timeout_error.dart';

class SendPaymentDataPage extends StatefulWidget {
  final int step;
  final RegisterFormPageController controller;
  final Function(PaymentDataEntity paymentdata) onChange;

  const SendPaymentDataPage(
      {super.key,
      required this.step,
      required this.controller,
      required this.onChange});

  @override
  State<SendPaymentDataPage> createState() => _SendPaymentDataPageState();
}

class _SendPaymentDataPageState extends State<SendPaymentDataPage> {
  final SendPaymentController controller =
      ApplicationContainer.instance().resolve();
  late PaymentDataEntity paymentdata;

  @override
  initState() {
    super.initState();
    paymentdata = widget.controller.paymentData;
    controller.sendPayment(context, paymentdata);
  }

  @override
  dispose() {
    // widget.controller.dispose();
    super.dispose();
  }

  void navigateToPaymentMainAndClearStack(BuildContext context) {
    widget.controller.sendPaymentAnalyticsTimerStop();
    Navigator.of(context).pushNamedAndRemoveUntil(
        ApplicationRoute.payment, ModalRoute.withName(ApplicationRoute.home));
  }

  void navigateToPaymentAddDocumentAndClearStack(BuildContext context) {
    widget.controller.sendPaymentAnalyticsTimerStop();
    Navigator.of(context).pushNamedAndRemoveUntil(
        ApplicationRoute.paymentSendDocuments,
        ModalRoute.withName(ApplicationRoute.payment));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: controller.bloc,
      builder: (context, state) {
        if (state is SendPaymentLoadingState) {
          return _buildLoading(context);
        } else if (state is SendPaymentSuccessState) {
          //Analtytics success log
          widget.controller.sendPaymentSuccessAnalyticsLog(
              PaymentScreens.paymentSendingDocumentPage,
              widget.controller.autofill);

          return SendPaymentSuccess(
            processNumber: state.value,
            sendAnotherPayment: () {
              navigateToPaymentAddDocumentAndClearStack(context);
            },
            onClose: () {
              navigateToPaymentMainAndClearStack(context);
            },
          );
        } else if (state is SendPaymentFailureState) {
          var statusCode =
              parseSendDocumentsStatus(state.error?.code ?? "ERRO_GENERICO");

          switch (statusCode) {
            case SendDocumentsStatus.timeout:
              //Analtytics timeout error log
              widget.controller.sendPaymentErrorAnalyticsLog(
                  PaymentScreens.paymentFormTimeoutError,
                  widget.controller.autofill);

              return SendPaymentTimeoutError(
                tryAgain: () {
                  controller.sendPayment(context, paymentdata);
                },
                backToPayment: () {
                  widget.controller.bloc.add(
                      RegisterFormBlocPageStepChangedEvent(
                          widget.controller.bloc.state.currentStep - 1));
                },
              );
            case SendDocumentsStatus.dadosDuplicados:
              //Analtytics already sent error log
              widget.controller.sendPaymentErrorAnalyticsLog(
                  PaymentScreens.paymentFormAlreadySentError,
                  widget.controller.autofill);

              return SendPaymentExistentDocumentError(
                onClose: () {
                  navigateToPaymentMainAndClearStack(context);
                },
              );
            case SendDocumentsStatus.documentoEnvioEmMenos24Horas:
              //Analtytics close due date error log
              widget.controller.sendPaymentErrorAnalyticsLog(
                  PaymentScreens.paymentFormCloseDueDateError,
                  widget.controller.autofill);

              return SendPamentCloseDueDateError(
                onClose: () {
                  navigateToPaymentMainAndClearStack(context);
                },
              );
            default:
              //Analtytics generic error log
              widget.controller.sendPaymentErrorAnalyticsLog(
                  PaymentScreens.paymentFormGenericError,
                  widget.controller.autofill);

              return SendPaymentGenericError(
                onClose: () {
                  navigateToPaymentMainAndClearStack(context);
                },
              );
          }
        }
        return _buildLoading(context);
      },
    );
  }

  Widget _buildLoading(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 200,
            child: Lottie.asset(
              "assets/processing_documents_animation.json",
              fit: BoxFit.scaleDown,
              delegates: LottieDelegates(values: [
                ValueDelegate.colorFilter(
                  ['casa', '**'],
                  value: ColorFilter.mode(theme.primaryColor, ui.BlendMode.src),
                ),
                ValueDelegate.colorFilter(
                  ['telhado', '**'],
                  value: ColorFilter.mode(
                      theme.colorScheme.secondary, ui.BlendMode.src),
                ),
              ]),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            getString(context, "payments_processing_your_file"),
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Text(
            getString(context, "payments_processing_wait"),
            style: theme.textTheme.titleMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
