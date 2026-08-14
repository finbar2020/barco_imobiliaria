import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/payment_data.dart';

/// Estado único do wizard de registro (form). Mantém copyWith como padrão
/// aceito para formulários/wizards.
class RegisterFormPageStepChangedState extends Equatable {
  final int totalSteps;
  final int currentStep;
  final Map<int, bool> stepCompletion;
  final PaymentDataEntity formData;

  const RegisterFormPageStepChangedState({
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

  @override
  List<Object?> get props =>
      [totalSteps, currentStep, stepCompletion, formData];
}
