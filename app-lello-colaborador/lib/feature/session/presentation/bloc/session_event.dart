import 'package:colaborador/feature/me/domain/entity/me.dart';
import 'package:essentials/essentials.dart';

abstract class SessionEvent extends Equatable {
  const SessionEvent();

  @override
  List<Object?> get props => [];
}

class SessionLoadEvent extends SessionEvent {
  final bool onLogin;
  final bool onlyLocal;

  const SessionLoadEvent({this.onLogin = false, this.onlyLocal = false});

  @override
  List<Object?> get props => [onLogin, onlyLocal];
}

class SessionUpdateMeEvent extends SessionEvent {
  final Me? me;

  const SessionUpdateMeEvent(this.me);

  @override
  List<Object?> get props => [me];
}

class SessionCheckTabletSessionExpiredEvent extends SessionEvent {
  const SessionCheckTabletSessionExpiredEvent();
}

class SessionLogoutEvent extends SessionEvent {
  final Failure? failure;
  final bool? restartApp;

  const SessionLogoutEvent(this.failure, this.restartApp);

  @override
  List<Object?> get props => [failure, restartApp];
}
