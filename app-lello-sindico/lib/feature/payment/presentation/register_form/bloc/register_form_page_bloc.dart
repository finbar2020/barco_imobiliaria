import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/payment/domain/entity/payment_data.dart';

import 'register_form_page_event.dart';
import 'register_form_page_state.dart';

class RegisterFormPageBloc
    extends Bloc<RegisterFormPageEvent, RegisterFormPageStepChangedState> {
  RegisterFormPageBloc()
      : super(RegisterFormPageStepChangedState(
          totalSteps: 3,
          currentStep: 0,
          stepCompletion: {0: false, 1: false, 2: false},
          formData: PaymentDataEntity(
            idSupplier: 0,
            documentSupplier: '',
            idContract: 0,
            documentNumber: '',
            documentType: null,
            dueDate: DateTime.now(),
            installmentQuantity: 0,
            totalValue: 0,
            observation: '',
            filePathLaunch: '',
            totalPages: 0,
            ledgerAccount: 0,
            installments: [],
            isUtilityAccount: false,
            isSendFinancial: false,
          ),
        )) {
    on<RegisterFormBlocPageStepChangedEvent>(
        handleRegisterFormBlocPageLoadingEvent);
    on<RegisterFormBlocPageFieldChanged>(
        handleRegisterFormBlocPageFieldChangedEvent);
  }

  void handleRegisterFormBlocPageLoadingEvent(
      RegisterFormBlocPageStepChangedEvent event, Emitter emit) {
    emit(state.copyWith(currentStep: event.step));
  }

  void handleRegisterFormBlocPageFieldChangedEvent(
      RegisterFormBlocPageFieldChanged event, Emitter emit) {
    var isComplete = event.formData.checkStep(event.step);

    final updatedStepCompletion = Map<int, bool>.from(state.stepCompletion);
    updatedStepCompletion[event.step] = isComplete;

    emit(state.copyWith(
      formData: event.formData,
      stepCompletion: updatedStepCompletion,
    ));
  }
}
