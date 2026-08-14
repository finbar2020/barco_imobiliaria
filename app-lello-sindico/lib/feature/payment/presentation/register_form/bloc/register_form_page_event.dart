import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/payment_data.dart';

abstract class RegisterFormPageEvent extends Equatable {
  const RegisterFormPageEvent();

  @override
  List<Object?> get props => [];
}

class RegisterFormBlocPageStepChangedEvent extends RegisterFormPageEvent {
  final int step;

  const RegisterFormBlocPageStepChangedEvent(this.step);

  @override
  List<Object?> get props => [step];
}

class RegisterFormBlocPageFieldChangedEvent extends RegisterFormPageEvent {
  final int step;
  final PaymentDataEntity formData;

  const RegisterFormBlocPageFieldChangedEvent(this.step, this.formData);

  @override
  List<Object?> get props => [step, formData];
}
