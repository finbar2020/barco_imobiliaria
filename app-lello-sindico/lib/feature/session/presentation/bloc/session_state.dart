import 'package:essentials/essentials.dart';
import 'package:lello/feature/home/domain/entity/home_navigation_enum.dart';
import 'package:lello/feature/me/domain/entity/me.dart';
import 'package:lello/feature/session/domain/entity/session.dart';

abstract class SessionState {
  final Session? session;
  SessionState(this.session);
}

class SessionEmptyState extends SessionState {
  SessionEmptyState() : super(null);
}

class SessionLoadedState extends SessionState {
  final bool? switchFailed;
  List<HomeNavigationItemEnum>? itens;
  SessionLoadedState(Session super.session, {this.switchFailed, this.itens});
}

class SessionLoadingState extends SessionState {
  SessionLoadingState(Session super.session);
}

class SessionFailedState extends SessionState {
  final Failure failure;
  final Me? user;
  SessionFailedState(this.failure, this.user) : super(null);
}
