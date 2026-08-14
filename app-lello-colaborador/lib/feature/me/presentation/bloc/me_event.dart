// ignore: depend_on_referenced_packages
import 'package:colaborador/feature/me/domain/entity/me.dart';
import 'package:colaborador/feature/me/domain/entity/me_step.dart';
import 'package:essentials/essentials.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_features/shared_features.dart';

abstract class MeEvent extends Equatable {
  const MeEvent();

  @override
  List<Object?> get props => [];
}

class MeLoadEvent extends MeEvent {
  final bool forceUpdate;
  const MeLoadEvent({this.forceUpdate = false});

  @override
  List<Object?> get props => [forceUpdate];
}

class MeBeginEditEvent extends MeEvent {
  const MeBeginEditEvent();
}

class MeBeginEditPasswordEvent extends MeEvent {
  const MeBeginEditPasswordEvent();
}

class MeBeginEditSavePasswordEvent extends MeEvent {
  final String originPassword;
  final String password;
  const MeBeginEditSavePasswordEvent(
      {required this.originPassword, required this.password});

  @override
  List<Object?> get props => [originPassword, password];
}

class MeLogoutEvent extends MeEvent {
  const MeLogoutEvent();
}

class MeRevertEditEvent extends MeEvent {
  const MeRevertEditEvent();
}

class ResendTokenEvent extends MeEvent {
  const ResendTokenEvent();
}

class MeSaveEvent extends MeEvent {
  final CodeValidation? codeValidation;
  const MeSaveEvent({this.codeValidation});

  @override
  List<Object?> get props => [codeValidation];
}

class MeChangeStepEvent extends MeEvent {
  final MeStep step;
  const MeChangeStepEvent({required this.step});

  @override
  List<Object?> get props => [step];
}

class MeRequestValidationCodeEvent extends MeEvent {
  final bool isPhoneCheck;
  final bool isEmailCheck;
  const MeRequestValidationCodeEvent(
      {required this.isPhoneCheck, required this.isEmailCheck});

  @override
  List<Object?> get props => [isPhoneCheck, isEmailCheck];
}

class MeChooseImageEvent extends MeEvent {
  final ImageSource source;
  const MeChooseImageEvent(this.source);

  @override
  List<Object?> get props => [source];
}

class MeDeleteAccountEvent extends MeEvent {
  final Me me;
  const MeDeleteAccountEvent(this.me);

  @override
  List<Object?> get props => [me];
}
