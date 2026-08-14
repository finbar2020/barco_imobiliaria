import 'package:essentials/essentials.dart';
import 'package:lello/feature/me/domain/entity/me.dart';

abstract class MeEvent {}

class MeEmptyEvent extends MeEvent {}

class MeLoadingEvent extends MeEvent {}

class MeLoadEvent extends MeEvent {
  bool forceUpdate;
  MeLoadEvent({this.forceUpdate = false});
}

class MeLoadedEvent extends MeEvent {
  final Me? me;
  MeLoadedEvent({required this.me});
}

class MeLoadedCacheEvent extends MeEvent {
  final Me? me;
  MeLoadedCacheEvent({required this.me});
}

class MeLoadFailedEvent extends MeEvent {
  final Failure failure;
  MeLoadFailedEvent({required this.failure});
}

class LogMeOutEvent extends MeEvent {}

class MeUnauthenticatedEvent extends MeEvent {}

//Delete
class MeDeleteEmptyEvent extends MeEvent {}

class MeDeleteLoadingEvent extends MeEvent {}

class MeDeleteAccountFailedEvent extends MeEvent {
  Failure? failure;
  MeDeleteAccountFailedEvent({required this.failure});
}

class MeDeleteAccountSuccessEvent extends MeEvent {}

//Edit
class MeEditEvent extends MeEvent {
  final Me? me;
  MeEditEvent({required this.me});
}

class MeBeginEditEvent extends MeEvent {}

class MeEditPasswordEvent extends MeEvent {}

class MeEditPasswordLoadingEvent extends MeEvent {}

class MeEditPasswordFailedEvent extends MeEvent {
  final Failure failure;
  MeEditPasswordFailedEvent({required this.failure});
}

class MeEditPasswordSucceededEvent extends MeEvent {}

class MeEditPhoneChangedEvent extends MeEvent {
  final bool isChangingEmail;
  final bool isChangingPhone;
  MeEditPhoneChangedEvent(
      {this.isChangingEmail = false, this.isChangingPhone = false});
}

class MeEditLoadingEvent extends MeEvent {}

class MeEditSucceededEvent extends MeEvent {}

class MeEditFailedEvent extends MeEvent {
  final Failure failure;
  MeEditFailedEvent({required this.failure});
}

class MeUploadProfileLoadingEvent extends MeEvent {}

class MeUploadProfileSucceededEvent extends MeEvent {}

class MeUploadProfileFailedEvent extends MeEvent {
  final Failure failure;
  MeUploadProfileFailedEvent({required this.failure});
}

class MeEditRequestingCodeEvent extends MeEvent {}

class MeEditRequestCodeFailedEvent extends MeEvent {
  final Failure failure;
  MeEditRequestCodeFailedEvent({required this.failure});
}

class MeEditNoContactAvailableEvent extends MeEvent {}

class MeEditValidateCodeEvent extends MeEvent {}
