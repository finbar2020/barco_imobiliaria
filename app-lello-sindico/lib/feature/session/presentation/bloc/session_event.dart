import 'package:essentials/functional/failure.dart';
import 'package:flutter/cupertino.dart';
import 'package:lello/feature/condominium/domain/entity/condominium.dart';
import 'package:lello/feature/consultant_lello/domain/entity/consultant_lello.dart';
import 'package:lello/feature/me/domain/entity/me.dart';

abstract class SessionEvent {}

class SessionEmptyEvent extends SessionEvent {
  SessionEmptyEvent();
}

class SessionLoadEvent extends SessionEvent {
  final bool onLogin;
  SessionLoadEvent({this.onLogin = false});
}

class SessionSelectCondominiumEvent extends SessionEvent {
  final Condominium condominium;
  final BuildContext context;
  SessionSelectCondominiumEvent(this.condominium, this.context);
}

class SessionGetConsultorEvent extends SessionEvent {
  final ConsultantEntity consultantEntity;
  SessionGetConsultorEvent(this.consultantEntity);
}

class SessionUpdateMeEvent extends SessionEvent {
  final Me? me;
  SessionUpdateMeEvent(this.me);
}

class SessionFailureEvent extends SessionEvent {
  final Failure? failure;
  SessionFailureEvent(this.failure);
}

class SessionLogoutEvent extends SessionEvent {
  final Failure? failure;
  final bool? restartApp;
  SessionLogoutEvent(this.failure, this.restartApp);
}
