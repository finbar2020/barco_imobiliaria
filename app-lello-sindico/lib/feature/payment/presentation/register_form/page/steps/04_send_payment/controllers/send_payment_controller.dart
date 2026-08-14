import 'package:flutter/material.dart';
import 'package:lello/feature/payment/domain/entity/payment_data.dart';
import 'package:lello/feature/payment/domain/use_case/send_payment/send_payment.dart';
import 'package:lello/feature/payment/presentation/register_form/page/steps/04_send_payment/bloc/send_payment_bloc.dart';
import 'package:lello/feature/payment/presentation/register_form/page/steps/04_send_payment/bloc/send_payment_event.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';

class SendPaymentController {
  final SessionBloc sessionBloc;
  final SendPaymentBloc bloc;
  final SendPayment sendPaymentUseCase;

  SendPaymentController({
    required this.sessionBloc,
    required this.bloc,
    required this.sendPaymentUseCase,
  });

  String get condoId => sessionBloc.state.session!.selectedCondominium!.id;

  sendPayment(BuildContext context, PaymentDataEntity paymentData) async {
    bloc.add(SendPaymentLoadingEvent());
    final result = await sendPaymentUseCase
        .call(SendPaymentParams(condoId: condoId, data: paymentData));
    result.fold((failure) {
      bloc.add(SendPaymentFailureEvent(error: failure));
    }, (success) {
      bloc.add(SendPaymentSuccessEvent(value: success));
    });
  }
}
