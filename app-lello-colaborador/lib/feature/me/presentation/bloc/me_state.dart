import 'package:colaborador/feature/me/domain/entity/me.dart';
import 'package:essentials/essentials.dart';
import 'package:shared_features/shared_features.dart';

abstract class MeState extends Equatable {
  final Me? me;
  const MeState(this.me);

  @override
  List<Object?> get props => [me];
}

class MeInitialState extends MeState {
  const MeInitialState() : super(null);
}

class MeLoadingState extends MeState {
  const MeLoadingState({Me? me}) : super(me);
}

class MeLoadedState extends MeState {
  const MeLoadedState(super.me);
}

class MeLoadedCacheState extends MeLoadedState {
  const MeLoadedCacheState(Me super.me);
}

class MeLoadFailedState extends MeState {
  final Failure failure;
  const MeLoadFailedState(this.failure) : super(null);

  @override
  List<Object?> get props => [me, failure];
}

class MeUnauthenticatedState extends MeState {
  const MeUnauthenticatedState(super.me);
}

class MeEditState extends MeLoadedState {
  final CodeRequest? codeRequest;
  final CodeValidation? codeValidation;

  const MeEditState(super.me, {this.codeRequest, this.codeValidation});

  @override
  List<Object?> get props => [me, codeRequest, codeValidation];
}

class MeEditPasswordState extends MeLoadedState {
  const MeEditPasswordState(Me super.me, String originPassword, String password);
}

class MeEditPasswordLoadingState extends MeEditPasswordState {
  const MeEditPasswordLoadingState(super.me, super.originPassword, super.password);
}

class MeEditPasswordFailedState extends MeEditPasswordState {
  final Failure error;
  const MeEditPasswordFailedState(
      super.me, super.originPassword, super.password, this.error);

  @override
  List<Object?> get props => [me, error];
}

class MeEditPasswordSucceededState extends MeLoadedState {
  const MeEditPasswordSucceededState(
    Me super.me,
  );
}

class MeEditPhoneChangedState extends MeEditState {
  final bool isPhone;
  final bool isEmail;
  const MeEditPhoneChangedState({
    Me? me,
    this.isPhone = false,
    this.isEmail = false,
  }) : super(me);

  @override
  List<Object?> get props => [me, codeRequest, codeValidation, isPhone, isEmail];
}

class MeEditLoadingState extends MeEditState {
  const MeEditLoadingState(Me super.me, {super.codeRequest, super.codeValidation});
}

class MeEditSucceededState extends MeLoadedState {
  const MeEditSucceededState(
    Me super.me,
  );
}

class MeEditFailedState extends MeEditState {
  final Failure error;
  const MeEditFailedState(Me super.me, this.error,
      {super.codeRequest, super.codeValidation});

  @override
  List<Object?> get props => [me, codeRequest, codeValidation, error];
}

class MeUploadProfileLoadingState extends MeEditState {
  const MeUploadProfileLoadingState(Me super.me,
      {super.codeRequest, super.codeValidation});
}

class MeUploadProfileSucceededState extends MeLoadedState {
  const MeUploadProfileSucceededState(
    Me super.me,
  );
}

class MeUploadProfileFailedState extends MeLoadedState {
  final Failure error;
  const MeUploadProfileFailedState(
    Me super.me,
    this.error,
  );

  @override
  List<Object?> get props => [me, error];
}

class MeEditRequestingCodeState extends MeEditPhoneChangedState {
  const MeEditRequestingCodeState(
    Me me,
  ) : super(me: me);
}

class MeEditRequestCodeFailedState extends MeEditPhoneChangedState {
  final Failure failure;
  const MeEditRequestCodeFailedState(Me me, this.failure) : super(me: me);

  @override
  List<Object?> get props =>
      [me, codeRequest, codeValidation, isPhone, isEmail, failure];
}

class MeEditNoContactAvailableState extends MeEditPhoneChangedState {
  const MeEditNoContactAvailableState(Me me) : super(me: me);
}

class MeEditValidateCodeState extends MeEditState {
  const MeEditValidateCodeState(Me super.me, CodeRequest codeRequest)
      : super(codeRequest: codeRequest);
}

class MeDeleteAccountSuccessState extends MeState {
  const MeDeleteAccountSuccessState(
    Me super.me,
  );
}

class MeDeleteAccountFailedState extends MeState {
  const MeDeleteAccountFailedState(
    Me super.me,
  );
}
