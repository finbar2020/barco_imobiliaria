import 'package:essentials/essentials.dart';
import 'package:lello/feature/me/domain/entity/me.dart';

abstract class MeState {}

class MeEmptyState extends MeState {}

class MeLoadingState extends MeState {}

class MeLoadedState extends MeState {
  final Me? me;
  MeLoadedState({required this.me});
}

class MeLoadedCacheState extends MeLoadedState {
  @override
  final Me? me;
  MeLoadedCacheState({required this.me}) : super(me: me);
}

class MeLoadFailedState extends MeState {
  final Failure failure;
  MeLoadFailedState({required this.failure});
}

class MeUnauthenticatedState extends MeState {}

//Delete
class MeDeleteEmptyState extends MeState {}

class MeDeleteLoadingState extends MeState {}

class MeDeleteAccountFailedState extends MeState {
  Failure? failure;
  MeDeleteAccountFailedState({required this.failure});
}

class MeDeleteAccountSuccessState extends MeState {}

//Edit
class MeEditState extends MeState {
  final Me? me;
  MeEditState({required this.me});
}

class MeBeginEditState extends MeState {}

class MeEditPasswordState extends MeState {}

class MeEditPasswordLoadingState extends MeState {}

class MeEditPasswordFailedState extends MeState {
  final Failure failure;
  MeEditPasswordFailedState({required this.failure});
}

class MeEditPasswordSucceededState extends MeState {}

class MeEditPhoneChangedState extends MeState {
  bool isChangingEmail;
  bool isChangingPhone;
  MeEditPhoneChangedState(
      {this.isChangingEmail = false, this.isChangingPhone = false});
}

class MeEditLoadingState extends MeState {}

class MeEditSucceededState extends MeState {}

class MeEditFailedState extends MeState {
  final Failure failure;
  MeEditFailedState({required this.failure});
}

class MeUploadProfileLoadingState extends MeState {}

class MeUploadProfileSucceededState extends MeState {}

class MeUploadProfileFailedState extends MeState {
  final Failure failure;
  MeUploadProfileFailedState({required this.failure});
}

class MeEditRequestingCodeState extends MeState {}

class MeEditRequestCodeFailedState extends MeState {
  final Failure failure;
  MeEditRequestCodeFailedState({required this.failure});
}

class MeEditNoContactAvailableState extends MeState {}

class MeEditValidateCodeState extends MeState {}
