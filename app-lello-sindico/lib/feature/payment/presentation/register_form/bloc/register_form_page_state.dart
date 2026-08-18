import 'package:lello/feature/payment/domain/entity/payment_data.dart';

class RegisterFormPageStepChangedState {
  final int totalSteps;
  final int currentStep;
  final Map<int, bool> stepCompletion;
  final PaymentDataEntity formData;

  RegisterFormPageStepChangedState({
    required this.totalSteps,
    required this.currentStep,
    required this.stepCompletion,
    required this.formData,
  });

  RegisterFormPageStepChangedState copyWith({
    int? currentStep,
    Map<int, bool>? stepCompletion,
    PaymentDataEntity? formData,
  }) {
    return RegisterFormPageStepChangedState(
      totalSteps: totalSteps,
      currentStep: currentStep ?? this.currentStep,
      stepCompletion: stepCompletion ?? this.stepCompletion,
      formData: formData ?? this.formData,
    );
  }
}
