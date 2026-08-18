abstract class HomeEvent {}

class ShowCondominiumSelectorHomeEvent extends HomeEvent {}

class CollapseCondominiumSelectorHomeEvent extends HomeEvent {}

class RegisterFcmTokenEvent extends HomeEvent {
  final condominiumId;
  RegisterFcmTokenEvent(this.condominiumId);
}
