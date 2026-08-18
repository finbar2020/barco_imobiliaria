import 'package:lello/feature/payment/domain/entity/payment_data.dart';

abstract class RegisterFormPageEvent {}

class RegisterFormBlocPageStepChangedEvent extends RegisterFormPageEvent {
  final int step;

  RegisterFormBlocPageStepChangedEvent(this.step);
}

class RegisterFormBlocPageFieldChanged extends RegisterFormPageEvent {
  final int step;
  final PaymentDataEntity formData;

  RegisterFormBlocPageFieldChanged(this.step, this.formData);
}
