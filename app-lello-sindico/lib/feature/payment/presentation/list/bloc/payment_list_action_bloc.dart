import 'package:flutter_bloc/flutter_bloc.dart';
import 'payment_list_action_event.dart';
import 'payment_list_action_state.dart';
import 'package:lello/feature/payment/domain/entity/payment_installment_in_approval.dart';
import 'package:lello/feature/payment/presentation/pendency/controller/payment_pendency_controller.dart';

class PaymentListActionBloc
    extends Bloc<PaymentListActionEvent, PaymentListActionState> {
  final PaymentPendencyController controller;
  PaymentListActionBloc(this.controller)
      : super(const PaymentListActionInitialState()) {
    on<PaymentListActionPressedEvent>(_onPressed);
    on<PaymentListActionResetEvent>(
        (event, emit) => emit(const PaymentListActionInitialState()));
  }

  Future<void> _onPressed(PaymentListActionPressedEvent event,
      Emitter<PaymentListActionState> emit) async {
    emit(const PaymentListActionLoadingState());
    try {
      PaymentInstallmentInApprovalEntity? installment =
          await _getInstallmentById(event.installmentId);
      if (installment != null) {
        emit(PaymentListActionLoadedState(installment));
      } else {
        emit(const PaymentListActionErrorState('Lançamento não encontrado.'));
      }
    } catch (e) {
      emit(PaymentListActionErrorState(e.toString()));
    }
  }

  Future<PaymentInstallmentInApprovalEntity?> _getInstallmentById(
      String id) async {
    await controller.getInstallmentsInApproval(
        onlyInApprovalStatus: false, installmentId: id);
    if (controller.allInstallmentsInApproval != null &&
        controller.allInstallmentsInApproval!.isNotEmpty) {
      return controller.allInstallmentsInApproval!.first;
    } else {
      return null;
    }
  }
}
