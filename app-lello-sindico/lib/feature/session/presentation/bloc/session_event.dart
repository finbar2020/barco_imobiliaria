import 'package:essentials/essentials.dart';
import 'package:flutter/cupertino.dart';
import 'package:lello/feature/condominium/domain/entity/condominium.dart';
import 'package:lello/feature/consultant_lello/domain/entity/consultant_lello.dart';
import 'package:lello/feature/me/domain/entity/me.dart';

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

class SessionSelectCondominiumEvent extends SessionEvent {
  final Condominium condominium;
  final BuildContext context;

  const SessionSelectCondominiumEvent(this.condominium, this.context);

  @override
  List<Object?> get props => [condominium, context];
}

class SessionGetConsultorEvent extends SessionEvent {
  final ConsultantEntity consultantEntity;

  const SessionGetConsultorEvent(this.consultantEntity);

  @override
  List<Object?> get props => [consultantEntity];
}

class SessionUpdateMeEvent extends SessionEvent {
  final Me? me;

  const SessionUpdateMeEvent(this.me);

  @override
  List<Object?> get props => [me];
}

class SessionFailureEvent extends SessionEvent {
  final Failure? failure;

  const SessionFailureEvent(this.failure);

  @override
  List<Object?> get props => [failure];
}

class SessionLogoutEvent extends SessionEvent {
  final Failure? failure;
  final bool? restartApp;

  const SessionLogoutEvent(this.failure, this.restartApp);

  @override
  List<Object?> get props => [failure, restartApp];
}
