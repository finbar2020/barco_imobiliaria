import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/payment_approval.dart';
import 'package:lello/feature/payment/presentation/approval/bloc/payment_approval_event.dart';
import 'package:lello/feature/payment/presentation/approval/bloc/payment_approval_state.dart';

abstract class PaymentApprovalBloc
    extends Bloc<PaymentApprovalEvent, PaymentApprovalState> {
  PaymentApprovalBloc(PaymentApprovalState initialState) : super(initialState);

  void setApproval(PaymentApproval approval);
  void beginRequestValidationCode(CodeValidationSource source);
  beginSend();
  bool revertCodeValidation();
  bool getCanAutenticate();
}
