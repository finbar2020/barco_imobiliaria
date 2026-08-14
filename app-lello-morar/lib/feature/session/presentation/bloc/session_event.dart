import 'package:essentials/essentials.dart';
import 'package:morar/feature/home/domain/entity/unity.dart';
import 'package:morar/feature/me/domain/entity/condominium.dart';
import 'package:morar/feature/me/domain/entity/me.dart';

abstract class SessionEvent extends Equatable {
  const SessionEvent();

  @override
  List<Object?> get props => [];
}

class SessionEmptyEvent extends SessionEvent {
  const SessionEmptyEvent();
}

class SessionLoadEvent extends SessionEvent {
  final bool onLogin;

  const SessionLoadEvent({this.onLogin = false});

  @override
  List<Object?> get props => [onLogin];
}

class SessionSelectUnityEvent extends SessionEvent {
  final Unity unity;

  const SessionSelectUnityEvent(this.unity);

  @override
  List<Object?> get props => [unity];
}

class SessionSelectCondominiumEvent extends SessionEvent {
  final Condominium condominium;

  const SessionSelectCondominiumEvent(this.condominium);

  @override
  List<Object?> get props => [condominium];
}

class SessionUpdateMeEvent extends SessionEvent {
  final Me? me;

  const SessionUpdateMeEvent(this.me);

  @override
  List<Object?> get props => [me];
}

class SessionLogoutEvent extends SessionEvent {
  final Failure? failure;
  final bool? restartApp;

  const SessionLogoutEvent(this.failure, this.restartApp);

  @override
  List<Object?> get props => [failure, restartApp];
}
