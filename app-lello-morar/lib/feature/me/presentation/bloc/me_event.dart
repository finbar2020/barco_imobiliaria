import 'package:essentials/essentials.dart';
import 'package:image_picker/image_picker.dart';
import 'package:morar/feature/me/domain/entity/me.dart';
import 'package:morar/feature/me/domain/entity/me_step.dart';
import 'package:shared_features/shared_features.dart';

abstract class MeEvent {}

class MeLoadingEvent extends MeEvent {
  final Me me;
  MeLoadingEvent(this.me);
}

class MeLoadedCacheEvent extends MeEvent {
  final Me me;
  MeLoadedCacheEvent({required this.me});
}

class MeLoadedEvent extends MeEvent {
  final Me me;
  MeLoadedEvent(this.me);
}

class MeLoadFailedEvent extends MeEvent {
  final Me me;
  final Failure failure;
  MeLoadFailedEvent(this.me, this.failure);
}

class MeEditLoadingEvent extends MeEvent {
  final Me me;
  final CodeRequest? codeRequest;
  final CodeValidation? codeValidation;
  MeEditLoadingEvent({required this.me, this.codeRequest, this.codeValidation});
}

class MeEditLoadedEvent extends MeEvent {
  final Me me;
  MeEditLoadedEvent({required this.me});
}

class MeEditPasswordEvent extends MeEvent {
  final Me me;
  final String originPassword;
  final String password;
  MeEditPasswordEvent(this.me, this.originPassword, this.password);
}

class MeEditPasswordLoadingEvent extends MeEvent {
  final Me me;
  final String originPassword;
  final String password;
  MeEditPasswordLoadingEvent(this.me, this.originPassword, this.password);
}

class MeEditPasswordFailedEvent extends MeEvent {
  final Me me;
  final String originPassword;
  final String password;
  final Failure err;
  MeEditPasswordFailedEvent(
      this.me, this.originPassword, this.password, this.err);
}

class MeEditSucceededEvent extends MeEvent {
  final Me me;
  MeEditSucceededEvent({required this.me});
}

///

class MeLoadEvent extends MeEvent {
  final bool forceUpdate;
  MeLoadEvent({this.forceUpdate = false});
}

class MeBeginEditEvent extends MeEvent {}

class MeBeginEditPasswordEvent extends MeEvent {}

class MeBeginEditSavePasswordEvent extends MeEvent {
  String originPassword;
  String password;
  MeBeginEditSavePasswordEvent(
      {required this.originPassword, required this.password});
}

class MeLogoutEvent extends MeEvent {}

class MeRevertEditEvent extends MeEvent {}

class ResendTokenEvent extends MeEvent {}

class MeSaveEvent extends MeEvent {
  final CodeValidation? codeValidation;
  MeSaveEvent({this.codeValidation});
}

class MeChangeStepEvent extends MeEvent {
  final MeStep step;
  MeChangeStepEvent({required this.step});
}

class MeRequestValidationCodeEvent extends MeEvent {}

class MeChooseImageEvent extends MeEvent {
  final ImageSource source;
  MeChooseImageEvent(this.source);
}

class MeDeleteAccountEvent extends MeEvent {
  final Me me;
  MeDeleteAccountEvent(this.me);
}

class MeEditFailedEvent extends MeEvent {
  final Me me;
  final CodeRequest? codeRequest;
  final CodeValidation? codeValidation;
  final Failure err;
  MeEditFailedEvent(this.me, this.codeRequest, this.codeValidation, this.err);
}

class MeEditPhoneChangedEvent extends MeEvent {
  final Me me;
  MeEditPhoneChangedEvent(this.me);
}

class MeEditEmailChangedEvent extends MeEvent {
  final Me me;
  MeEditEmailChangedEvent(this.me);
}

class MeEditRequestingCodeEvent extends MeEvent {
  final Me me;
  MeEditRequestingCodeEvent(this.me);
}

class MeEditRequestingCodeFailedEvent extends MeEvent {
  final Me me;
  final Failure err;
  MeEditRequestingCodeFailedEvent(this.me, this.err);
}

class MeEditNoContactAvailableEvent extends MeEvent {
  final Me me;
  MeEditNoContactAvailableEvent(this.me);
}

class MeEditValidateCodeSuccessEvent extends MeEvent {
  final Me me;
  final CodeRequest codeRequest;
  MeEditValidateCodeSuccessEvent(this.me, this.codeRequest);
}

class MeUploadProfileFailedEvent extends MeEvent {
  final Me me;
  final Failure err;
  MeUploadProfileFailedEvent(this.me, this.err);
}

class MeUploadProfileSucceededEvent extends MeEvent {
  final Me me;
  MeUploadProfileSucceededEvent(this.me);
}

class MeUnauthenticatedEvent extends MeEvent {
  final Me me;
  MeUnauthenticatedEvent(this.me);
}

class MeDeleteSuccessEvent extends MeEvent {
  final Me me;
  MeDeleteSuccessEvent({required this.me});
}

class MeDeleteFailedEvent extends MeEvent {
  final Me me;
  MeDeleteFailedEvent({required this.me});
}
