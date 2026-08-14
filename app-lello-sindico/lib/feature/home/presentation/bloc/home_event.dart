import 'package:essentials/essentials.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class ShowCondominiumSelectorHomeEvent extends HomeEvent {
  const ShowCondominiumSelectorHomeEvent();
}

class CollapseCondominiumSelectorHomeEvent extends HomeEvent {
  const CollapseCondominiumSelectorHomeEvent();
}

class RegisterFcmTokenEvent extends HomeEvent {
  final String? condominiumId;

  const RegisterFcmTokenEvent(this.condominiumId);

  @override
  List<Object?> get props => [condominiumId];
}
