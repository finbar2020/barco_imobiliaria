import 'package:essentials/essentials.dart';
import 'package:morar/feature/me/domain/entity/me.dart';
import 'package:shared_features/shared_features.dart';

class MeState {
  final Me me;
  MeState(this.me);
}

class MeLoadingState extends MeState {
  MeLoadingState(Me me) : super(me);
}

class MeLoadedState extends MeState {
  MeLoadedState(Me me) : super(me);
}

class MeLoadedCacheState extends MeLoadedState {
  MeLoadedCacheState(Me me) : super(me);
}

class MeLoadFailedState extends MeState {
  final Failure failure;
  MeLoadFailedState(Me me, this.failure) : super(me);
}

class MeUnauthenticatedState extends MeState {
  MeUnauthenticatedState(Me me) : super(me);
}

class MeEditState extends MeLoadedState {
  final CodeRequest? codeRequest;
  CodeValidation? codeValidation;

  MeEditState(Me me, {this.codeRequest, this.codeValidation}) : super(me);
}

class MeEditPasswordState extends MeLoadedState {
  MeEditPasswordState(Me me, String originPassword, String password)
      : super(me);
}

class MeEditPasswordLoadingState extends MeEditPasswordState {
  MeEditPasswordLoadingState(Me me, String originPassword, String password)
      : super(me, originPassword, password);
}

class MeEditPasswordFailedState extends MeEditPasswordState {
  final Failure error;
  MeEditPasswordFailedState(
      Me me, String originPassword, String password, this.error)
      : super(me, originPassword, password);
}

class MeEditPasswordSucceededState extends MeLoadedState {
  MeEditPasswordSucceededState(
    Me me,
  ) : super(me);
}

class MeEditPhoneChangedState extends MeEditState {
  MeEditPhoneChangedState(
    Me me,
  ) : super(me);
}

class MeEditEmailChangedState extends MeEditState {
  MeEditEmailChangedState(
    Me me,
  ) : super(me);
}

class MeEditLoadingState extends MeEditState {
  MeEditLoadingState(Me me,
      {CodeRequest? codeRequest, CodeValidation? codeValidation})
      : super(me, codeRequest: codeRequest, codeValidation: codeValidation);
}

class MeEditSucceededState extends MeLoadedState {
  MeEditSucceededState(
    Me me,
  ) : super(me);
}

class MeEditFailedState extends MeEditState {
  final Failure error;
  MeEditFailedState(Me me, this.error,
      {CodeRequest? codeRequest, CodeValidation? codeValidation})
      : super(me, codeRequest: codeRequest, codeValidation: codeValidation);
}

class MeUploadProfileLoadingState extends MeEditState {
  MeUploadProfileLoadingState(Me me,
      {CodeRequest? codeRequest, CodeValidation? codeValidation})
      : super(me, codeRequest: codeRequest, codeValidation: codeValidation);
}

class MeUploadProfileSucceededState extends MeLoadedState {
  MeUploadProfileSucceededState(
    Me me,
  ) : super(me);
}

class MeUploadProfileFailedState extends MeLoadedState {
  final Failure error;
  MeUploadProfileFailedState(
    Me me,
    this.error,
  ) : super(me);
}

class MeEditRequestingCodeState extends MeEditPhoneChangedState {
  MeEditRequestingCodeState(
    Me me,
  ) : super(me);
}

class MeEditRequestCodeFailedState extends MeEditPhoneChangedState {
  final Failure failure;
  MeEditRequestCodeFailedState(Me me, this.failure) : super(me);
}

class MeEditNoContactAvailableState extends MeEditPhoneChangedState {
  MeEditNoContactAvailableState(Me me) : super(me);
}

class MeEditValidateCodeState extends MeEditState {
  MeEditValidateCodeState(Me me, CodeRequest codeRequest)
      : super(me, codeRequest: codeRequest);
}

class MeDeleteAccountSuccessState extends MeState {
  MeDeleteAccountSuccessState(
    Me me,
  ) : super(me);
}

class MeDeleteAccountFailedState extends MeState {
  MeDeleteAccountFailedState(
    Me me,
  ) : super(me);
}
