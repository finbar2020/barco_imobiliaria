import 'package:flutter_bloc/flutter_bloc.dart';
import 'payment_list_action_event.dart';
import 'payment_list_action_state.dart';
import 'package:lello/feature/payment/domain/entity/payment_installment_in_approval.dart';
import 'package:lello/feature/payment/presentation/pendency/controller/payment_pendency_controller.dart';

class PaymentListActionBloc
    extends Bloc<PaymentListActionEvent, PaymentListActionState> {
  final PaymentPendencyController controller;
  PaymentListActionBloc(this.controller) : super(PaymentListActionInitial()) {
    on<PaymentListActionPressed>(_onPressed);
    on<PaymentListActionReset>(
        (event, emit) => emit(PaymentListActionInitial()));
  }

  Future<void> _onPressed(PaymentListActionPressed event,
      Emitter<PaymentListActionState> emit) async {
    emit(PaymentListActionLoading());
    try {
      PaymentInstallmentInApprovalEntity? installment =
          await _getInstallmentById(event.installmentId);
      if (installment != null) {
        emit(PaymentListActionLoaded(installment));
      } else {
        emit(const PaymentListActionError('Lançamento não encontrado.'));
      }
    } catch (e) {
      emit(PaymentListActionError(e.toString()));
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
